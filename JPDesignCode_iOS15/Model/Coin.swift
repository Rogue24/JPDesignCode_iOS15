//
//  Coin.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/7/3.
//

import SwiftUI

struct Coin: Identifiable, Decodable {
    let id: Int
    let coin_name: String
    let acronym: String
    let logo: String
}

class CoinModel: ObservableObject {
    @Published var coins: [Coin] = []
    
    //【`@MainActor`】
    // 个人猜测：确保代码会执行在主线程中（除了异步函数的内部执行外）
    // 更多解释：https://xiaozhuanlan.com/topic/2957164803
    @MainActor
    func fetchCoins() async {
        do {
            let url = URL(string: "https://random-data-api.com/api/crypto_coin/random_crypto_coin?size=10")!
            let (data, _) = try await URLSession.shared.data(from: url)
            coins = try JSONDecoder().decode([Coin].self, from: data)
        } catch {
            print("jpjpjp fetchCoins failed \(error)")
        }
    }
}
