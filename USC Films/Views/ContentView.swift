//
//  ContentView.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/24.
//

import SwiftUI
import Alamofire
import SwiftyJSON

let url = "http://csci571hw9ryq.us-east-1.elasticbeanstalk.com"

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension View {
    func toast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        Toast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}

struct ContentView: View {
    @State private var selection: Tab = .home
    enum Tab {
        case search
        case home
        case watchlist
    }
    
    var body: some View {
        TabView(selection: $selection) {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)
            
            WatchlistView()
                .tabItem {
                    Label("Watchlist", systemImage: "heart")
                }
                .tag(Tab.watchlist)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
