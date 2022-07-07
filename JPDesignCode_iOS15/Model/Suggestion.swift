//
//  Suggestion.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/25.
//

import SwiftUI

struct Suggestion: Identifiable {
    let id = UUID()
    let text: String
}

let suggestions = [
    Suggestion(text: "SwiftUI"),
    Suggestion(text: "React"),
    Suggestion(text: "UI Design"),
]
