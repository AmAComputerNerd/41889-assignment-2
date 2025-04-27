//
//  Reflection.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 27/4/2025.
//

import Foundation

class Reflection {
    static func getClassName(type: Any.Type) -> String {
        return String(describing: type)
    }
}
