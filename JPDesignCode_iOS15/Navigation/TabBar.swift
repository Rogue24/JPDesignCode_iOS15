//
//  TabBar.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/4.
//

import SwiftUI

struct TabBar: View {
    // 使用`@AppStorage`保证`Key`相同的变量全局独一份，可以共用（其实就是`UserDefaults`），并且具有类似`@State`的响应式特性，能实时刷新使用该变量的地方。
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @State var selectedColor: Color = .teal
    @State var tabItemWidth: CGFloat = 0
    
    // 这是外层`ContentView`设置的基于安全区域内【额外】的底部间距
    var diffSafeAreaBottomInset: CGFloat = 0
    /// 如果是刘海屏，默认安全区域底部间距是``34``，设置额外的底部间距是``88``，
    /// 那么这里的`safeAreaInsets.bottom = 34 + 88 = 122`。
    
    var body: some View {
        // 系统TabBar：使用`.tabItem`
//        TabView {
//            HomeView()
//                .tabItem {
//                    Image(systemName: "house")
//                    Text("Learn Now")
//                }
//            AccountView()
//                .tabItem {
//                    Image(systemName: "magnifyingglass")
//                    Text("Explore")
//                }
//        }
        
        // 自定义TabBar
        GeometryReader { proxy in
            // 是否刘海屏
            let hasHomeIndicator = (proxy.safeAreaInsets.bottom - diffSafeAreaBottomInset) > 20
            
            HStack {
                buttons
            }
            .padding(.horizontal, 8)
            .padding(.top, 14)
            .frame(height: hasHomeIndicator ? 88 : 60, alignment: .top)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: hasHomeIndicator ? 34 : 0, style: .continuous))
            .background(background)
            .overlay(overlay)
            .strokeStyle(cornerRadius: hasHomeIndicator ? 34 : 0)
            // *这里不用设置maxWidth了，因为buttons里面已经设置好了，会撑满父视图的宽度*
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
    }
    
    var buttons: some View {
        ForEach(tabItems) { item in
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = item.tab
                    selectedColor = item.color
                }
            } label: {
                VStack(spacing: 0) {
                    Image(systemName: item.icon)
                        .symbolVariant(.fill)
                        .font(.body.bold())
                        .frame(width: 44, height: 29)
                    Text(item.text)
                        .font(.caption2)
                        .lineLimit(1)
                }
                // *将每个Item都设置最大宽度，那就能使所有Item自动占据并均分父视图的最大宽度*
                .frame(maxWidth: .infinity)
                // 只设置`H/V/ZStack`的`maxWidth`为`infinity`也只会影响`H/V/ZStack`及其`background`的宽度，
                // 并【不会影响】里面子视图的宽度，子视图依然保持自适应的宽度（子视图不设置`frame`的情况下）【居中】布局。
            }
            .foregroundStyle(
                selectedTab == item.tab ? .primary : .secondary
            )
            // 混合模式，本视图跟【底下的其他视图的颜色】进行混合渲染
            .blendMode(selectedTab == item.tab ? .overlay : .normal)
            .overlay {
                // 实时监听tabItem的大小，动态更新选中时相关视图的布局
                GeometryReader { proxy in
                    //【注意】：不可以直接在【子视图内部】刷新父视图的State属性
//                    tabItemWidth = proxy.size.width
                    // `tabItemWidth`是父视图的State属性，
                    // 改变该属性就会影响里面子视图的布局，
                    // 然后此处子视图的布局只要发生改变，又会改变这个State属性，
                    // 从而又会让父视图重复去改变里面子视图的布局，周而复始，导致死循环。
                    // 参考：https://zhuanlan.zhihu.com/p/447836445
                    
                    // 解决方案：使用`PreferenceKey` ---【能够在视图之间传递值】
                    // PS：需要在`GeometryReader`里面放入一个视图才能读取到其坐标变化值，
                    // 因此放一个透明颜色，同时也可以防止遮挡到底下视图。
                    Color.clear
                        .preference(key: TabPreferenceKey.self, // PreferenceKey类型
                                    value: proxy.size.width) // 监听的值
                }
            }
            // 当PreferenceKey监听的值发生改变时的回调闭包
            .onPreferenceChange(TabPreferenceKey.self) { value in
                // 父视图得在这里去接收子视图传递的值
                tabItemWidth = value
            }
        }
    }
    
    var background: some View {
        HStack {
            if selectedTab == .explore {
                Spacer()
            }
            if selectedTab == .notificcations {
                Spacer()
                Spacer()
            }
            if selectedTab == .library {
                Spacer()
            }
            
            Circle()
                .fill(selectedColor)
                .frame(width: tabItemWidth)
            
            if selectedTab == .home {
                Spacer()
            }
            if selectedTab == .explore {
                Spacer()
                Spacer()
            }
            if selectedTab == .notificcations {
                Spacer()
            }
            
        }
        .padding(.horizontal, 8)
    }
    
    var overlay: some View {
        HStack {
            if selectedTab == .explore {
                Spacer()
            }
            if selectedTab == .notificcations {
                Spacer()
                Spacer()
            }
            if selectedTab == .library {
                Spacer()
            }
            
            Rectangle()
                .fill(selectedColor)
                .frame(width: 28, height: 5)
                .cornerRadius(3)
                .frame(width: tabItemWidth)
                .frame(maxHeight: .infinity, alignment: .top)
            
            if selectedTab == .home {
                Spacer()
            }
            if selectedTab == .explore {
                Spacer()
                Spacer()
            }
            if selectedTab == .notificcations {
                Spacer()
            }
            
        }
        .padding(.horizontal, 8)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
