import SwiftUI

struct ColoredImage: View {
    @Environment(\.appColor) var color: Color.App
    let imageName: String

    var body: some View {
        ZStack {
            Image("\(imageName)-color")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(color.primary)
            Image("\(imageName)-foreground")
                .resizable()
        }
        .aspectRatio(contentMode: .fit)
    }
}
