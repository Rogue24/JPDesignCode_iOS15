//
//  CourseView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/19.
//

import SwiftUI

struct CourseView: View {
    // 声明是源头的类型定义：
//    @Namespace var namespace
    // 声明这是从外界传入的类型定义：
    var namespace: Namespace.ID
    var course: Course = courses[0]
    @State var appear = [false, false, false, true]
    @State var viewState: CGSize = .zero
    @State var isDraggable = true
    @State var showSection = false
    @State var selectedIndex = 0
    @EnvironmentObject var model: Model
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ScrollView {
                // 添加到`ScrollView`里面的子视图之间默认自带`8`的间距，
                // 不想有间距那就把子视图放到`VStack/HStack`中并且`spacing`设置为`0`即可。
//                VStack(spacing: 0) {
//                    Color.red
//                        .frame(height: 500)
//                    Color.yellow
//                        .frame(height: 800)
//                }
                
                cover
                
                content
                    .offset(y: 120)
                    .padding(.bottom, 140) // 200 = 120 + 80
                    .opacity(appear[2] ? 1 : 0)
            }
            // 设置该视图的坐标命名空间，可以让`GeometryReader`监听【相对于】该视图上的坐标变化。
            .coordinateSpace(name: "scroll")
            .background(Color("Background").opacity(appear[3] ? 1 : 0))
            .mask(RoundedRectangle(cornerRadius: viewState.width / 3, style: .continuous))
            .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 10)
            .scaleEffect(1 + viewState.width / -500)
            // 全屏背景要在`scaleEffect`之后才设置，否则会受到`scaleEffect`的影响（缩小）
            .background(.black.opacity(viewState.width / 500))
            .background(.ultraThinMaterial)
            // 添加往右挪的返回手势（在`ignoresSafeArea`之前添加，免得安全区域也会响应）
            .gesture(isDraggable ? drag : nil)
            
            button
        }
        .ignoresSafeArea()
        .onAppear {
            fadeIn()
        }
        .onChange(of: model.showDetail) { newValue in
            guard !newValue else { return }
            fadeOut()
        }
    }
    
    var cover: some View {
        GeometryReader { proxy in
            let scrollY = proxy.frame(in: .named("scroll")).minY
            
            VStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 500 + (scrollY > 0 ? scrollY : 0))
            // ------【如果设置了固定高度再设置内边距的注意点 begin】------
            // 如果之后设置了内边距20，由于上面已经固定了500高度，宽度为最大宽度，
            // 因此这时候`VStack`的【内容视图最大尺寸】变更为：
            // width = width - 20 - 20, height = 50
            // 而`VStack`的【外显尺寸】变更为：
            // width = width, height = 20 + 500 + 20
//            .padding(20)
            // ------【如果设置了固定高度再设置内边距的注意点 ended】------
            .background(
                Image(course.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                    .frame(maxWidth: 500)
                    .matchedGeometryEffect(id: "image\(course.id)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY * 0.8 : 0)
                    .accessibilityLabel("封面图") // 声明该元素的标签/名字（可作用于画外音的读取）
            )
            .background(
                Image(course.background)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .matchedGeometryEffect(id: "background\(course.id)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
                    .scaleEffect(1 + (scrollY > 0 ? scrollY / 1000 : 0))
                    .blur(radius: scrollY / 10)
            )
            // 使用`mask`，则在此之上的内容超出的部分会被裁剪掉，包括`overlay`
            .mask(
                RoundedRectangle(cornerRadius: appear[0] ? 0 : 30, style: .continuous)
                    .matchedGeometryEffect(id: "mask\(course.id)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
            )
            // 因此`overlay`要放在`mask`【之后】才不会被裁剪掉
            .overlay(
                overlayContent
                    .offset(y: scrollY > 0 ? -scrollY * 0.6 : 0)
            )
            // 用于观察scrollY的数值变化
//            .overlay(
//                Text("\(scrollY)")
//                    .foregroundColor(Color.blue)
//                    .offset(y: -scrollY)
//            )
        }
        // 设置成内容视图【原本】的高度
        .frame(height: 500)
    }
    
    var content: some View {
        VStack(alignment: .leading) {
            /// ForEach(xxx, id: \.aaa) --- xxx是个数组，这里的 \.aaa 是指 xxx[i].aaa，意思是将每个元素的aaa属性作为id（KeyPath）；
            /// 例如：ForEach(courseSections, id: \.title) --- 这个id【应该】是用来作为标识，当数据刷新时会用到，所以最好【不要用可能会重复】的属性，这里只是举个例子；
            /// Array(courseSections.enumerated()) => [(offset: Int, element: Section)]，这是个装着【元组】的数组，offset是下标，不会重复，所以可以作为id。
            ForEach(Array(courseSections.enumerated()), id: \.offset) { index, section in
                if index != 0 { Divider() }
                SectionRow(section: section)
                    .onTapGesture {
                        selectedIndex = index
                        showSection = true
                    }
            }
        }
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .strokeStyle(cornerRadius: 30)
        .padding(20)
        .sheet(isPresented: $showSection) {
            SectionView(section: courseSections[selectedIndex])
        }
    }
    
    var button: some View {
        Button {
            if isDraggable {
                withAnimation(.closeCard) {
                    model.showDetail = false
                }
            } else {
                dismiss()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.body.weight(.bold))
                .foregroundColor(.secondary)
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
        }
        // `Button`的点击区域取决于`label`的大小，
        // 因此这里设置的`frame`只是仅仅用来布局，不会影响点击区域。
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(20)
    }
    
    var overlayContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(course.title)
                .font(.largeTitle.weight(.bold))
                .matchedGeometryEffect(id: "title\(course.id)", in: namespace)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(course.subtitle.uppercased())
                .font(.footnote.weight(.semibold))
                .matchedGeometryEffect(id: "subtitle\(course.id)", in: namespace)
            Text(course.text)
                .font(.footnote)
                .matchedGeometryEffect(id: "text\(course.id)", in: namespace)
            
            Divider()
                .opacity(appear[0] ? 1 : 0)
            
            HStack {
                Image("Avatar Default")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .cornerRadius(10)
                    .padding(8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .strokeStyle(cornerRadius: 18)
                Text("Taught by 斗了个平")
                    .font(.footnote)
            }
            .opacity(appear[1] ? 1 : 0)
        }
//        .foregroundColor(.black)
        .padding(20)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .matchedGeometryEffect(id: "blur\(course.id)", in: namespace)
        )
        .padding(20)
        .offset(y: 250)
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onChanged { value in
                // 左边边沿位置才触发
                guard value.startLocation.x < 100 else { return }
                // 往右挪才变化
                guard value.translation.width > 0 else { return }
                // 挪到一定距离自动关闭
                if viewState.width > 120 {
                    close()
                } else {
                    // 变化值的差值有时候会偏大，导致拖拽过程可能不是很平滑（类似掉帧）
//                    viewState = value.translation
                    // 带上动画效果避免掉帧的情况
                    withAnimation {
                        viewState = value.translation
                    }
                }
            }
            .onEnded { value in
                if viewState.width > 80 {
                    close()
                } else {
                    recover()
                }
            }
    }
    
    func fadeIn() {
        withAnimation(.easeOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.4)) {
            appear[1] = true
        }
        withAnimation(.easeOut.delay(0.5)) {
            appear[2] = true
        }
    }
    
    func fadeOut() {
        withAnimation(.easeOut(duration: 0.1)) {
            appear[0] = false
            appear[1] = false
            appear[2] = false
            appear[3] = false
        }
    }
    
    func recover() {
        withAnimation(.openCard) {
            viewState = .zero
        }
    }
    
    func close() {
        withAnimation(.closeCard.delay(0.3)) {
            model.showDetail = false
        }
        
        withAnimation(.closeCard) {
            viewState = .zero
        }
        
        isDraggable = false
    }
}

struct CourseView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        CourseView(namespace: namespace)
            // 如果View里面使用了环境变量，在Preview中则需要在这里初始化该环境变量给到View使用，否则预览会报错
            .environmentObject(Model())
    }
}
