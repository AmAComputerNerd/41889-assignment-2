//
//  ColorExtensions.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 27/4/2025.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex);
        var hexNumber: UInt64 = 0;
        
        if scanner.scanHexInt64(&hexNumber) {
            let r = Double((hexNumber >> 16) & 0xFF) / 255.0;
            let g = Double((hexNumber >> 8) & 0xFF) / 255.0;
            let b = Double(hexNumber & 0xFF) / 255.0;
            self = Color(red: r, green: g, blue: b);
        } else {
            self = Color.black
        }
    }
}
