//
//  AngularButtonStyle.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/26.
//

import SwiftUI

struct AngularButtonStyle: ButtonStyle {
    // `controlSize`跟`colorScheme`一样都是环境变量，
    // 自定义的`Modifier`都可以通过`@Environment`获取【所处视图树】下设置的环境变量。
    @Environment(\.controlSize) var controlSize
    
    /// 系统提供的`ButtonStyle`都会根据`controlSize`提供不同的样式（如`padding`），
    /// 自定义的`ButtonStyle`并不会有根据`controlSize`默认自带的样式，
    /// 而是【根据需求】来自定义。
    
    var extraPadding: CGFloat {
        switch controlSize {
        case .large:
            return 12
        default:
            return 0
        }
    }
    
    var cornerRadius: CGFloat {
        switch controlSize {
        case .regular:
            return 16
        case .large:
            return 20
        default:
            return 12
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 10 + extraPadding)
            .padding(.vertical, 4 + extraPadding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    // 线性渐变（从上到下）
                    .fill(.linearGradient(colors: [Color(.systemBackground),
                                                   Color(.systemBackground).opacity(0.6)],
                                          startPoint: .top,
                                          endPoint: .bottom))
                    .blendMode(.softLight) // 跟底下的圆弧渐变颜色浅混合
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    // 圆弧渐变（顺时针一圈）
                    .fill(.angularGradient(colors: [.pink, .purple, .blue, .pink],
                                           center: .center,
                                           startAngle: .degrees(-90),
                                           endAngle: .degrees(270)))
                    .blur(radius: cornerRadius)
            )
            .strokeStyle(cornerRadius: cornerRadius)
    }
}

extension ButtonStyle where Self == AngularButtonStyle {
    static var angular: Self { .init() }
}
