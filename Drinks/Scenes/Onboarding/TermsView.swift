import SwiftUI

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
            Text("continue-conditions")
                .font(.App.paragraph)
                .multilineTextAlignment(.center)
            VStack(spacing: 22) {
                ZStack {
                    Image("button-fill")
                    Text("continue-button")
                        .font(.App.paragraph)
                }
                .onTapGesture {
                    continueButtonAction()
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
