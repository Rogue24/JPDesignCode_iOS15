//
//  ContentView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/5/8.
//

import SwiftUI

struct ContentView: View {
    // 使用`@AppStorage`保证`Key`相同的变量全局独一份，可以共用（其实就是`UserDefaults`），并且具有类似`@State`的响应式特性，能实时刷新使用该变量的地方。
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @AppStorage("showModal") var showModal = false
    @EnvironmentObject var model: Model
    
    // 基于安全区域内【额外】的底部间距
    let diffBottomInset: CGFloat = 88
    
    var body: some View  {
        ZStack(alignment: .bottom) {
            // 将逻辑的代判断码放入`Group`中，
            // 可以对`Group`中赛选出来的`View`统一添加`Modifier`，
            // 不必再对每个`View`都设置同样的`Modifier`了，减少大量重复代码。
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .explore:
                    ExploreView()
                case .notificcations:
                    NotificationsView()
                case .library:
                    LibraryView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            TabBar(diffSafeAreaBottomInset: diffBottomInset)
                .offset(y: model.showDetail ? 200 : 0)
            
            if showModal {
                ModalView()
                    // 不设置这个属性的话关闭时就没有动画效果（其实就是对`zIndex`做动画）
                    .zIndex(1)
                    .accessibilityAddTraits(.isModal) // 声明该[可访问性]元素的类型（可作用于画外音的读取）
            }
        }
        // 设置基于安全区域内【额外】的内间距
        .safeAreaInset(edge: .bottom) {
            // 对透明颜色设置frame可以实现类似Flutter的SizeBox效果
            Color.clear.frame(height: diffBottomInset)
        }
        // 限制【辅助功能】中[文字大小]的范围
        .dynamicTypeSize(.large ... .xxLarge)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark) // 深色模式
        }
        // 如果View里面使用了环境变量，在Preview中则需要在这里初始化该环境变量给到View使用，否则预览会报错
        .environmentObject(Model())
    }
}
