//
//  HaikuEvaluation.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import FoundationModels

@Generable
struct HaikuEvaluation {
    @Guide(description: """
    １００点満点で採点してください。
    採点は正確に行います。
    - 五七五が崩れている場合、大幅減点
    - 季語が使われていない、または不自然な場合、減点
    - 意味不明・情景が浮かばない・リズムが悪い場合、減点
    - 完成度が高く心に響く場合のみ80点以上を与えてください。
    50点未満は「下手な俳句」と見なします。
    """)
    let score: Int
    
    @Guide(description: "季語が活きているか、五・七・五のリズムが良いか「切字」が効果的か、独創性があるか、情景が目に浮かぶか、感想をコメントして")
    let comment: String
}
