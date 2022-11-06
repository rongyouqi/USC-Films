//
//  DetailPageView.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/29.
//

import Foundation
import SwiftUI
import youtube_ios_player_helper

struct DetailPageView: View {
    @Environment(\.openURL) var openURL
    var key: [String]
    var detail: [Detail]
    var casts: [Cast]
    var reviews: [Review]
    var recommendations: [Post]
    var id: Int
    var media_type: String
    var poster_path: String
    @State private var width = CGFloat(300)
    @State private var playerView = YTPlayerView()
    @Binding var isInWatchlist: Bool
    @Binding var showToast: Bool
    let userDefaults = UserDefaults.standard
    var body: some View {
        VStack {
            ScrollView (.vertical) {
                VStack {
                    VStack {
                        if (self.key.count != 0) {
                            YTWrapper(videoID: self.key[0]).frame(height: 200)
                        }
                    }
                    
                    VStack (alignment: .leading) {
                        if (self.detail.count != 0) {
                            if (self.detail[0].name != "") {
                                Text(self.detail[0].name)
                                    .font(.system(size: 32)).bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.init(top: 0, leading: 0, bottom: 5, trailing: 0))
                            }
                            if (self.detail[0].year != "" && self.detail[0].genres != "") {
                                Text(self.detail[0].year + " | " + self.detail[0].genres).padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                            } else if (self.detail[0].year != "" && self.detail[0].genres == "") {
                                Text(self.detail[0].year).padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                            } else if (self.detail[0].year == "" && self.detail[0].genres != "") {
                                Text(self.detail[0].genres).padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                            }
                            if (self.detail[0].vote_average >= 0) {
                                HStack {
                                    Image(systemName: "star.fill").foregroundColor(Color.red)
                                    Text(String(self.detail[0].vote_average.roundTo(places: 1)) + "/5.0")
                                }.padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                            }
                            if (self.detail[0].overview != "") {
                                LongText(self.detail[0].overview)
                            }
                        }

                        if (self.casts.count != 0) {
                            VStack {
                                Text("Cast & Crew")
                                    .font(.system(size: 26)).bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top)
                                
                                ScrollView(.horizontal) {
                                    HStack(alignment: .top, spacing: 10) {
                                        ForEach(self.casts) { cast in
                                            CastCardView(cast: cast)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (self.reviews.count != 0) {
                            VStack {
                                Text("Reviews")
                                    .font(.system(size: 26)).bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top)
                                
                                GeometryReader { geometry -> Color in
                                    DispatchQueue.main.async {
                                        self.width = geometry.size.width
                                    }
                                    return Color.clear
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(self.reviews) { review in
                                        NavigationLink(destination: ReviewView(review: review, name: self.detail[0].name)) {
                                            ReviewCardView(review: review, width: self.width)
                                        }
                                    }
                                    
                                }.fixedSize(horizontal: false, vertical: true)
                            }
                        }

                        if (self.recommendations.count != 0) {
                            VStack {
                                Text("Recommended Movies")
                                    .font(.system(size: 26)).bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top)

                                ScrollView(.horizontal) {
                                    HStack(alignment: .top, spacing: 40) {
                                        ForEach(self.recommendations) { post in
                                            NavigationLink(destination: DetailView(media_type: post.media_type, id: post.id, poster_path: post.poster_path)) {
                                                RecommendedCardView(post: post)
                                            }
                                        }
                                    }.padding(.init(top: 0, leading: 15, bottom: 0, trailing: 15))
                                }
                            }.padding(.bottom)
                        }
                    }
                }
            }.padding(.leading).padding(.trailing)
        }
        .toast(isPresented: self.$showToast) {
            VStack {
                if self.isInWatchlist {
                    Text(self.detail[0].name + " was added to Watchlist")
                } else {
                    Text(self.detail[0].name + " was removed from Watchlist")
                }
            }
        }
    }
}
