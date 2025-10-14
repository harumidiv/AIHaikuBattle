//
//  File.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/14.
//

import UIKit

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
