//
//  HomeView.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/27.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var showingTV = false
    @ObservedObject var homeVM = HomeViewModel()
    @State var name: String = ""
    @State var isInWatchlist: Bool = false
    @State private var showToast: Bool = false
    @Environment(\.openURL) var openURL
    let userDefaults = UserDefaults.standard
    var body: some View{
        if self.homeVM.fetchComplete == false {
            ProgressView("Fetching Data...")
        } else {
            NavigationView {
                ScrollView {
                    if self.showingTV {
                        VStack {
                            CarouselView(title: "Trending", posts: self.homeVM.posts12)
                            // SlideView(title: "Top Rated", posts: self.posts13)
                            VStack {
                                Text("Top Rated")
                                    .font(.system(size: 24)).bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ScrollView(.horizontal) {
                                    HStack(alignment: .top, spacing: 20) {
                                        ForEach(self.homeVM.posts13) { post in
                                            VStack {
                                                // CardView(post: post)
                                                NavigationLink(destination: DetailView(media_type: post.media_type, id: post.id, poster_path: post.poster_path)) {
                                                    VStack {
                                                        RemoteImage(url: post.poster_path)
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 100, height: 150)
                                                            .cornerRadius(10)

                                                        Text(post.name)
                                                            .foregroundColor(.primary)
                                                            .font(.system(size: 12)).bold()
                                                            .fixedSize(horizontal: false, vertical: true)
                                                            .lineLimit(nil)
                                                            .multilineTextAlignment(.center)
                                                        
                                                        Text("("+post.year+")")
                                                            .foregroundColor(Color.gray)
                                                            .font(.system(size: 12))
                                                    }
                                                    .frame(width: 100)
                                                    .background(Color.white)
                                                    .cornerRadius(10)
                                                }
                                                .frame(width: 100)
                                                .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                                .buttonStyle(PlainButtonStyle())
                                                .contextMenu {
                                                    Button(action: {
                                                        var array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                                                        if self.isInWatchlist {
                                                            var newItems = [String]()
                                                            for element in array {
                                                                var item: WatchlistItem
                                                                do {
                                                                    item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                                                    if (item.itemID != post.id || item.media_type != post.media_type) {
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
                                                                string = try JSONEncoder().encode(WatchlistItem(itemID: post.id, media_type: post.media_type, poster_path: post.poster_path))
                                                                array.append(String(data: string, encoding: .utf8)!)
                                                                userDefaults.set(array, forKey: "watchlist")
                                                            } catch {
                                                                print("encode failure")
                                                            }
                                                        }
                                                        print("bookmark" + post.media_type + String(post.id))
                                                        self.isInWatchlist = !self.isInWatchlist
                                                        if (!self.showToast) {
                                                            withAnimation {
                                                                name = post.name
                                                                self.showToast = true
                                                            }
                                                        }
                                                    }, label: {
                                                        if isInWatchlist {
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
                                                        print("button")
                                                        let array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                                                        for element in array {
                                                            var item: WatchlistItem
                                                            do {
                                                                item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                                                if (post.id == item.itemID && post.media_type == item.media_type) {
                                                                    self.isInWatchlist = true
                                                                    break
                                                                }
                                                            } catch {
                                                                print("decode failure")
                                                            }
                                                        }
                                                    }
                                                    Button(action: {
                                                        openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/" + post.media_type + "/" + String(post.id))!)
                                                        print("facebook" + post.media_type + String(post.id))
                                                    }, label: {
                                                        HStack {
                                                            Text("Share on Facebook")
                                                            Image("facebook-app-symbol")
                                                                .resizable()
                                                                .frame(width: 16, height: 16)
                                                        }
                                                        
                                                    })
                                                    Button(action: {
                                                        openURL(URL(string: "https://twitter.com/intent/tweet?url=Check%20out%20this%20link:%20https://www.themoviedb.org/" + post.media_type + "/" + String(post.id) + "%20%23CSCI571USCFilms")!)
                                                        print("twitter" + post.media_type + String(post.id))
                                                    }, label: {
                                                        HStack {
                                                            Text("Share on Twitter")
                                                            Image("twitter")
                                                                .resizable()
                                                                .frame(width: 16, height: 16)
                                                        }
                                                    })
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            // SlideView(title: "Popular", posts: self.posts14)
                            VStack {
                                Text("Popular")
                                    .font(.system(size: 24)).bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ScrollView(.horizontal) {
                                    HStack(alignment: .top, spacing: 20) {
                                        ForEach(self.homeVM.posts14) { post in
                                            VStack {
                                                // CardView(post: post)
                                                NavigationLink(destination: DetailView(media_type: post.media_type, id: post.id, poster_path: post.poster_path)) {
                                                    VStack {
                                                        RemoteImage(url: post.poster_path)
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 100, height: 150)
                                                            .cornerRadius(10)

                                                        Text(post.name)
                                                            .foregroundColor(.primary)
                                                            .font(.system(size: 12)).bold()
                                                            .fixedSize(horizontal: false, vertical: true)
                                                            .lineLimit(nil)
                                                            .multilineTextAlignment(.center)
                                                        
                                                        Text("("+post.year+")")
                                                            .foregroundColor(Color.gray)
                                                            .font(.system(size: 12))
                                                    }
                                                    .frame(width: 100)
                                                    .background(Color.white)
                                                    .cornerRadius(10)
                                                }
                                                .frame(width: 100)
                                                .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                                .buttonStyle(PlainButtonStyle())
                                                .contextMenu {
                                                    Button(action: {
                                                        var array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                                                        if self.isInWatchlist {
                                                            var newItems = [String]()
                                                            for element in array {
                                                                var item: WatchlistItem
                                                                do {
                                                                    item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                                                    if (item.itemID != post.id || item.media_type != post.media_type) {
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
                                                                string = try JSONEncoder().encode(WatchlistItem(itemID: post.id, media_type: post.media_type, poster_path: post.poster_path))
                                                                array.append(String(data: string, encoding: .utf8)!)
                                                                userDefaults.set(array, forKey: "watchlist")
                                                            } catch {
                                                                print("encode failure")
                                                            }
                                                        }
                                                        print("bookmark" + post.media_type + String(post.id))
                                                        self.isInWatchlist = !self.isInWatchlist
                                                        if (!self.showToast) {
                                                            withAnimation {
                                                                name = post.name
                                                                self.showToast = true
                                                            }
                                                        }
                                                    }, label: {
                                                        if isInWatchlist {
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
                                                        print("button")
                                                        let array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                                                        for element in array {
                                                            var item: WatchlistItem
                                                            do {
                                                                item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                                                if (post.id == item.itemID && post.media_type == item.media_type) {
                                                                    self.isInWatchlist = true
                                                                    break
                                                                }
                                                            } catch {
                                                                print("decode failure")
                                                            }
                                                        }
                                                    }
                                                    Button(action: {
                                                        openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/" + post.media_type + "/" + String(post.id))!)
                                                        print("facebook" + post.media_type + String(post.id))
                                                    }, label: {
                                                        HStack {
                                                            Text("Share on Facebook")
                                                            Image("facebook-app-symbol")
                                                                .resizable()
                                                                .frame(width: 16, height: 16)
                                                        }
                                                        
                                                    })
                                                    Button(action: {
                                                        openURL(URL(string: "https://twitter.com/intent/tweet?url=Check%20out%20this%20link:%20https://www.themoviedb.org/" + post.media_type + "/" + String(post.id) + "%20%23CSCI571USCFilms")!)
                                                        print("twitter" + post.media_type + String(post.id))
                                                    }, label: {
                                                        HStack {
                                                            Text("Share on Twitter")
                                                            Image("twitter")
                                                                .resizable()
                                                                .frame(width: 16, height: 16)
                                                        }
                                                    })
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }.navigationBarItems(trailing: Button(action: {
                            self.showingTV = false
                        }, label: {
                            Text("Movies")
                        }))
                    } else {
                        VStack {
                            CarouselView(title:"Now Playing", posts: self.homeVM.posts4)
                            // SlideView(title: "Top Rated", posts: self.posts3)
                            VStack {
                                Text("Top Rated")
                                    .font(.system(size: 24)).bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ScrollView(.horizontal) {
                                    HStack(alignment: .top, spacing: 20) {
                                        ForEach(self.homeVM.posts3) { post in
                                            VStack {
                                                // CardView(post: post)
                                                NavigationLink(destination: DetailView(media_type: post.media_type, id: post.id, poster_path: post.poster_path)) {
                                                    VStack {
                                                        RemoteImage(url: post.poster_path)
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 100, height: 150)
                                                            .cornerRadius(10)

                                                        Text(post.name)
                                                            .foregroundColor(.primary)
                                                            .font(.system(size: 12)).bold()
                                                            .fixedSize(horizontal: false, vertical: true)
                                                            .lineLimit(nil)
                                                            .multilineTextAlignment(.center)
                                                        
                                                        Text("("+post.year+")")
                                                            .foregroundColor(Color.gray)
                                                            .font(.system(size: 12))
                                                    }
                                                    .frame(width: 100)
                                                    .background(Color.white)
                                                    .cornerRadius(10)
                                                }
                                                .frame(width: 100)
                                                .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                                .buttonStyle(PlainButtonStyle())
                                                .contextMenu {
                                                    Button(action: {
                                                        var array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                                                        for element in array {
                                                            var item: WatchlistItem
                                                            do {
                                                                item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                                                if (post.id == item.itemID && post.media_type == item.media_type) {
                                                                    self.isInWatchlist = true
                                                                    break
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
                                                                    if (item.itemID != post.id || item.media_type != post.media_type) {
                                                                        var string: Data
                                                                        do {
                                                                            string = try JSONEncoder().encode(WatchlistItem(itemID: item.itemID, media_type: item.media_type, poster_path: item.poster_path))
                                                                            newItems.append(String(data: string, encoding: .utf8)!)
                                                                        } catch {
                                                                            print("encode failure")
                                                                        }
                                                                    }
                                                                } catch {
                                                                    print("decode failure")
                                                                }
                                                            }
                                                            userDefaults.set(newItems, forKey: "watchlist")
                                                        } else {
                                                            var string: Data
                                                            do {
                                                                string = try JSONEncoder().encode(WatchlistItem(itemID: post.id, media_type: post.media_type, poster_path: post.poster_path))
                                                                array.append(String(data: string, encoding: .utf8)!)
                                                                userDefaults.set(array, forKey: "watchlist")
                                                            } catch {
                                                                print("encode failure")
                                                            }
                                                        }
                                                        print("bookmark" + post.media_type + String(post.id))
                                                        self.isInWatchlist = !self.isInWatchlist
                                                        if (!self.showToast) {
                                                            withAnimation {
                                                                self.showToast = true
                                                                name = post.name
                                                            }
                                                        }
                                                    }, label: {
                                                        if isInWatchlist {
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
                                                        print("button")
                                                        let array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                                                        for element in array {
                                                            var item: WatchlistItem
                                                            do {
                                                                item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                                                if (post.id == item.itemID && post.media_type == item.media_type) {
                                                                    self.isInWatchlist = true
                                                                }
                                                            } catch {
                                                                print("decode failure")
                                                            }
                                                        }
                                                    }
                                                    Button(action: {
                                                        openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/" + post.media_type + "/" + String(post.id))!)
                                                        print("facebook" + post.media_type + String(post.id))
                                                    }, label: {
                                                        HStack {
                                                            Text("Share on Facebook")
                                                            Image("facebook-app-symbol")
                                                                .resizable()
                                                                .frame(width: 16, height: 16)
                                                        }
                                                        
                                                    })
                                                    Button(action: {
                                                        openURL(URL(string: "https://twitter.com/intent/tweet?url=Check%20out%20this%20link:%20https://www.themoviedb.org/" + post.media_type + "/" + String(post.id) + "%20%23CSCI571USCFilms")!)
                                                        print("twitter" + post.media_type + String(post.id))
                                                    }, label: {
                                                        HStack {
                                                            Text("Share on Twitter")
                                                            Image("twitter")
                                                                .resizable()
                                                                .frame(width: 16, height: 16)
                                                        }
                                                    })
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            // SlideView(title: "Popular", posts: self.posts5)
                            VStack {
                                Text("Popular")
                                    .font(.system(size: 24)).bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ScrollView(.horizontal) {
                                    HStack(alignment: .top, spacing: 20) {
                                        ForEach(self.homeVM.posts5) { post in
                                            VStack {
                                                // CardView(post: post)
                                                NavigationLink(destination: DetailView(media_type: post.media_type, id: post.id, poster_path: post.poster_path)) {
                                                    VStack {
                                                        RemoteImage(url: post.poster_path)
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 100, height: 150)
                                                            .cornerRadius(10)

                                                        Text(post.name)
                                                            .foregroundColor(.primary)
                                                            .font(.system(size: 12)).bold()
                                                            .fixedSize(horizontal: false, vertical: true)
                                                            .lineLimit(nil)
                                                            .multilineTextAlignment(.center)
                                                        
                                                        Text("("+post.year+")")
                                                            .foregroundColor(Color.gray)
                                                            .font(.system(size: 12))
                                                    }
                                                    .frame(width: 100)
                                                    .background(Color.white)
                                                    .cornerRadius(10)
                                                }
                                                .frame(width: 100)
                                                .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                                .buttonStyle(PlainButtonStyle())
                                                .contextMenu {
                                                    Button(action: {
                                                        var array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
                                                        for element in array {
                                                            var item: WatchlistItem
                                                            do {
                                                                item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
                                                                if (post.id == item.itemID && post.media_type == item.media_type) {
                                                                    self.isInWatchlist = true
                                                                    break
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
                                                                    if (item.itemID != post.id || item.media_type != post.media_type) {
                                                                        var string: Data
                                                                        do {
                                                                            string = try JSONEncoder().encode(WatchlistItem(itemID: item.itemID, media_type: item.media_type, poster_path: item.poster_path))
                                                                            newItems.append(String(data: string, encoding: .utf8)!)
                                                                        } catch {
                                                                            print("encode failure")
                                                                        }
                                                                    }
                                                                } catch {
                                                                    print("decode failure")
                                                                }
                                                            }
                                                            userDefaults.set(newItems, forKey: "watchlist")
                                                        } else {
                                                            var string: Data
                                                            do {
                                                                string = try JSONEncoder().encode(WatchlistItem(itemID: post.id, media_type: post.media_type, poster_path: post.poster_path))
                                                                array.append(String(data: string, encoding: .utf8)!)
                                                                userDefaults.set(array, forKey: "watchlist")
                                                            } catch {
                                                                print("encode failure")
                                                            }
                                                        }
                                                        print("bookmark" + post.media_type + String(post.id))
                                                        self.isInWatchlist = !self.isInWatchlist
                                                        if (!self.showToast) {
                                                            withAnimation {
                                                                self.showToast = true
                                                                name = post.name
                                                            }
                                                        }
                                                    }, label: {
                                                        if isInWatchlist {
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
                                                        print("button")
//                                                        let array = userDefaults.stringArray(forKey: "watchlist") ?? [String]()
//                                                        for element in array {
//                                                            var item: WatchlistItem
//                                                            do {
//                                                                item = try JSONDecoder().decode(WatchlistItem.self, from: element.data(using: .utf8)!)
//                                                                if (post.id == item.itemID && post.media_type == item.media_type) {
//                                                                    self.isInWatchlist = true
//                                                                    break
//                                                                }
//                                                            } catch {
//                                                                print("decode failure")
//                                                            }
//                                                        }
                                                    }
                                                    Button(action: {
                                                        openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/" + post.media_type + "/" + String(post.id))!)
                                                        print("facebook" + post.media_type + String(post.id))
                                                    }, label: {
                                                        HStack {
                                                            Text("Share on Facebook")
                                                            Image("facebook-app-symbol")
                                                                .resizable()
                                                                .frame(width: 16, height: 16)
                                                        }
                                                        
                                                    })
                                                    Button(action: {
                                                        openURL(URL(string: "https://twitter.com/intent/tweet?url=Check%20out%20this%20link:%20https://www.themoviedb.org/" + post.media_type + "/" + String(post.id) + "%20%23CSCI571USCFilms")!)
                                                        print("twitter" + post.media_type + String(post.id))
                                                    }, label: {
                                                        HStack {
                                                            Text("Share on Twitter")
                                                            Image("twitter")
                                                                .resizable()
                                                                .frame(width: 16, height: 16)
                                                        }
                                                    })
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .navigationBarItems(trailing: Button(action: {
                            self.showingTV = true
                        }, label: {
                            Text("TV shows")
                        }))
                    }
                    Link("Powered by TMDB", destination: URL(string: "https://www.themoviedb.org")!)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 12))
                    Text("Developed by Youqi Rong")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 12))
                }.padding(.leading).padding(.trailing)
                .navigationBarTitle("USC Films", displayMode: .automatic)
            }
            .toast(isPresented: self.$showToast) {
                VStack {
                    if self.isInWatchlist {
                        Text(self.name + " was added to Watchlist")
//                            .fixedSize(horizontal: false, vertical: true)
//                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                    } else {
                        Text(self.name + " was removed from Watchlist")
//                            .fixedSize(horizontal: false, vertical: true)
//                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
