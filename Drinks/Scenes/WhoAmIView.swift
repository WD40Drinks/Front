//
//  WhoAmIView.swift
//  Drinks
//
//  Created by Eduardo Dini on 24/11/22.
//

import SwiftUI
import Combine

struct WhoAmI: View {
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                Text("Fátima Bernardes")
                Spacer()
            }
            Spacer()
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
}
