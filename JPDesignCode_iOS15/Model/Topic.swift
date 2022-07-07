//
//  Topic.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/7/4.
//

import SwiftUI

struct Topic: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}

let topics = [
    Topic(title: "iOS Development", icon: "iphone"),
    Topic(title: "UI Design", icon: "eyedropper"),
    Topic(title: "Web development", icon: "laptopcomputer")
]
