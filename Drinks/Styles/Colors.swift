import SwiftUI

extension Color {
    init(r: Double, g: Double, b: Double) {
        self.init(red: r/255, green: g/255, blue: b/255)
    }

    enum App: CaseIterable {
        case yellow
        case red
        case blue
        case green
        case purple

        var primary: Color {
            switch self {
            case .yellow:
                return Color(r: 248, g: 202, b: 88)
            case .red:
                return Color(r: 236, g: 101, b: 100)
            case .blue:
                return Color(r: 60, g: 129, b: 191)
            case .green:
                return Color(r: 152, g: 198, b: 72)
            case .purple:
                return Color(r: 144, g: 124, b: 182)
            }
        }

        var secondary: Color {
            switch self {
            case .yellow:
                return Color(r: 248, g: 223, b: 161)
            case .red:
                return Color(r: 236, g: 170, b: 170)
            case .blue:
                return Color(r: 117, g: 156, b: 191)
            case .green:
                return Color(r: 173, g: 198, b: 131)
            case .purple:
                return Color(r: 196, g: 179, b: 229)
            }
        }

        var light: Color {
            switch self {
            case .yellow:
                return Color(r: 254, g: 247, b: 230)
            case .red:
                return Color(r: 252, g: 232, b: 232)
            case .blue:
                return Color(r: 236, g: 243, b: 249)
            case .green:
                return Color(r: 244, g: 249, b: 235)
            case .purple:
                return Color(r: 241, g: 239, b: 246)
            }
        }

        static var random: Self {
            allCases.randomElement() ?? .yellow
        }
    }
}

private struct AppColorKey: EnvironmentKey {
    static let defaultValue = Color.App.yellow
}

extension EnvironmentValues {
    var appColor: Color.App {
        get { self[AppColorKey.self] }
        set { self[AppColorKey.self] = newValue }
    }
}

extension View {
    func appColor(_ color: Color.App) -> some View {
        environment(\.appColor, color)
    }
}
