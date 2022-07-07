//
//  SectionRow.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/7/3.
//

import SwiftUI

struct SectionRow: View {
    var section: CourseSection = courseSections[0]
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(section.logo)
                .resizable()
                .frame(width: 36, height: 36)
                .mask(Circle())
                .padding()
                .background(Color(uiColor: .systemBackground).opacity(0.3))
                .mask(Circle())
                .overlay(CircularView(value: section.progress))
            VStack(alignment: .leading, spacing: 8) {
                Text(section.subtitle)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.secondary)
                Text(section.title)
                    .fontWeight(.semibold)
                Text(section.text)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.secondary)
                // `ProgressView`不设置`value`的话就是一朵菊花
                ProgressView(value: section.progress)
                    .accentColor(.white)
                    .frame(maxWidth: 132)
            }
        }
        .padding(20)
    }
}

struct SectionRow_Previews: PreviewProvider {
    static var previews: some View {
        SectionRow()
    }
}
