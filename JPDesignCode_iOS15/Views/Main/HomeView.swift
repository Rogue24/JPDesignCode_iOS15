//
//  HomeView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/6.
//

import SwiftUI

struct HomeView: View {
    static let defaultID = UUID()
    
    @Namespace var namespace
    @State var hasScrolled = false
    @State var show = false
    @State var showStatusBar = true
    @State var selectedID = Self.defaultID
    @State var showCourse = false
    @State var selectedIndex = 0
    @EnvironmentObject var model: Model
    //【性能优化】精简模式：UI方面影响性能主要是[模糊]、[阴影]、[动画]效果，有性能问题的地方尽量少使用或直接不使用这三种耗性能的`Modified`。
    @AppStorage("isLiteMode") var isLiteMode = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView {
                scrollDetection
                
                featured
                
                Text("Courses".uppercased())
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                LazyVGrid(
                    // LazyVGrid - columns 列数
                    // LazyHGrid - rows 行数
                    // 都是数组形式，元素`GridItem`类型，有多少个`GridItem`就有多少列/行
                    columns: [
                        // GridItem(.adaptive(minimum: xxx, maximum: xxx), spacing: xxx) 自适应大小
                        // - adaptive：自适应大小，根据设置的大小自适应列/行数，无须手动添加多个GridItem（例如设置了最小值100，屏幕宽度375，那就可以生成3列）
                        // - spacing：列/行跟列/行之间的间距，如果是多个GridItem，那么这个距离就只作用于左边（V）/下边（H）
                        GridItem(.adaptive(minimum: 300), spacing: 20),
                        
                        // GridItem(.fixed(xxx)) 固定大小
                        // - spacing：列/行跟列/行之间的间距，如果是多个GridItem，那么这个距离就只作用于左边（V）/下边（H）
//                        GridItem(.fixed(220), spacing: 5),
//                        GridItem(.fixed(150), spacing: 15),
//                        GridItem(.fixed(250), spacing: 0),
//                        GridItem(.fixed(100), spacing: 20),
                    ],
                    
                    // LazyVGrid设置的是columns，而LazyHGrid设置的是rows
//                    rows: Array(repeating: GridItem(spacing: 16), count: 2),
                    
                    // spacing 内间距（垂直方向的是行跟行之间的间距，而水平方向的是列跟列之间的间距）
                    spacing: 20
                ) {
                    // Meng（作者）的做法：全部卡片都替换成占位符
//                    if !show {
//                        cards
//                    } else {
//                        placeholder
//                    }
                    
                    // 我的做法1_0：只有选中的卡片才替换为占位符
//                    jp_cards
                    
                    // 我的做法2_0：保持显示，反正在最底下不需要隐藏
                    // 个人感觉这种效果最好，没有多余的过渡效果，不过这样会触发警告：`Multiple inserted views in matched geometry group Pair<String, ID>`，日后解决。
                    cards
                }
                .padding(.horizontal, 20)
            }
            // 设置该视图的坐标命名空间，可以让`GeometryReader`监听【相对于】该视图上的坐标变化。
            .coordinateSpace(name: "scroll")
            // 设置基于安全区域内【额外】的内间距
            .safeAreaInset(edge: .top) {
                // 对透明颜色设置frame可以实现类似Flutter的SizeBox效果
                Color.clear.frame(height: 70)
            }
            // 使用overlay添加标题就不用担心跟着ScrollView一起滚了
            .overlay(
                NavigationBar(title: "Featured", hasScrolled: $hasScrolled)
            )
            
