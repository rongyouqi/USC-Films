//
//  WatchlistViewModel.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/29.
//

import Foundation

class WatchlistViewModel: ObservableObject {
    @Published var items = [WatchlistItem]()
    let userDefaults = UserDefaults.standard
    
//    init() {
//        items.removeAll()
//        let array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
//        for element in array {
//            var item: WatchlistItem
//            do {
//                item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
//                self.items.append(item)
//            } catch {
//                print("decode failure")
//            }
//        }
//        print("watching list init() " + String(items.count))
//    }
    
    func getWLupdate() {
        items.removeAll()
        let array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
        for element in array {
            var item: WatchlistItem
            do {
                item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                self.items.append(item)
            } catch {
                print("decode failure")
            }
        }
        print("watching list fetched " + String(items.count))
    }
}
