//
//  Typography.swift
//  Drinks
//
//  Created by Gabriel Muelas on 10/10/22.
//

import SwiftUI

private let appFontName = "IndieFlower"

extension Font {
    private static func appFont(size: CGFloat) -> Font {
        return Font.custom(appFontName, size: size)
    }

    enum App {
        static let title = appFont(size: 56)
        static let paragraph = appFont(size: 24)
        static let footnote = appFont(size: 14)
    }
}

extension UIFont {
    enum App {
        static let promptTitle = UIFont(name: appFontName, size: 56)
        static let prompt = UIFont.systemFont(ofSize: 40)
    }
}
