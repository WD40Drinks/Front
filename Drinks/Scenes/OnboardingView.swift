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
        case .terms: TermsView(continueButtonAction: changeOnboardingState)
        case .swipe: SwipeView(viewModel: viewModel)
        }
    }

    func changeOnboardingState() {
        state = .swipe
    }
}

struct TermsView: View {
    @State private var showingTermsSheet = false
    let continueButtonAction: () -> Void

    var body: some View {
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
                .padding(.horizontal, 56)
            Text("ao continuar você concorda com os termos e condições")
                .font(.App.paragraph)
                .multilineTextAlignment(.center)
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

struct TermsSheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Group {
                Text("1. ESSE JOGO É DESTINADO PARA MAIORES DE 18 ANOS ")
                // swiftlint:disable:next line_length
                Text("O consumo de álcool por menores pode acarretar problemas legais (para menores e para aqueles que oferecem álcool), atrapalhar o desenvolvimento cerebral e sexual além de interromper o crescimento.")
                Text("(Underage drinking, Center for Disease Control and Prevention)")
                Text("2. SE BEBER NÃO DIRIJA")
                // swiftlint:disable:next line_length
                Text("O álcool reduz a capacidade de julgamento de velocidade e distância, aumenta a tendência de tomar riscos, reduz a coordenação e concentração, aumenta o tempo de reação, prejudica a visão e a percepção de obstáculos.")
                Text("(Behind the wheel: the dangers of drink driving, DrinkWise)")
                Text("3. RESPEITE OS SEUS LIMITES E OS LIMITES DOS OUTROS JOGADORES")
            }
            Image("fishes-circle")
        }
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
    var viewModel: ContentViewModel<MockGameFactory>

    var body: some View {
        VStack {
            Text("junte a galera numa roda")
                .font(.App.paragraph)
            Text("Arrasta pro próximo jogo")
                .font(.App.title)
            Image("swipe-gesture")
        }
        .onTapGesture {
            viewModel.initiateGame()
            print("Tapped to change view")
        }
    }
}
