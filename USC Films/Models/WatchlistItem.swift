//
//  WatchlistItem.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/29.
//

import Foundation

struct WatchlistItem: Identifiable, Codable {
    var id = UUID()
    var itemID: Int
    var media_type: String
    var poster_path: String
}
