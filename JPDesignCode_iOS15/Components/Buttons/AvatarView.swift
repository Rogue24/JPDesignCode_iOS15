//
//  AvatarView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/7/3.
//

import SwiftUI

struct AvatarView: View {
    @AppStorage("isLogged") var isLogged = true
    
    var body: some View {
        //【AsyncImage方式1】：只接收成功的情况
//        AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
//            image.resizable()
//        } placeholder: {
//            ProgressView()
//        }
        Group {
            if isLogged {
                //【AsyncImage方式2】：监听所有的情况
                AsyncImage(url: URL(string: "https://picsum.photos/26"),
                           transaction: Transaction(animation: .easeOut)) { phase in
                    switch phase {
                    // 请求中
                    case .empty:
                        ProgressView()
                    // 请求成功
                    case .success(let image):
                        image
                            .resizable()
                            .transition(.scale(scale: 0.5, anchor: .center))
                    // 请求失败
                    case .failure:
                        Color.gray
                    // 其他未知情况
                    @unknown default:
                        EmptyView() // 此视图无论设置什么都是空白的。
                    }
                }
            } else {
                Image("Avatar Default")
                    .resizable()
            }
        }
        .frame(width: 26, height: 26)
        .cornerRadius(10)
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .strokeStyle(cornerRadius: 18)
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(isLogged: true)
    }
}
