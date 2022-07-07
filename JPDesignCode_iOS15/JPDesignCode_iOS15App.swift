//
//  JPDesignCode_iOS15App.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/5/8.
//

import SwiftUI

@main
struct JPDesignCode_iOS15App: App {
    // @StateObject对象可以确保不会在App的生命周期内多次调用（重复创建&销毁）此数据。
    // 意思是能保证在`祖先View`及其`子孙View`内使用的都是同一个模型对象
    @StateObject var model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView() // 👉🏻👉🏻👉🏻 祖先View
                // 声明一个环境变量，给到`祖先View`及其`子孙View`一起共同使用
                .environmentObject(model)
            
//            StateObjectTestView()
            
//            NavigationView {
//                NavigationLink("Goto StateObjectTestView()", destination: StateObjectTestView())
//            }
        }
    }
}
