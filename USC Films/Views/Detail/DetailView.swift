//
//  DetailView.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/27.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @Environment(\.openURL) var openURL
    @State var isInWatchlist: Bool = false
    @ObservedObject var movieVM = MovieDetailViewModel()
    @ObservedObject var tvVM = TvDetailViewModel()
    @State var name: String = ""
    @State private var showToast: Bool = false
    @State var media_type: String
    @State var id: Int
    @State var poster_path: String
    let userDefaults = UserDefaults.standard
    var body: some View {
        if (self.movieVM.fetchComplete || self.tvVM.fetchComplete) {
            if (media_type == "movie") {
                DetailPageView(
                    key: self.movieVM.key,
                    detail: self.movieVM.detail,
                    casts: self.movieVM.casts,
                    reviews: self.movieVM.reviews,
                    recommendations: self.movieVM.recommendations,
                    id: self.id,
                    media_type: self.media_type,
                    poster_path: self.poster_path,
                    isInWatchlist: self.$isInWatchlist,
                    showToast: self.$showToast)
                    .navigationBarItems(trailing: HStack {
                        Button(action: {
                            var array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                            for element in array {
                                var item: WatchlistItem
                                do {
                                    item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                    if (self.id == item.itemID && self.media_type == item.media_type) {
                                        self.isInWatchlist = true
                                    }
                                } catch {
                                    print("decode failure")
                                }
                            }
                            if self.isInWatchlist {
                                var newItems = [String]()
                                for element in array {
                                    var item: WatchlistItem
                                    do {
                                        item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                        if (item.itemID != self.id || item.media_type != self.media_type) {
                                            newItems.append(element)
                                        }
                                    } catch {
                                        print("decode failure")
                                    }
                                }
                                userDefaults.set(newItems, forKey: "watchlist")
                            } else {
                                var string: Data
                                do {
                                    string = try JSONEncoder().encode(WatchlistItem(itemID: self.id, media_type: self.media_type, poster_path: self.poster_path))
                                    array.append(String(data: string, encoding: .utf8)!)
                                    userDefaults.set(array, forKey: "watchlist")
                                } catch {
                                    print("encode failure")
                                }
                            }
                            print("bookmark" + self.media_type + String(self.id))
                            self.isInWatchlist = !self.isInWatchlist
                        }, label: {
                            if self.isInWatchlist {
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(Color.blue)
                            } else {
                                Image(systemName: "bookmark")
                                    .foregroundColor(.primary)
                            }
                        })
                        Button(action: {
                            openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/" + String(self.id))!)
                            print("facebook" + self.media_type + String(self.id))
                        }, label: {
                            Image("facebook-app-symbol")
                                .resizable()
                                .frame(width: 16, height: 16)
                        })
                        Button(action: {
                            openURL(URL(string: "https://twitter.com/intent/tweet?url=Check%20out%20this%20link:%20https://www.themoviedb.org/movie/" + String(self.id) + "%20%23CSCI571USCFilms")!)
                            print("twitter" + self.media_type + String(self.id))
                        }, label: {
                            Image("twitter")
                                .resizable()
                                .frame(width: 16, height: 16)
                        })
                    })
                    .onAppear() {
                        print("detail view")
                        let array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                        for element in array {
                            var item: WatchlistItem
                            do {
                                item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                if (self.id == item.itemID && self.media_type == item.media_type) {
                                    self.isInWatchlist = true
                                }
                            } catch {
                                print("decode failure")
                            }
                        }
                    }
            }
            if (media_type == "tv") {
                DetailPageView(
                    key: self.tvVM.key,
                    detail: self.tvVM.detail,
                    casts: self.tvVM.casts,
                    reviews: self.tvVM.reviews,
                    recommendations: self.tvVM.recommendations,
                    id: self.id,
                    media_type: self.media_type,
                    poster_path: self.poster_path,
                    isInWatchlist: self.$isInWatchlist,
                    showToast: self.$showToast)
                    .navigationBarItems(trailing: HStack {
                        Button(action: {
                            var array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                            if self.isInWatchlist {
                                var newItems = [String]()
                                for element in array {
                                    var item: WatchlistItem
                                    do {
                                        item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                        if (item.itemID != self.id || item.media_type != self.media_type) {
                                            newItems.append(element)
                                        }
                                    } catch {
                                        print("decode failure")
                                    }
                                }
                                userDefaults.set(newItems, forKey: "watchlist")
                            } else {
                                var string: Data
                                do {
                                    string = try JSONEncoder().encode(WatchlistItem(itemID: self.id, media_type: self.media_type, poster_path: self.poster_path))
                                    array.append(String(data: string, encoding: .utf8)!)
                                    userDefaults.set(array, forKey: "watchlist")
                                } catch {
                                    print("encode failure")
                                }
                            }
                            print("bookmark" + self.media_type + String(self.id))
                            self.isInWatchlist = !self.isInWatchlist
                        }, label: {
                            if self.isInWatchlist {
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(Color.blue)
                            } else {
                                Image(systemName: "bookmark")
                                    .foregroundColor(.primary)
                            }
                        })
                        Button(action: {
                            openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/tv/" + String(self.id))!)
                            print("facebook" + self.media_type + String(self.id))
                        }, label: {
                            Image("facebook-app-symbol")
                                .resizable()
                                .frame(width: 16, height: 16)
                        })
                        Button(action: {
                            openURL(URL(string: "https://twitter.com/intent/tweet?url=Check%20out%20this%20link:%20https://www.themoviedb.org/tv/" + String(self.id) + "%20%23CSCI571USCFilms")!)
                            print("twitter" + self.media_type + String(self.id))
                        }, label: {
                            Image("twitter")
                                .resizable()
                                .frame(width: 16, height: 16)
                        })
                    })
                    .onAppear() {
                        print("detail view")
                        let array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                        for element in array {
                            var item: WatchlistItem
                            do {
                                item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                if (self.id == item.itemID && self.media_type == item.media_type) {
                                    self.isInWatchlist = true
                                }
                            } catch {
                                print("decode failure")
                            }
                        }
                    }
            }
        } else {
            ProgressView("Fetching Data...").frame(alignment: .center)
                .onAppear {
                    if (media_type == "movie") {
                        self.movieVM.fetchDetail(id: self.id)
                    }
                    if (media_type == "tv") {
                        self.tvVM.fetchDetail(id: self.id)
                    }
                }
        }
    }
}
