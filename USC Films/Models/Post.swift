//
//  Post.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/27.
//

import Foundation

struct Post : Identifiable {
    var id : Int
    var name : String
    var year : String
    var poster_path : String
    var media_type : String
    var isInWatchlist: Bool = false
}
