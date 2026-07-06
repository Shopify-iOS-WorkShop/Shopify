//
//  AddAddressViewModel.swift
//  Address
//
//  Created by Mina Nashaat on 05/07/2026.
//

import Foundation
import Observation
import MapKit
import CoreLocation

@Observable
public final class AddAddressViewModel: NSObject {

    // MARK: - Form state

    public var draft: AddressDraft
    public var searchText: String = "" {
        didSet { searchCompleter.queryFragment = searchText }
    }

    public var suggestions: [MKLocalSearchCompletion] = []
    public var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.0131, longitude: 31.2089), // Giza, EG fallback
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    public var pinCoordinate: CLLocationCoordinate2D?

    /// Drives the green "Address Verified" banner — true once we have a
    /// geocoded street + city for the current pin.
    public var isAddressVerified: Bool = false

    public var isSaving: Bool = false
    public var isLocating: Bool = false
    public var errorMessage: String?

    /// Set once save succeeds, so the view can pop and the list can update.
    public var savedAddress: Address?

    // MARK: - Dependencies

    private let addUseCase: AddAddressUseCase
    private let updateUseCase: UpdateAddressUseCase
    private let searchCompleter = MKLocalSearchCompleter()
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    public init(
        addUseCase: AddAddressUseCase,
        updateUseCase: UpdateAddressUseCase,
        editing address: Address? = nil
    ) {
        self.addUseCase = addUseCase
        self.updateUseCase = updateUseCase
        self.draft = address.map(AddressDraft.init(editing:)) ?? AddressDraft()
        super.init()

        searchCompleter.resultTypes = .address
        searchCompleter.delegate = self
        locationManager.delegate = self

        if let address, let lat = address.latitude, let lon = address.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            pinCoordinate = coordinate
            region.center = coordinate
            isAddressVerified = true
            searchText = address.oneLineAddress
        }
    }

    // MARK: - Search

    public func selectSuggestion(_ completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            guard let self, let mapItem = response?.mapItems.first else { return }
            let coordinate = mapItem.placemark.coordinate
            Task { @MainActor in
                self.movePin(to: coordinate)
                self.searchText = completion.title
                self.suggestions = []
            }
        }
    }

    // MARK: - Map interaction

    @MainActor
    public func movePin(to coordinate: CLLocationCoordinate2D) {
        pinCoordinate = coordinate
        region.center = coordinate
        reverseGeocode(coordinate)
    }

    @MainActor
    public func useCurrentLocation() {
        isLocating = true
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            isLocating = false
            errorMessage = "Enable location access in Settings to use your current location."
        }
    }

    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self, let placemark = placemarks?.first else { return }
            Task { @MainActor in
                self.draft.street = [placemark.subThoroughfare, placemark.thoroughfare]
                    .compactMap { $0 }
                    .joined(separator: " ")
                self.draft.city = placemark.locality ?? placemark.subAdministrativeArea ?? ""
                self.draft.country = placemark.country ?? ""
                self.draft.countryCode = placemark.isoCountryCode ?? ""
                self.draft.postalCode = placemark.postalCode ?? ""
                self.draft.latitude = coordinate.latitude
                self.draft.longitude = coordinate.longitude
                self.isAddressVerified = !self.draft.street.isEmpty && !self.draft.city.isEmpty
            }
        }
    }

    // MARK: - Save

    @MainActor
    public func save() async {
        guard draft.isValid else {
            errorMessage = "Please fill in the recipient, phone, street and city."
            return
        }

        isSaving = true
        errorMessage = nil

        do {
            let address = draft.isEditing
                ? try await updateUseCase.execute(draft)
                : try await addUseCase.execute(draft)
            savedAddress = address
        } catch {
            errorMessage = error.localizedDescription
        }

        isSaving = false
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension AddAddressViewModel: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            self.suggestions = completer.results
        }
    }

    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Non-fatal: suggestions just stay empty.
    }
}

// MARK: - CLLocationManagerDelegate

extension AddAddressViewModel: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        } else if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            Task { @MainActor in
                self.isLocating = false
                self.errorMessage = "Enable location access in Settings to use your current location."
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        Task { @MainActor in
            self.isLocating = false
            self.movePin(to: coordinate)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.isLocating = false
            self.errorMessage = "Couldn't determine your current location."
        }
    }
}
