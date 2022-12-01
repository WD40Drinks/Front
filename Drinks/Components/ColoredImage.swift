import SwiftUI

struct ColoredImage: View {
    @Environment(\.appColor) var color: Color.App
    let colorImageURL: String?
    let foregroundImageURL: String?
    let isMinigame: Bool

    var body: some View {
        ZStack {
            if isMinigame {
                Image("play-color")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(color.primary)

                Image("play-foreground")
                    .resizable()
            }

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
