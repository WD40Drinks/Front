//
//  ConfigurationView.swift
//  Drinks
//
//  Created by Gabriel Muelas on 07/11/22.
//

import SwiftUI

struct ConfigurationView: View {
    @State var teste: Bool = false

    var body: some View {
        Toggle("hello", isOn: $teste)
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
    }
}
