//
//  SectionView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/7/4.
//

import SwiftUI

struct SectionView: View {
    var section: CourseSection = courseSections[0]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ScrollView {
                cover
                    .overlay(
                        PlayView(progress: section.progress)
//                            .overlay(
//                                CircularView(value: section.progress, lineWidth: 5)
//                                    .padding(24)
//                            )
                    )
                content
                    .offset(y: 120)
                    .padding(.bottom, 140) // 200 = 120 + 80
            }
            .background(Color("Background"))
            
            button
        }
        .ignoresSafeArea()
    }
    
    var cover: some View {
        VStack {
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 500)
        // ------【如果设置了固定高度再设置内边距的注意点 begin】------
        // 如果之后设置了内边距20，由于上面已经固定了500高度，宽度为最大宽度，
        // 因此这时候`VStack`的【内容视图最大尺寸】变更为：
        // width = width - 20 - 20, height = 50
        // 而`VStack`的【外显尺寸】变更为：
        // width = width, height = 20 + 500 + 20
//            .padding(20)
        // ------【如果设置了固定高度再设置内边距的注意点 ended】------
        .background(
            Image(section.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(20)
                .frame(maxWidth: 500)
        )
        .background(
            Image(section.background)
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        // 使用`mask`，则在此之上的内容超出的部分会被裁剪掉，包括`overlay`
        .mask(RoundedRectangle(cornerRadius: 0, style: .continuous))
        // 因此`overlay`要放在`mask`【之后】才不会被裁剪掉
        .overlay(overlayContent)
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("SwiftUI is hands-down the best way for designers to take a first step into code. ")
                .font(.title3)
                .fontWeight(.medium)
            
            Text("This course")
                .font(.title)
                .bold()
            
            Text("This course is unlike any other. We care about design and want to make sure that you get better at it in the process. It was written for designers and developers who are passionate about collaborating and building real apps for iOS and macOS. While it's not one codebase for all apps, you learn once and can apply the techniques and controls to all platforms with incredible quality, consistency and performance. It's beginner-friendly, but it's also packed with design tricks and efficient workflows for building great user interfaces and interactions.")
            
            Text("This year, SwiftUI got major upgrades from the WWDC 2020. The big news is that thanks to Apple Silicon, Macs will be able to run iOS and iPad apps soon. SwiftUI is the only framework that allows you to build apps for all of Apple's five platforms: iOS, iPadOS, macOS, tvOS and watchOS with the same codebase. New features like the Sidebar, Lazy Grid, Matched Geometry Effect and Xcode 12's visual editing tools will make it easier than ever to build for multiple platforms.")
            
            Text("Multiplatform app")
                .font(.title)
                .bold()
            
            Text("For the first time, you can build entire apps using SwiftUI only. In Xcode 12, you can now create multi-platform apps with minimal code changes. SwiftUI will automatically translate the navigation, fonts, forms and controls to its respective platform. For example, a sidebar will look differently on the Mac versus the iPad, while using exactly the same code. Dynamic type will adjust for the appropriate platform language, readability and information density. ")
        }
        .padding(20)
    }
    
    var button: some View {
        Button {
            dismiss()
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
            Text(section.title)
                .font(.largeTitle.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(section.subtitle.uppercased())
                .font(.footnote.weight(.semibold))
            Text(section.text)
                .font(.footnote)
            
            Divider()
            
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
        }
        .padding(20)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        )
        .padding(20)
        .offset(y: 250)
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView()
    }
}
