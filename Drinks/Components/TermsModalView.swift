//
//  TermsModalView.swift
//  Drinks
//
//  Created by Eduardo Dini on 09/11/22.
//

import SwiftUI

struct TermsModalView: View {
    @Binding var isOpen: Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text("Hello, World!")
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button("Close") {
            isOpen.toggle()
        }
    }
}
