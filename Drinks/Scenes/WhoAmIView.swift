//
//  WhoAmIView.swift
//  Drinks
//
//  Created by Eduardo Dini on 24/11/22.
//

import SwiftUI
import Combine

struct WhoAmI: View {

    enum WhoAmIStates {
        case starting
        case started
    }

    @State private var didStart = false
    @State private var timeToStart = 5
    @State private var timeRemaining = 100
    @State private var gameState: WhoAmIStates = .starting

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        switch gameState {
        case .starting:
            startingView
        case .started:
            startedView
        }
    }

    private var startingView: some View {
        VStack {
            Spacer()
            Text("Time: \(timeToStart)")
            Spacer()
        }
        .onReceive(timer) { _ in
            if !didStart && timeToStart > 0 {
                timeToStart -= 1
            } else if timeToStart == 0 {
                didStart = true
                gameState = .started
            }
        }
    }

    private var startedView: some View {
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
                    .font(.App.title)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 200)
                    .padding(.horizontal, 32)
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
