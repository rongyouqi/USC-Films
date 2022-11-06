//
//  RecommendedCardView.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/28.
//

import Foundation
import SwiftUI

struct RecommendedCardView: View {
    var post: Post
    var body: some View {
        VStack {
            RemoteImage(url: self.post.poster_path)
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 150)
                .cornerRadius(10)
            
            Spacer()
        }
        .frame(width: 100)
        .cornerRadius(10)
    }
}
