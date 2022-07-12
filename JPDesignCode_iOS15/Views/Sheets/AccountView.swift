//
//  AccountView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/5/23.
//

import SwiftUI

struct AccountView: View {
    @State var isDeleted = false
    @State var isPinned = false
    @State var address = Address(id: 1, country: "China")
//    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss // 等同于直接调用`presentationMode.wrappedValue.dismiss()`
    @AppStorage("isLogged") var isLogged = true
    //【性能优化】精简模式：UI方面影响性能主要是[模糊]、[阴影]、[动画]效果，有性能问题的地方尽量少使用或直接不使用这三种耗性能的`Modified`。
    @AppStorage("isLiteMode") var isLiteMode = false
    @StateObject var coinModel = CoinModel()
    
    var body: some View {
        NavigationView {
            List {
                profile
                menu
                liteMode
                links
                coins
                signOut
            }
            // 新·Modifier【.task】：每当该视图出现时都会执行里面的异步函数（A view that runs the specified action asynchronously when the view appears）。
            .task {
                await fetchAddress()
                await coinModel.fetchCoins()
            }
            // 新·Modifier【.refreshable】：使`List`能够下拉刷新，
            // 下拉开始转菊花，执行里面的异步函数，执行完就自动收起菊花。
            .refreshable {
                await fetchAddress()
                await coinModel.fetchCoins()
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Account")
            .navigationBarItems(
                trailing: Button {
                    dismiss()
                } label: {
                    Text("Done").bold()
                }
            )
        }
    }
    
    var profile: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                //.symbolVariant(.circle.fill) // 等价于直接使用"person.circle.fill"
                .font(.system(size: 32))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.blue, .blue.opacity(0.3))
                .padding()
                .background(Circle().fill(.ultraThinMaterial))
                .background(
//                    Image(systemName: "hexagon")
//                        .symbolVariant(.fill) // 等价于直接使用"hexagon.fill"
//                        .foregroundColor(.blue)
//                        .font(.system(size: 200))
                    HexagonView()
                        .offset(x: -50, y: -100)
                )
                .background(
                    BlobView()
                        .offset(x: 200, y: 0)
                        .scaleEffect(0.6)
                )
            
            Text("斗了个平")
                .font(.title.weight(.semibold))
            
            HStack {
                Image(systemName: "location")
                    .imageScale(.small)
                Text(address.country)
                    .foregroundColor(.secondary)
            }
        }
        // 父视图的宽度已经子视图的最大宽度，所以子视图会【居中】显示。
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    var menu: some View {
        Section {
            NavigationLink {
                HomeView()
            } label: {
                Label("Settings", systemImage: "gear")
                    // 想要自定义的颜色就单独设置
                    .accentColor(.green)
            }
            
            NavigationLink {
                Text("Billing")
            } label: {
                Label("Billing", systemImage: "creditcard")
            }
            
            NavigationLink {
                Text("Help")
            } label: {
                Label("Help", systemImage: "questionmark")
            }
        }
        // 对整个`Section`设置以下`Modifier`，能同时应用到所有的子视图（对应`Modifier`没有单独设置过的才生效），
        // 不仅是`Section`，凡是能放入多个子视图的`View`都是如此（V/H/ZStack、Group）。
        // `systemImage`颜色（默认【淡紫色】）
        .accentColor(.primary)
        // 分隔线颜色
        .listRowSeparatorTint(.blue)
        // 分隔线是否显示
        .listRowSeparator(.hidden)
    }
    
    var liteMode: some View {
        Section {
            Toggle(isOn: $isLiteMode) {
                Label("Lite Mode", systemImage: isLiteMode ? "tortoise" : "hare")
            }
        }
        .accentColor(.primary)
    }
    
    var links: some View {
        Section {
            // Link：跳去Safari
            if !isDeleted {
                Link(destination: URL(string: "https://www.gamersky.com/")!) {
                    HStack {
                        Label("Gamersky", systemImage: "gamecontroller")
                        Spacer()
                        Image(systemName: "link")
                            .foregroundColor(.secondary)
                    }
                }
                .swipeActions(
                    edge: .trailing, // 滑动方向
                    allowsFullSwipe: false // 是否能通过滑动触发
                ) {
                    deleteButton
                    pinButton
                }
            }
            
            Link(destination: URL(string: "https://www.bilibili.com")!) {
                HStack {
                    Label("Bilibili", systemImage: "tv")
                    Spacer()
                    Image(systemName: "link")
                        .foregroundColor(.secondary)
                }
            }
            .swipeActions(
                edge: .leading, // 滑动方向
                allowsFullSwipe: false // 是否能通过滑动触发
            ) { pinButton }
        }
        .accentColor(.primary)
        .listRowSeparator(.hidden)
    }
    
    var coins: some View {
        Section(header: Text("Coins")) {
            ForEach(coinModel.coins) { coin in
                HStack {
//                    AsyncImage(url: URL(string: coin.logo)) {
//                        $0.resizable().aspectRatio(contentMode: .fit)
//                    } placeholder: {
//                        ProgressView()
//                    }
//                    .frame(width: 32, height: 32)
                    AsyncImage(url: URL(string: coin.logo),
                               transaction: Transaction(animation: .easeOut)) { phase in
                        switch phase {
                        // 请求中
                        case .empty:
                            ProgressView()
                        // 请求成功
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fit).transition(.opacity)
                        // 请求失败
                        case .failure:
                            Color.gray.cornerRadius(4)
                        // 其他未知情况
                        @unknown default:
                            EmptyView() // 此视图无论设置什么都是空白的。
                        }
                    }
                    .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(coin.coin_name)
                        Text(coin.acronym)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    var signOut: some View {
        Button {
            isLogged = false
            dismiss()
        } label: {
            Text("Sign out")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .tint(.red)
    }
    
    var deleteButton: some View {
        Button {
            isDeleted = true
        } label: {
            Label("Delete", systemImage: "trash")
        }
        .tint(.red) // 底色
    }
    
    var pinButton: some View {
        Button {
            isPinned.toggle()
        } label: {
            Label(isPinned ? "Unpin" : "Pin", systemImage: isPinned ? "pin.slash" : "pin")
        }
        .tint(isPinned ? .gray : .yellow) // 底色
    }
    
    func fetchAddress() async {
        do {
            let url = URL(string: "https://random-data-api.com/api/address/random_address")!
            let (data, _) = try await URLSession.shared.data(from: url)
//            print("jpjpjp \(String(decoding: data, as: UTF8.self))")
            address = try JSONDecoder().decode(Address.self, from: data)
        } catch {
//            print("jpjpjp fetchAddress failed \(error)")
            address = Address(id: 0, country: "Error fetching")
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
