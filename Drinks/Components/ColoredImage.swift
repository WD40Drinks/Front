import SwiftUI

struct ColoredImage: View {
    @Environment(\.appColor) var color: Color.App
    let colorImageURL: String?
    let foregroundImageURL: String?

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: colorImageURL ?? "")) { image in
                image
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(color.primary)
            } placeholder: { EmptyView() }

            AsyncImage(url: URL(string: foregroundImageURL ?? "")) { image in
                image.resizable()
            } placeholder: { EmptyView() }
        }
        .aspectRatio(contentMode: .fit)
    }
}
