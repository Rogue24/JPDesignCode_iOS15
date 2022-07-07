//
//  Model.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/20.
//

import SwiftUI
import Combine

class Model: ObservableObject {
    @Published var showDetail: Bool = false
    @Published var selectedModal: Modal = .signIn
}

enum Modal: String {
    /// 注册
    case signUp
    /// 登录
    case signIn
}
