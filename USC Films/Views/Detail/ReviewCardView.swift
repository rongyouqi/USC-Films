//
//  ReviewCardView.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/29.
//

import Foundation
import SwiftUI

struct ReviewCardView: View {
    var review: Review
    var width: CGFloat
    var body: some View {
        VStack(alignment: .leading) {
            if (review.author != "") {
                Text("A review by " + review.author).bold()
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.init(top: 5, leading: 10, bottom: 0, trailing: 10))
                if (review.created_at != "") {
                    Text("Written by " + review.author + " on " + review.created_at)
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                }
            }
            if (review.rating >= 0) {
                HStack {
                    Image(systemName: "star.fill").foregroundColor(Color.red)
                    Text(String(review.rating.roundTo(places: 1)) + "/5.0")
                        .foregroundColor(.primary)
                }.padding(.init(top: 5, leading: 10, bottom: 0, trailing: 10))
            }
            if (review.content != "") {
                Text(review.content)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 15.5))
                    .lineLimit(3)
                    .padding(.init(top: 5, leading: 10, bottom: 10, trailing: 10))
            }
        }
        .frame(width: self.width)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).foregroundColor(Color.gray))
    }
}
