//
//  ModalView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/27.
//

import SwiftUI

struct ModalView: View {
    @EnvironmentObject var model: Model
    @AppStorage("showModal") var showModal = true
    @State var viewState: CGSize = .zero
    @State var isDismissed = false
    @State var appear = [false, false, false]
    @AppStorage("isLogged") var isLogged = false
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.regularMaterial)
                .onTapGesture {
                    dismissModal()
                }
                .ignoresSafeArea()
            
            // 给`selectedModal`的切换添加了动画后，不知道为什么切换时`background`会带有渐变效果，
            // 但使用`GeometryReader`将其包裹，就能【几乎】去掉`background`的渐变效果。
            GeometryReader { proxy in
                Group {
                    switch model.selectedModal {
                    case .signUp: SignUpView()
                    case .signIn: SignInView()
                    }
                }
                // --------------- 添加`shadow`、`mask`、`rotationEffect`的注意点 begin ---------------
                // 使用了`shadow`除了会作用于`Group`的视图，并且还会作用于其全部子视图（子视图的子视图），
                // 如果在`rotationEffect`之后才添加`shadow`，【当发生旋转时阴影不会作用到其子视图】。
                //（可以注释`mask`和`rotation3DEffect`，并且把`rotationEffect`之后添加的阴影设置成深色，然后挪一下就能看到问题了）
                // * 我的解决方案：在`rotationEffect`之前添加`shadow`。
//                .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
                // * 目前方案：在`rotationEffect`之前添加`mask`，之后再添加`shadow`，
                // 让阴影只作用于Group的视图但不包括其子视图，对需要阴影的子视图单独添加`shadow`。
                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .offset(x: viewState.width, y: viewState.height)
                .offset(y: isDismissed ? 1000 : 0)
                .rotationEffect(.degrees(viewState.width / 40))
                // 如果想一次性让阴影作用到其全部子视图，那我的方案更可行，但是再加上`rotation3DEffect`的话，开始3d旋转时整个背景会直接消失，
                // 所以还是【使用`mask`的方案最可行】：用`mask`将`Group`的视图设置好的`Modifier`样式“封存”好，不受之后各种的`Effect`影响（除了`hueRotation`）。
                .rotation3DEffect(.degrees(viewState.height / 20), axis: (x: 1, y: 0, z: 0))
//                .hueRotation(.degrees(viewState.width / 5)) // 混色效果放在`background`的图片上效果更好
                // 只给`Group`的视图添加阴影就行了，不用给ta的子视图添加。
                .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
                // --------------- 添加`shadow`、`mask`、`rotationEffect`的注意点 ended ---------------
                .opacity(appear[0] ? 1 : 0)
                .offset(y: appear[0] ? 0 : 200)
                .padding(20)
                .gesture(drag)
                // 如果`GeometryReader`区域比包裹的子视图大，子视图会被【置顶】摆放，
                // 想要居中摆放就得设置子视图的`maxWidth/maxHeight`。
                .frame(maxHeight: .infinity)
                .background(
                    Image("Blob 1")
                        .offset(x: 170, y: -60)
                        .opacity(appear[2] ? 1 : 0)
                        .offset(y: appear[2] ? 0 : 10)
                        .blur(radius: appear[2] ? 0 : 40)
                        .hueRotation(.degrees(viewState.width / 5)) // 混色效果
                        .allowsHitTesting(false) // 禁止交互（防止点击事件被ta拦截）
                        .accessibility(hidden: true) // 对[可访问性]的检测进行隐藏
                )
            }
            
            Button {
                dismissModal()
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.bold))
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
                    .cornerRadius(18)
                    .strokeStyle(cornerRadius: 18, style: .circular)
            }
            // `Button`的点击区域取决于`label`的大小，
            // 因此这里设置的`frame`只是仅仅用来布局，不会影响点击区域。
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20)
            .opacity(appear[1] ? 1 : 0)
            .offset(y: appear[1] ? 0 : -200)
        }
        .onAppear {
            withAnimation(.easeOut) {
                appear[0] = true
            }
            withAnimation(.easeOut.delay(0.1)) {
                appear[1] = true
            }
            withAnimation(.easeOut(duration: 1).delay(0.2)) {
                appear[2] = true
            }
        }
        .onChange(of: isLogged) { newValue in
            if newValue {
                dismissModal()
            }
        }
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                // 变化值的差值有时候会偏大，导致拖拽过程可能不是很平滑（类似掉帧）
//                viewState = value.translation
                // 带上动画效果避免掉帧的情况
                withAnimation {
                    viewState = value.translation
                }
            }
            .onEnded { value in
                if value.translation.height > 200 {
                    dismissModal()
                } else {
                    withAnimation(.openCard) {
                        viewState = .zero
                    }
                }
            }
    }
    
    func dismissModal() {
        withAnimation {
            isDismissed = true
        }
        withAnimation(.linear.delay(0.3)) {
            showModal = false
        }
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView()
            .environmentObject(Model())
    }
}
