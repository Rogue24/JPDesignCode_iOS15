//
//  NotificationsView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/7/7.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView {
                sectionsSection
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 70)
            }
            .overlay(NavigationBar(title: "Notifications", hasScrolled: .constant(true)))
            .background(Image("Blob 1").offset(x: -180, y: 300))
        }
    }
    
    var sectionsSection: some View {
        VStack(alignment: .leading) {
            /// ForEach(xxx, id: \.aaa) --- xxx是个数组，这里的 \.aaa 是指 xxx[i].aaa，意思是将每个元素的aaa属性作为id（KeyPath）；
            /// 例如：ForEach(courseSections, id: \.title) --- 这个id【应该】是用来作为标识，当数据刷新时会用到，所以最好【不要用可能会重复】的属性，这里只是举个例子；
            /// Array(courseSections.enumerated()) => [(offset: Int, element: Section)]，这是个装着【元组】的数组，offset是下标，不会重复，所以可以作为id。
            ForEach(Array(courseSections.enumerated()), id: \.offset) { index, section in
                if index != 0 { Divider() }
                SectionRow(section: section)
            }
        }
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .strokeStyle(cornerRadius: 30)
        .padding(20)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
