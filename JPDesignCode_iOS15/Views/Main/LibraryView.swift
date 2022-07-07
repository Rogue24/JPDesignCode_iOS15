//
//  LibraryView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/7/7.
//

import SwiftUI

struct LibraryView: View {
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            // 添加到`ScrollView`里面的子视图之间默认自带`8`的间距
            ScrollView {
                CertificateView()
                    .frame(height: 220)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(.linearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(20)
                            .offset(y: -30)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(.linearGradient(colors: [.teal, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(40)
                            .offset(y: -60)
                    )
                    .padding(20)
                
                Text("History".uppercased())
                    .titleStyle()
                courseSection
                
                Text("Topics".uppercased())
                    .titleStyle()
                topicsSection
            }
            // 设置基于安全区域内【额外】的内间距
            .safeAreaInset(edge: .top) {
                // 对透明颜色设置frame可以实现类似Flutter的SizeBox效果
                Color.clear.frame(height: 70)
            }
            .overlay(
                NavigationBar(title: "Library", hasScrolled: .constant(true))
            )
            .background(
                Image("Blob 1")
                    .offset(x: -100, y: -400)
            )
        }
    }
    
    var courseSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(courses) { course in
                    SmallCourseItem(course: course)
                }
            }
            .padding(.horizontal, 20)
            
            // 当`ScrollView`【横向滚动】时，大小为包裹的子视图的大小（本来是`SmallCourseItem列表`那么大），
            // 加个垫片可以让`ScrollView`高度扩大至父视图那么高，同时也能让`SmallCourseItem列表`置顶，
            // 并且不会影响到`ScrollView`的`overlay`和`background`，一举两得。
//            Spacer()
            //【目前不需要】：因为现在外层已经有一个【垂直滚动】的`ScrollView`包裹着并且是第一个子视图，所以就不需要再用垫片了，否则如果总内容高度比`ScrollView`的高度小，垫片就会占据多余空间，然后把下面的子视图往下推至边界。
        }
    }
    
    var topicsSection: some View {
        VStack {
            ForEach(topics) { topic in
                ListRow(topic: topic)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .strokeStyle(cornerRadius: 30)
        .padding(.horizontal, 20)
    }
    
    
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
