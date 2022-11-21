//
//  Typography.swift
//  Drinks
//
//  Created by Gabriel Muelas on 10/10/22.
//

import SwiftUI

extension Font {
    private static let fontName = "IndieFlower"

    private static func appFont(size: CGFloat) -> Font {
        return Font.custom(fontName, size: size)
    }

    enum App {
        static let title = appFont(size: 56)
        static let paragraph = appFont(size: 24)
        static let footnote = appFont(size: 14)
        static let prompt = Font.system(size: 40)
    }
}

extension UIFont {
    enum App {
        static let prompt = UIFont.systemFont(ofSize: 40)
    }
}
