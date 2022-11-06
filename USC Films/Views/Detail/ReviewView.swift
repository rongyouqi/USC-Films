//
//  ReviewView.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/28.
//

import Foundation
import SwiftUI

struct ReviewView: View {
    var review: Review
    var name: String
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    if (name != "") {
                        Text(name)
                            .font(.system(size: 32)).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.init(top: 0, leading: 0, bottom: 5, trailing: 0))
                    }
                    if (review.author != "" && review.created_at != "") {
                        Text("By " + review.author + " on " + review.created_at)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .foregroundColor(Color.gray)
                            .padding(.init(top: 0, leading: 0, bottom: 5, trailing: 0))
                    }
                    if (review.rating >= 0) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.red)
                            Text(String(review.rating.roundTo(places: 1)) + "/5.0")
                                .foregroundColor(.primary)
                        }.padding(.init(top: 0, leading: 0, bottom: 5, trailing: 0))
                    }
                    Divider()
                    if (review.content != "") {
                        Text(review.content)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .padding(.init(top: 5, leading: 0, bottom: 10, trailing: 0))
                    }
                }
            }.padding(.leading).padding(.trailing)
        }
        .navigationBarTitle("", displayMode: .large)
        .navigationBarHidden(false)
        
    }
}
