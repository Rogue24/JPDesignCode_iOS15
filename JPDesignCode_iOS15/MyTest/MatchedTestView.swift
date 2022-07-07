//
//  MatchedTestView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/18.
//

import SwiftUI

/**
 * `matchedGeometryEffect`：匹配几何效果的Modifier
 * 能够对共享元素进行动画处理，实现两个视图之间无缝过渡的效果
 *
 * 使用这个`Modifier`，标记需要过渡的两个`View`，
 * 当一个`View`过渡到另一个`View`后，系统就不用重复显示两个【一样的View】了，
 * 能让系统知道这两个其实都是【同一个View】，从而底层进行优化。
 *
 * `id`：匹配的唯一标识
 * 要匹配的那两个`View`设置的这个`id`一定要一样
 *
 * `isSource`：是否源头
 * 两个`View`至少要有一个要设置该属性，好让系统知道是从哪个`View`开始过渡到另一个`View`
 * 所以要用状态值`show`，`show`之前为``true``，说明从这个`View`开始，`show`之后会``false``，说明从另一个`View`回来
 *
 * `matchedGeometryEffect`跟`Animation`一样：
 * 如果已经对一个`View`添加了匹配几何效果（这个`View`已经有过渡效果了），这时候也可以对这个`父View`的某个`子View`单独添加，这样`子View`能有自己的过渡效果，可以跟`父View`的过渡效果同时存在并且互不影响。
 */

struct MatchedTestView: View {
    @Namespace var namespace
    @State var show = false
    
    var body: some View {
        ZStack {
            // 使用`matchedGeometryEffect`实现切换两个不同视图时能带有过渡的动画效果
            // 哪些视图需要过渡就给哪些视图加上`matchedGeometryEffect`，只要设置不同的`id`过渡则相互独立
            //【注意1】：是两个不同视图，而不是同一个视图的简单位移，因此这两个视图的样式（如字体）最好保持一致，否则过渡会有割裂感
            //【注意2】：如果一个视图内有多个子视图，并且只有部分子视图带上`matchedGeometryEffect`，那么也只有这部分的子视图才会有视图之间过渡的动画效果，而其余子视图则自动以【淡入淡出】的动画效果进行过渡（只要有一个子视图带有`matchedGeometryEffect`的情况下）
            if !show {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Hello, World!")
                        .font(.largeTitle.weight(.bold)) // 不想要动画效果的（如字体）要在`matchedGeometryEffect`【之前】添加
                        .matchedGeometryEffect(id: "title", in: namespace)
                        .frame(maxWidth: .infinity, alignment: .leading) // 想要动画效果的（如位置）就要在`matchedGeometryEffect`【之后】添加
                    Text("Learn SwiftUI")
                        .font(.footnote.weight(.semibold))
                        .matchedGeometryEffect(id: "subtitle", in: namespace)
                    Text("Build an iOS app for iOS 15 with custom layouts, animations and ...")
                        .font(.footnote)
                        .matchedGeometryEffect(id: "text", in: namespace)
                }
                .padding(20)
                .foregroundColor(.teal) // 没有带`matchedGeometryEffect`的子视图会自动以【淡入淡出】的动画效果进行过渡
                .background(
                    Color.primary
                        .matchedGeometryEffect(id: "background", in: namespace)
                )
                .padding(20)
            } else {
                VStack(alignment: .center, spacing: 12) {
                    Spacer()
                    Text("Build an iOS app for iOS 15 with custom layouts, animations and ...")
                        .font(.footnote)
                        .matchedGeometryEffect(id: "text", in: namespace)
                    Text("Learn SwiftUI")
                        .font(.footnote.weight(.semibold))
                        .matchedGeometryEffect(id: "subtitle", in: namespace)
                    Text("Hello, World!")
                        .font(.largeTitle.weight(.bold))
                        .matchedGeometryEffect(id: "title", in: namespace)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(20)
                .foregroundColor(.yellow)
                .background(
                    Color.pink
                        .matchedGeometryEffect(id: "background", in: namespace)
                )
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                show.toggle()
            }
        }
    }
}

struct MatchedTestView_Previews: PreviewProvider {
    static var previews: some View {
        MatchedTestView()
    }
}
