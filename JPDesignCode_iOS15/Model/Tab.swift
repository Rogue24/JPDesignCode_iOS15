//
//  Tab.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/5.
//

import SwiftUI

enum Tab: String {
    case home
    case explore
    case notificcations
    case library
}

struct TabItem: Identifiable {
    let id = UUID()
    let text: String
    let icon: String
    let tab: Tab
    let color: Color
}

let tabItems = [
    TabItem(text: "Learn Now", icon: "house", tab: .home, color: .teal),
    TabItem(text: "Explore", icon: "magnifyingglass", tab: .explore, color: .blue),
    TabItem(text: "Notifications", icon: "bell", tab: .notificcations, color: .red),
    TabItem(text: "Library", icon: "rectangle.stack", tab: .library, color: .pink),
]
