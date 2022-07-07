//
//  Animations.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/19.
//

import SwiftUI

extension Animation {
    static let openCard = Animation.spring(response: 0.5, dampingFraction: 0.7)
    static let closeCard = Animation.spring(response: 0.6, dampingFraction: 0.9)
}
