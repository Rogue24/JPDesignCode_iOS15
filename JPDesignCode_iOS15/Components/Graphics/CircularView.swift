//
//  CircularView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/7/3.
//

import SwiftUI

struct CircularView: View {
    let value: CGFloat
    var lineWidth: Double = 4
    @State var appear = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: appear ? value : 0)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .fill(.angularGradient(colors: [.purple, .pink, .purple], center: .center, startAngle: .degrees(0), endAngle: .degrees(360))) // 圆弧渐变（顺时针一圈）
            .rotationEffect(.degrees(270)) // 初始位置修正为顶部中间
            .onAppear() {
                withAnimation(.spring()) {
                    appear = true
                }
            }
            .onDisappear() {
                appear = false
            }
    }
    
//    @State var toValue: CGFloat = 0.5
//    var testCircle: some View {
//        VStack {
//            Circle()
//                .trim(from: 0, to: toValue)
//                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
//                // 圆弧渐变（顺时针一圈）
//                .fill(.angularGradient(colors: [.purple, .pink], center: .center, startAngle: .degrees(0), endAngle: .degrees(360)))
//                .rotationEffect(.degrees(270)) // 初始位置修正为顶部中间
//                .padding()
//
//            Slider(value: $toValue, in: 0...1)
//                .padding()
//        }
//    }
}

struct CircularView_Previews: PreviewProvider {
    static var previews: some View {
        CircularView(value: 0.3)
    }
}
