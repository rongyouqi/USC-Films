//
//  WatchlistView.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/27.
//

import Foundation
import SwiftUI

struct WatchlistView: View {
    let userDefaults = UserDefaults.standard
    @State private var isEmpty: Bool = true
    @State private var isIn: Bool = false
    @ObservedObject var watchlistVM = WatchlistViewModel()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var body: some View {
        NavigationView {
            VStack {
                if self.isEmpty {
                    Text("Watchlist is empty")
                        .font(.system(size: 24))
                        .foregroundColor(Color.gray)
                        .navigationBarTitle("")
                } else {
                    VStack {
                        ScrollView(.vertical) {
                            LazyVGrid(columns: columns, spacing: 0) {
                                ForEach(self.watchlistVM.items) { item in
                                    NavigationLink(destination: DetailView(media_type: item.media_type, id: item.itemID, poster_path: item.poster_path)) {
                                        RemoteImage(url: item.poster_path)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 117, height: 175.5, alignment: .center)
                                            .padding(2.5)
                                            .background(Color.white)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .contextMenu {
                                        
                                        Button(action: {
                                            for e in self.watchlistVM.items {
                                                if (item.itemID == e.itemID && item.media_type == e.media_type) {
                                                    self.isIn = true
                                                    break
                                                }
                                            }
                                            var array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                                            if self.isIn {
                                                var newItems = [String]()
                                                for element in array {
                                                    var newitem: WatchlistItem
                                                    do {
                                                        newitem = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                                        if (newitem.itemID != item.itemID || newitem.media_type != item.media_type) {
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
                                                    string = try JSONEncoder().encode(WatchlistItem(itemID: item.itemID, media_type: item.media_type, poster_path: item.poster_path))
                                                    array.append(String(data: string, encoding: .utf8)!)
                                                    userDefaults.set(array, forKey: "watchlist")
                                                } catch {
                                                    print("encode failure")
                                                }
                                            }
                                        }, label: {
                                            if self.isIn {
                                                HStack {
                                                    Text("Remove from watchList")
                                                        .foregroundColor(.primary)
                                                    Image(systemName: "bookmark.fill")
                                                        .foregroundColor(.primary)
                                                }
                                            } else {
                                                HStack {
                                                    Text("Add to watchList")
                                                        .foregroundColor(.primary)
                                                    Image(systemName: "bookmark")
                                                        .foregroundColor(.primary)
                                                }
                                            }
                                        }).onAppear() {
                                            for e in self.watchlistVM.items {
                                                if (item.itemID == e.itemID && item.media_type == e.media_type) {
                                                    self.isIn = true
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                            }.padding(.horizontal)
                        }.navigationBarTitle("Watchlist")
                    }
                }
            }.onAppear(perform: {
                print("WatchlistView.onAppear()")
                let array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                if (array.count == 0) {
                    self.isEmpty = true
                } else {
                    self.isEmpty = false
                }
                self.watchlistVM.getWLupdate()
            })
        }
    }
}
