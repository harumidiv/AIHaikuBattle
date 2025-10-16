//
//  HaikuModel.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/14.
//

import Foundation
import SwiftData

@Model
final class HaikuModel: Equatable {
    var upper: String
    var middle: String
    var lower: String
    var name: String
    
    // Equatableに準拠するための==演算子を定義
    static func == (lhs: HaikuModel, rhs: HaikuModel) -> Bool {
        return lhs.upper == rhs.upper &&
               lhs.middle == rhs.middle &&
               lhs.lower == rhs.lower &&
               lhs.name == rhs.name
    }
    
    init(upper: String, middle: String, lower: String, name: String) {
        self.upper = upper
        self.middle = middle
        self.lower = lower
        self.name = name
    }
    
    init(haiku: Haiku) {
        self.upper = haiku.upper
        self.middle = haiku.middle
        self.lower = haiku.lower
        self.name = haiku.name
    }
}
