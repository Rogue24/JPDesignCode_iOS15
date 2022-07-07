//
//  NavigationBar.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/8.
//

import SwiftUI

struct NavigationBar: View {
    var title: String = ""
    @Binding var hasScrolled: Bool
    @State var showSearch = false
    @State var showAccount = false
    @AppStorage("showModal") var showModal = false
    @AppStorage("isLogged") var isLogged = false
    
    var body: some View {
        ZStack {
            Color.clear
                // 如果用Color会被截掉，而ultraThinMaterial“貌似”能穿透出边界，
                // 把安全区域也覆盖了。
                .background(.ultraThinMaterial)
                .blur(radius: 10)
                .opacity(hasScrolled ? 1 : 0)
                
            Text(title)
                // 字体大小变化的动画需要使用`AnimatableModifier`实现
                .animatableFont(size: hasScrolled ? 22 : 34, weight: .bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top, 20)
                .offset(y: hasScrolled ? -4 : 0)
            
            HStack(spacing: 16) {
                Button {
                    showSearch = true
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.body.weight(.bold))
                        .frame(width: 36, height: 34)
                        .foregroundColor(.secondary)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .strokeStyle(cornerRadius: 14)
                }
                .sheet(isPresented: $showSearch) {
                    SearchView()
                }
                
                Button {
                    if isLogged {
                        showAccount = true
                    } else {
                        // PS：该效果在`Preview`是没有效果的，在模拟器或真机上才有。
                        withAnimation {
                            showModal = true
                        }
                    }
                } label: {
                    AvatarView()
                }
                // 当该视图无法被[可访问性]检测到时：
                .accessibilityElement() // 强制成为[可访问性]元素
                .accessibilityLabel("用户按钮") // 声明该元素的标签/名字（可作用于画外音的读取）
                .accessibilityAddTraits(.isButton) // 声明该元素的类型（可作用于画外音的读取）
                .sheet(isPresented: $showAccount) {
                    AccountView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 20)
            .padding(.top, 20)
            .offset(y: hasScrolled ? -4 : 0)
        }
        .frame(height: hasScrolled ? 44 : 70)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "Featured", hasScrolled: .constant(false))
    }
}
