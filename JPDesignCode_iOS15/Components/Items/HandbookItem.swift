//
//  HandbookItem.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/7/4.
//

import SwiftUI

struct HandbookItem: View {
    var handbook: Handbook = handbooks[1]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.black.opacity(0.2))
                .frame(height: 90)
                .overlay(
                    Image(handbook.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 100)
                )
            
            Text(handbook.title)
                .fontWeight(.semibold)
                // *** 本来这里根据系统适配会被压缩至一行 ***
                // `layoutPriority`【布局优先级】：优先适配、优先占据可用空间，默认为0。
                // 设置优先级最高：当分配可用空间时，如果空间不够，优先保证该视图的所需空间(尽可能完全显示)，
                // 然后按【可压缩程度】（例如`text`可显示多行，那就优先压缩行数）压缩其他子视图的空间。
                .layoutPriority(1)
            
            Text(handbook.subtitle)
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)
            
            Text(handbook.text)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            // 当`VStack`有了固定高度，如果内容高度小于`VStack`的，
            // 内容就会垂直居中，所以放个垫片让内容置顶
            Spacer()
        }
        .padding()
        .frame(maxWidth: 200)
        .frame(height: 260)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .strokeStyle(cornerRadius: 30)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.linearGradient(colors: [handbook.color1, handbook.color2], startPoint: .topLeading, endPoint: .bottomTrailing))
                .rotation3DEffect(.degrees(10), axis: (x: 0, y: 1, z: 0), anchor: .bottomTrailing)
                .rotationEffect(.degrees(180))
                .padding(.trailing, 40)
        )
    }
}

struct HandbookItem_Previews: PreviewProvider {
    static var previews: some View {
        HandbookItem()
    }
}
