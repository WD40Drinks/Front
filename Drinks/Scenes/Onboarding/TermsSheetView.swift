import SwiftUI

struct TermsSheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("terms-title-one")
                Text("terms-text-one")
                Text("terms-subtext-one")
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("terms-title-two")
                Text("terms-text-two")
                Text("terms-subtext-two")
            }
            VStack(alignment: .leading) {
                Text("terms-title-three")
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
                Button("OK") {
                    dismiss()
                }
            }
        }
    }
}
