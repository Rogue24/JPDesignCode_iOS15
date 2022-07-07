//
//  HexagonView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/5/29.
//

import SwiftUI

struct HexagonView: View {
    var body: some View {
        Canvas { context, size in
            context.draw(
                Text("DesignCode").font(.largeTitle),
                at: CGPoint(x: 50, y: 20)
            )
            context.draw(
                Image(systemName: "hexagon.fill"),
                in: CGRect(origin: .zero, size: size)
            )
        }
        .frame(width: 200, height: 212)
        .foregroundStyle(
            .linearGradient(colors: [.pink, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing)
        )
    }
}

struct HexagonView_Previews: PreviewProvider {
    static var previews: some View {
        HexagonView()
    }
}
