import SwiftUI

struct OnboardingView: View {
    enum OnboardingStates {
        case terms
        case swipe
    }

    var viewModel: ContentViewModel<MockGameFactory>
    @State private var state: OnboardingStates = .terms

    var body: some View {
        switch state {
        case .terms: TermsView(continueButtonAction: changeOnboardingStateToSwipe)
        case .swipe: SwipeView(viewModel: viewModel)
        }
    }

    func changeOnboardingStateToSwipe() {
        state = .swipe
    }
}

struct TermsView: View {
    @State private var showingTermsSheet = false
    let continueButtonAction: () -> Void

    var body: some View {
        VStack {
            VStack {
                Image("caneco")
                    .frame(
                        width: 0.355 * UIScreen.main.bounds.height,
                        height: 0.237 * UIScreen.main.bounds.height
                    )
                Text("Caneco")
                    .font(.App.title)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 200)
            }
            Text("ao continuar você concorda com os termos e condições")
                .font(.App.paragraph)
                .multilineTextAlignment(.center)
            VStack(spacing: 22) {
                ZStack {
                    Image("button-fill")
                    Text("Continuar")
                        .font(.App.paragraph)
                }
                .onTapGesture {
                    continueButtonAction()
                }
                ZStack {
                    Image("button")
                    Text("Ler termos")
                        .font(.App.paragraph)
                }
                .onTapGesture {
                    showingTermsSheet.toggle()
                }
                .sheet(isPresented: $showingTermsSheet) {
                    NavigationView {
                        TermsSheetView()
                    }
                }
            }
        }
    }
}

struct TermsSheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("1. ESSE JOGO É DESTINADO PARA MAIORES DE 18 ANOS ")
                // swiftlint:disable:next line_length
                Text("O consumo de álcool por menores pode acarretar problemas legais (para menores e para aqueles que oferecem álcool), atrapalhar o desenvolvimento cerebral e sexual além de interromper o crescimento.")
                Text("(Underage drinking, Center for Disease Control and Prevention)")
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("2. SE BEBER NÃO DIRIJA")
                // swiftlint:disable:next line_length
                Text("O álcool reduz a capacidade de julgamento de velocidade e distância, aumenta a tendência de tomar riscos, reduz a coordenação e concentração, aumenta o tempo de reação, prejudica a visão e a percepção de obstáculos.")
                Text("(Behind the wheel: the dangers of drink driving, DrinkWise)")
            }
            VStack(alignment: .leading) {
                Text("3. RESPEITE OS SEUS LIMITES E OS LIMITES DOS OUTROS JOGADORES")
            }
            HStack {
                Spacer()
                Image("fishes-circle")
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("Termos e condições")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Ok") {
                    dismiss()
                }
            }
        }
    }
}

struct SwipeView: View {
    @State private var isRotating = 0.0
    var viewModel: ContentViewModel<MockGameFactory>

    var animation: Animation {
        Animation.linear
        .repeatForever(autoreverses: false)
    }

    var body: some View {
        VStack {
            Text("junte a galera numa roda")
                .font(.App.paragraph)
                .padding(.bottom, 40)
            VStack(spacing: 8) {
                Text("Arrasta pro próximo jogo")
                    .font(.App.title)
                Image("text-highlight")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.App.yellow.primary)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 140)
            }
            .padding(.bottom, 60)
            HStack {
                Spacer()
                VStack {
                    Image("arrow-left")
                    Image("swipe-gesture")
                        .animation(animation)
                        .padding(.trailing, 20)
                        .rotationEffect(.degrees(isRotating))
                        .onAppear {
                            withAnimation(.linear(duration: 1)
                                .speed(0.7).repeatForever(autoreverses: false)) {
                                    isRotating = -45.0
                                }
                        }
                }

            }

        }
        .gesture(startGameGesture)
    }

    private var startGameGesture: some Gesture {
        DragGesture().onEnded { value in
            guard !viewModel.isTransitioning else { return }
            let didSwipeHorizontally = abs(value.translation.width) > abs(value.translation.height)
            let didSwipeLeft = value.predictedEndTranslation.width < -60
            if didSwipeHorizontally && didSwipeLeft {
                viewModel.initiateGame()
            }
        }
    }
}
