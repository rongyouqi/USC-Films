//
//  Review.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/28.
//

import Foundation

struct Review: Identifiable {
    var id = UUID()
    var author : String
    var content : String
    var created_at : String
    var rating : Double
}
