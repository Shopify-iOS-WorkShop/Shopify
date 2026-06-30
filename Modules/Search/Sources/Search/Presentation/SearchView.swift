//
//  SwiftUIView.swift
//  Search
//
//  Created by Al3dwy on 30/06/2026.
//

import SwiftUI

public struct SearchView: View {
    @State private var searchText: String = ""
   public init() {}
    public var body: some View {
        VStack(spacing : 15) {
            SearchBarView()
            .padding(.horizontal, 20)
            .padding(.top , 12)
            HStack(spacing: 8) {
                TextField("Search", text: $searchText)
                Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
            }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 20)
            Spacer()
        }
    }
}

//#Preview {
//    SearchView()
//}
