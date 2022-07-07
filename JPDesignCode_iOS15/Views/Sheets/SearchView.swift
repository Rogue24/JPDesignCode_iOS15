//
//  SearchView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/25.
//

import SwiftUI

/**
 * 文本会【自适应】内容宽度，最大为父视图的最大宽度，
 * 当超出最大宽度时文本会自动换行，并且根据句子样式自适应左右间距，
 * 但是自适应换行会有不同的间距，可能间距很多，也可能没有间距。
 * 想【自适应换行且对齐】需要设置`frame(maxWidth/maxHeight)`和`multilineTextAlignment`
 * 例如左边对齐需要这样设置：
    // `Text`本身的最大区域，设置这里的`alignment`使整体`Text`对齐以【消除间距】
    `.frame(maxWidth: .infinity, alignment: .leading)`
    // 多行文本的对齐方式
    `.multilineTextAlignment(.leading)`
 */

struct SearchView: View {
    @State var text = ""
    @State var show = false
    @State var selectedIndex = 0
    @Namespace var namespace
    @Environment(\.presentationMode) var presentationMode
    // `presentationMode`的类型是`Binding<PresentationMode>`
    // 相当于这样定义：var presentationMode: Binding<String>
    
    // 直接声明【属性包装器类型】的属性需要调用`wrappedValue`获取其包装的属性才可以使用或读写
    // 例如：`var str: Binding<String>`，使用：`str.wrappedValue = "123"`
    // 声明为属性包装器则：`@Binding var str: String`，使用：`str = "123"`
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    content
                }
                .padding(20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .strokeStyle(cornerRadius: 30)
                .padding(20)
                .background(
                    Rectangle()
                        .fill(.regularMaterial)
                        .frame(height: 200)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .blur(radius: 20)
                        .offset(y: -200)
                )
                .background(
                    Image("Blob 1").offset(x: -100, y: -200)
                )
            }
            .searchable(
                text: $text,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("SwiftUI, React, UI Design") // 占位符
            ) {
                // 搜索建议列表（例如可以做成搜索历史）
                ForEach(suggestions) { suggestion in
                    Button {
                        text = suggestion.text
                    } label: {
                        Text(suggestion.text)
                            .searchCompletion(suggestion.text)
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline) // 不使用大标题样式
            .navigationBarItems(
                trailing: Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done").bold()
                }
            )
            .sheet(isPresented: $show) {
                CourseView(namespace: namespace, course: courses[selectedIndex], show: $show)
            }
        }
    }
    
    var content: some View {
        /// ForEach(xxx, id: \.aaa) --- xxx是个数组，这里的 \.aaa 是指 xxx[i].aaa，意思是将每个元素的aaa属性作为id（KeyPath）；
        /// 例如：ForEach(courses, id: \.title) --- 这个id【应该】是用来作为标识，当数据刷新时会用到，所以最好【不要用可能会重复】的属性，这里只是举个例子；
        /// Array(courses.enumerated()) => [(offset: Int, element: Course)]，这是个装着【元组】的数组，offset是下标，不会重复，所以可以作为id。
        let filteredCourses = courses.filter { $0.title.contains(text) || text == "" }
        return ForEach(Array(filteredCourses.enumerated()), id: \.offset) { index, course in
            // 这个index是过滤后的数组的下标，并不是原数据数组的下标
            if index != 0 {
                Divider()
            }
            
            Button {
                show = true
                selectedIndex = courses.firstIndex { $0.id == course.id } ?? 0
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    Image(course.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 44, height: 44)
                        .background(Color("Background"))
                        .mask(Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        // 如果没有给文本设置颜色（foregroundColor），
                        // 当外层有【能交互的父视图】（如`NavigationLink`、`Button`等）将其包裹时，
                        // 文本会自动渲染成【淡紫色】。
                        Text(course.title).bold()
                            .foregroundColor(.primary)
                        Text(course.text)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            // 自适应换行且对齐：
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.vertical, 4)
                .listRowSeparator(.hidden) // 隐藏系统分隔线
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