            if show {
                detail
            }
        }
        .statusBar(hidden: !showStatusBar)
        // `onChange`用于监听某个状态值的变化，类似KVC
        .onChange(of: show) { newValue in
            withAnimation(newValue ? .openCard : .closeCard) {
                showStatusBar = !newValue
                
                // 我的做法2_1：需要重置selectedID
                if !newValue {
                    print("回来了")
                    selectedID = Self.defaultID
                }
            }
        }
    }
    
    var scrollDetection: some View {
        // 在`GeometryReader`里面放入一个透明颜色用于专门监听滚动变化
        GeometryReader { proxy in
            //【注意】：不可以直接在【子视图内部】刷新父视图的State属性
            // 解决方案：使用`PreferenceKey` ---【能够在视图之间传递值】
            Color.clear
                .preference(key: ScrollPreferenceKey.self, // PreferenceKey类型
                            value: proxy.frame(in: .named("scroll")).minY) // 监听的值
        }
        // 设置不占任何空间，只用来专门监听滚动变化
        .frame(height: 0)
        // 当PreferenceKey监听的值发生改变时的回调闭包
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            // 父视图得在这里去接收子视图传递的值
            withAnimation(.easeInOut) {
                hasScrolled = value < 0
            }
        }
    }
    
    var featured: some View {
        TabView {
            /// ForEach(xxx, id: \.aaa) --- xxx是个数组，这里的 \.aaa 是指 xxx[i].aaa，意思是将每个元素的aaa属性作为id（KeyPath）；
            /// 例如：ForEach(courses, id: \.title) --- 这个id【应该】是用来作为标识，当数据刷新时会用到，所以最好【不要用可能会重复】的属性，这里只是举个例子；
            /// Array(featuredCourses.enumerated()) => [(offset: Int, element: Course)]，这是个装着【元组】的数组，offset是下标，不会重复，所以可以作为id。
            ForEach(Array(featuredCourses.enumerated()), id: \.offset) { index, course in
                // 如果子视图区域比父视图小，默认会居中，
                // 但使用GeometryReader包裹的子视图，则会置顶。
                GeometryReader { proxy in
                    let minX = proxy.frame(in: .global).minX
                    FeaturedItem(course: course)
                        //【适配iPad】1.先将`FeaturedItem`包裹在最大宽500的区域内，防止被拉伸
                        .frame(maxWidth: 500)
                        //【适配iPad】2.再把这个区域包裹在父视图最大宽度内，这样`FeaturedItem`就能保持居中且不被拉伸
                        .frame(maxWidth: .infinity)
                        // 设置间距使其居中：(430 - 350) / 2 = 40
                        .padding(.vertical, 40)
                        //【注意】：不能在`rotation3DEffect`之前设置`shadow`，
                        .rotation3DEffect(.degrees(minX / -10), axis: (x: 0, y: 1, z: 0))
                        // 要在其之后设置，否则会导致毛玻璃背景没有效果。
                        //【性能优化】阴影效果会影响性能，减少阴影面积可以减轻渲染负担（更直接的做法就是完全不显示）。
                        .shadow(color: Color("Shadow").opacity(isLiteMode ? 0 : 0.3), radius: 5, x: 0, y: 3)
                        .blur(radius: abs(minX / 40))
                        // 将这部分挪出来，让其不受`rotation3DEffect`影响以实现视差效果。
                        .overlay(
                            Image(course.image) // SwiftUI默认始终采用图像的原始尺寸（图片多大就多大）
                                .resizable() // 设置这个可以确保图片大小限制在剩余所有的可用空间内（过小则拉伸至容器大小）
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 230)
                                .offset(x: 32, y: -80)
                                .offset(x: minX / 2)
                        )
                        .onTapGesture {
                            showCourse = true
                            selectedIndex = index
                        }
                        // 将该视图中多个[可访问性]元素整合成一个
                        .accessibilityElement(children: .combine)
                        // 在[可访问性]中将其视图归纳为Button（该视图有点击事件但不是Button）
                        .accessibilityAddTraits(.isButton) // 声明该元素的类型（可作用于画外音的读取）
                    
//                    Text("\(String(format: "%.2lf", minX))")
                }
            }
        }
        // 使用分页类型的方式，可以实现UIScrollView的分页滑动效果
        .tabViewStyle(.page(indexDisplayMode: .never)) // 不显示底部的下标点
        .frame(height: 430) // TabView默认44高度
        // TabView会把子视图超出部分clipped掉，而background是不会受到影响的
        .background(
            Image("Blob 1")
                .offset(x: 250, y: -100)
                .accessibility(hidden: true) // 对[可访问性]的检测进行隐藏
        )
        .sheet(isPresented: $showCourse) {
            CourseView(namespace: namespace, course: featuredCourses[selectedIndex], show: $showCourse)
        }
    }
    
    var jp_cards: some View {
        ForEach(courses) { course in
            if selectedID == course.id {
                Rectangle()
                    .fill(.white)
                    .frame(height: 300)
                    .cornerRadius(30)
                    .shadow(color: Color("Shadow"), radius: 20, x: 0, y: 10)
                    .opacity(0.3)
                    .padding(20)
            } else {
                CourseItem(namespace: namespace, course: course, show: $show)
                    .onTapGesture {
                        withAnimation(.openCard) {
                            show = true
                            model.showDetail = true
                            selectedID = course.id
                        }
                    }
            }
        }
    }
    
    var cards: some View {
        ForEach(courses) { course in
            CourseItem(namespace: namespace, course: course, show: $show)
                .onTapGesture {
                    withAnimation(.openCard) { // .linear(duration: 1)
                        show = true
                        model.showDetail = true
                        selectedID = course.id
                    }
                }
                // 将该视图中多个[可访问性]元素整合成一个
                .accessibilityElement(children: .combine)
                // 在[可访问性]中将其视图归纳为Button（该视图有点击事件但不是Button）
                .accessibilityAddTraits(.isButton) // 声明该元素的类型（可作用于画外音的读取）
        }
    }
    
    var placeholder: some View {
        ForEach(courses) { _ in
            Rectangle()
                .fill(.white)
                .frame(height: 300)
                .cornerRadius(30)
                .shadow(color: Color("Shadow"), radius: 20, x: 0, y: 10)
                .opacity(0.3)
        }
    }
    
    var detail: some View {
        // PS：由于是不同的`View`之间的切换，关闭的动画效果在`Preview`是没有效果的，在模拟器或真机上才有。
        CourseView(namespace: namespace, course: courses.first(where: { $0.id == selectedID }) ?? courses[0], show: $show)
            // 层级往上挪，否则关闭时会被上面子视图盖住
            .zIndex(1)
            // 如果已经有子视图使用了`matchedGeometryEffect`，那么其他子视图会自动带有淡入淡出的过渡效果，并且动画曲线和时间跟`matchedGeometryEffect`一致，
            // 可以使用`transition`自定义其他子视图跟`matchedGeometryEffect`不一样的过渡效果。
            //【个人做法】：这里本来自带的淡入淡出的过渡效果比自定义的`transition`感觉更好，所以我这里先注释了。
//            .transition(
//                // asymmetric：非对称过渡效果（例如1和2的过渡，1为源头，设置这两者之间的过渡动画效果）
//                .asymmetric(
//                    // 1 -> 2
//                    insertion: .opacity.animation(.easeInOut(duration: 0.1)), // .linear(duration: 2)
//                    // 2 -> 1
//                    removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))
//                )
//            )
            /// PS：`transition`会影响整个过程中相关的视图：
            /// 假设`子View0`是`sourse`，`子View1`是`target`，动画曲线都使用线性，
            /// `子View0`挪到`子View1`使用了`matchedGeometryEffect`，时长为``1s``，
            /// `子View1`设置`transition.insertion`为`opacity`从``0``到``1``，时长为``2s``，
            /// 当动画开始执行到``1s``时，`子View1`的`opacity`由``0``变到``0.5``，
            /// 而`子View0`除了已经挪到`子View1`的位置了，并且`子View0`的`opacity`由``1``也变到``0.5``，
            /// 也就是说`sourse`的`opacity`在挪到的过程中也会同步到`target`实时的`opacity`值再隐藏，保证过程没有间隙。
            /// 👉🏻👉🏻👉🏻 将这里的`transition.insertion`的时间设成``2s``，`show = true`那里设置成``1s``就能看出来了。
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
            // 如果View里面使用了环境变量，在Preview中则需要在这里初始化该环境变量给到View使用，否则预览会报错
            .environmentObject(Model())
    }
}
