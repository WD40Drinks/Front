import SwiftUI

struct TermsView<Factory: GameFactory>: View {
    @State private var showingTermsSheet = false
    var viewModel: ContentViewModel<Factory>

    var body: some View {
        VStack {
            VStack {
                Image("caneco")
                    .frame(
                        width: 0.355 * UIScreen.main.bounds.height,
                        height: 0.237 * UIScreen.main.bounds.height
                    )
                    .padding(.top, 16)
                Text("Caneco")
                    .font(.App.title)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 150)
            }
            Text("continue-conditions")
                .padding(.horizontal, 16)
                .font(.App.paragraph)
                .multilineTextAlignment(.center)
            VStack(spacing: 16) {
                ZStack {
                    Image("button-fill")
                    Text("continue-button")
                        .font(.App.paragraph)
                }
                .onTapGesture {
                    viewModel.goToTutorial()
                }
                ZStack {
                    Image("button")
                    Text("read-terms-button")
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
