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
