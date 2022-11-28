import SwiftUI

struct ColoredImage: View {
    @Environment(\.appColor) var color: Color.App
    let colorImageURL: String?
    let foregroundImageURL: String?

    var body: some View {
        ZStack {
            AsyncImage(
                url: URL(string: colorImageURL ?? ""),
                content: { image in
                    image
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(color.primary)
                },
                placeholder: { EmptyView() }
            )

            AsyncImage(
                url: URL(string: foregroundImageURL ?? ""),
                content: { $0.resizable() },
                placeholder: { EmptyView() }
            )
        }
        .aspectRatio(contentMode: .fit)
    }
}
