//
//  Background.swift
//  Drinks
//
//  Created by Gabriel Muelas on 10/10/22.
//

import SwiftUI

struct GridView<Content: View>: View {
    let color: Color.App
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            color.light

            Image("grid-background")
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .foregroundColor(color.primary)
                .edgesIgnoringSafeArea(.all)

            content()
        }
    }
}
