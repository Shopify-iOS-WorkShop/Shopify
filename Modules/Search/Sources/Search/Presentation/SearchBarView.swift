//
//  SwiftUIView.swift
//  Search
//
//  Created by Al3dwy on 30/06/2026.
//

import SwiftUI

struct SearchBarView: View {
    var body: some View {
        HStack{
            Text("PocketShop")
                .font(.system(size: 34, weight: .bold , design: .default ))
                .foregroundStyle(.primary)
                
            Spacer()
            Image(systemName: "cart")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.primary)
                
        }
    }
}

//#Preview {
//    SwiftUIView()
//}
