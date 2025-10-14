//
//  Untitled.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import FoundationModels

@Generable
struct AIHaiku {
    @Guide(description: """
    5文字程度の俳句の上の句
    """)
    let upper: String
    
    @Guide(description: """
    7文字程度の俳句の中の句
    """)
    let middle: String
    
    
    @Guide(description: """
    5文字程度の俳句の下の句
    """)
    let lower: String
}
