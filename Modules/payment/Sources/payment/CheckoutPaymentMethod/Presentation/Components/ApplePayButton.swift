//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/07/2026.
//

import Foundation
import SwiftUI
import PassKit

struct ApplePayButton: UIViewRepresentable {
    var action: () -> Void
    
    func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(paymentButtonType: .checkout, paymentButtonStyle: .black)
        button.addTarget(context.coordinator, action: #selector(Coordinator.tapped), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: PKPaymentButton, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(action: action) }
    
    class Coordinator: NSObject {
        var action: () -> Void
        init(action: @escaping () -> Void) { self.action = action }
        @objc func tapped() { action() }
    }
}
