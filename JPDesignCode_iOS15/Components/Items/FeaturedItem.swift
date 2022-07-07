//
//  FeaturedItem.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/8.
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

struct FeaturedItem: View {
    var course: Course = courses[0]
    //【辅助功能】中的[文字大小]
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Spacer()
            
            Image(course.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26.0, height: 26.0)
                .cornerRadius(10)
                .padding(9)
                //【性能优化】模糊效果会影响性能，如果有性能问题就尽量少使用模糊效果。
//                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                //【性能优化】可以使用半透明颜色背景取代模糊效果：
                .background(Color(uiColor: .systemBackground).opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .strokeStyle(cornerRadius: 16)
            
            Text(course.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                // 字体渐变色
                .foregroundStyle(
                    .linearGradient(
                        colors: [.primary, .primary.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .lineLimit(1)
            
            Text(course.subtitle.uppercased()) // uppercased 大写
                .font(.footnote)
                .fontWeight(.semibold)
                // 当foregroundColor不起效果时则改用foregroundStyle
                // PS：foregroundStyle可以设置渐变色，foregroundColor不能
                .foregroundStyle(.secondary)
            
            Text(course.text)
                .font(.footnote)
                // 自适应换行且对齐：
                .multilineTextAlignment(.leading)
                // ---------------【设置frame的注意点 begin】---------------
                // .frame(width: .infinity)
                // 设置绝对宽度为infinity是无效的，是不会自动扩大至最大边，
                // infinity不是一个明确的数值，只是最大的意思，
                // frame.width/height要设置成【明确的数值】才生效，
                // 如果父视图的宽度超出上面设置的绝对宽度，那么上面内容则会以【居中】显示。
                // -------------------------------------------
                .frame(maxWidth: .infinity, alignment: .leading)
                // 要设置`maxWidth`为`infinity`，才能自动把宽度扩大至父视图的能容纳的最大宽度。
                // ---------------【设置frame的注意点 ended】---------------
                .foregroundColor(.secondary)
                .lineLimit(sizeCategory > .large ? 1 : 2) // 最多两行
            
            // H/V/ZStack默认都以里面子视图中最大的宽高作为其宽高，
            // 所以只需要设置【其中一个】子视图的`maxWidth`为`infinity`即可，
            // 这样就可以将H/V/ZStack撑开至父视图的最大宽高。
            
            // 想设置H/V/ZStack为父视图的最大宽高还是要设置其子视图的frame，让子视图去撑开，
            // 除非只想让background撑开至父视图的最大宽高才只设置H/V/ZStack的frame。
        }
        // .frame(maxWidth: .infinity)
        // 只设置`H/V/ZStack`的`maxWidth`为`infinity`也只会影响`H/V/ZStack`及其`background`的宽度，
        // 并【不会影响】里面子视图的宽度，子视图依然保持自适应的宽度（子视图不设置`frame`的情况下），
        // 因此需要设置【里面其中一个】子视图的`maxWidth`为`infinity`，让子视图将`H/V/ZStack`撑开。
        .padding(.all, 20)
        .padding(.vertical, 20)
        .frame(height: 350.0)
        // ---------------【设置圆角背景的注意点 begin】---------------
        // 方法1：使用`mask`，但内容超出的部分会被裁剪掉（弃用该方法）
//        .cornerRadius(30.0)
//        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        // 方法2：直接将背景设置成带圆角的形状，这样就不需要裁剪了，内容超出的部分也能显示了
//        .background(
//            // 毛玻璃样式（这属于ShapeStyle的背景）
//            .ultraThinMaterial,
//            // 将背景放入到一个图形内（ShapeStyle的背景才可以放入到图形内）
//            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
//        )
        //【视差需求】：由于`shadow`会作用于除了视图本身还包括其所有子视图，如果不想`shadow`作用于里面的子视图，就要将其裁剪掉。
        .background(.ultraThinMaterial)
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        // ---------------【设置圆角背景的注意点 ended】---------------
        //【视差需求】：这部分挪出去做视差效果了，因为如果在`rotation3DEffect`之前就设置`shadow`，就会导致毛玻璃背景没有效果。
//        .shadow(color: Color("Shadow").opacity(0.3), radius: 10, x: 0, y: 10)
        // 添加圆角渐变边框
        .strokeStyle() // 要在padding之前添加，好让下面的padding也能作用到这个overlay
        .padding(.horizontal, 20)
        // overlay：叠加层，可以在里面添加额外的view覆盖到父view上面。
        //【视差需求】：这部分挪出去做视差效果了，让其不受`rotation3DEffect`影响。
//        .overlay(
//            // 如果上面已经用cornerRadius裁剪了，在这里添加才不会被裁剪掉
//            Image(course.image) // SwiftUI默认始终采用图像的原始尺寸（图片多大就多大）
//                .resizable() // 设置这个可以确保图片大小限制在剩余所有的可用空间内（过小则拉伸至容器大小）
//                .aspectRatio(contentMode: .fit)
//                .frame(height: 230)
//                .offset(x: 32, y: -80)
//        )
    }
}

struct FeaturedItem_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedItem()
    }
}
