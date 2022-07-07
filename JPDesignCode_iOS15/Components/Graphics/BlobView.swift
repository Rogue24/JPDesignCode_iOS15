//
//  BlobView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/5/29.
//

import SwiftUI

struct BlobView: View {
    @State var appear = false
    
    var body: some View {
        // 绘制矢量图
        // 1.使用Shape
//        BlobShape()
//            .frame(width: 400, height: 414)
//            .foregroundStyle(
//                .linearGradient(colors: [.pink, .blue],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing)
//            )
        // 2.使用Canvas（推荐：用于动画性能高）
        TimelineView(.animation) { timeline in
            let now = timeline.date.timeIntervalSinceReferenceDate
            
            let remainder1 = now.remainder(dividingBy: 3) // -1.5 ~ 1.5
            let angle1 = Angle.degrees(remainder1 * 60) // -90° ~ 90°
            let x1 = cos(angle1.radians)
            
            let remainder2 = now.remainder(dividingBy: 6) // -3 ~ 3
            let angle2 = Angle.degrees(remainder2 * 10) // -30° ~ 30°
            let x2 = cos(angle2.radians)
            
            Canvas { context, size in
                context.fill(
                    blobPath(in: CGRect(origin: .zero, size: size), x1: x1, x2: x2),
                    // 在Canvas的context.fill中想使用foregroundStyle设置渐变色是不起作用的，需在这设置渐变色
                    with: .linearGradient(
                        Gradient(colors: [.pink, .blue]),
                        // 这里的起点和终点并不是百分比，而是确实数值
                        startPoint: CGPoint(x: 0, y: 0),
                        endPoint: CGPoint(x: 400, y: 414)
                    )
                )
            }
            .frame(width: 400, height: 414)
            .rotationEffect(.degrees(appear ? 360 : 0))
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: true)) {
                appear = true
            }
        }
    }
}

struct BlobView_Previews: PreviewProvider {
    static var previews: some View {
        BlobView()
    }
}

struct BlobShape: Shape {
    func path(in rect: CGRect) -> Path {
        blobPath(in: rect)
    }
}

func blobPath(in rect: CGRect, x1: Double = 1, x2: Double = 1) -> Path {
    var path = Path()
    let width = rect.size.width
    let height = rect.size.height
    path.move(to: CGPoint(x: 0.9923*width, y: 0.42593*height))
    path.addCurve(to: CGPoint(x: 0.6355*width*x2, y: height), control1: CGPoint(x: 0.92554*width*x2, y: 0.77749*height*x2), control2: CGPoint(x: 0.91864*width*x2, y: height))
    path.addCurve(to: CGPoint(x: 0.08995*width, y: 0.60171*height), control1: CGPoint(x: 0.35237*width*x1, y: height), control2: CGPoint(x: 0.2695*width, y: 0.77304*height))
    path.addCurve(to: CGPoint(x: 0.34086*width, y: 0.06324*height*x1), control1: CGPoint(x: -0.0896*width, y: 0.43038*height), control2: CGPoint(x: 0.00248*width, y: 0.23012*height*x1))
    path.addCurve(to: CGPoint(x: 0.9923*width, y: 0.42593*height), control1: CGPoint(x: 0.67924*width, y: -0.10364*height*x1), control2: CGPoint(x: 1.05906*width, y: 0.07436*height*x2))
    path.closeSubpath()
    return path
}
