//
//  SearchResultView.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/30.
//

import Foundation
import SwiftUI

struct SearchResultView: View {
    var searchVM: SearchViewModel
    @State var show: Bool = false
    @State var count: Int = 0
    @Binding var text: String
    let debouncer = Debouncer(delay: 1)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ScrollView(.vertical) {
            if (show && self.text.count > 2) {
                if (self.searchVM.searchs.count == 0) {
                    Text("No Results").foregroundColor(Color.gray)
                        .font(.system(size: 32)).padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(self.searchVM.searchs) { res in
                        GeometryReader { geometry in
                            NavigationLink(destination: DetailView(media_type: res.media_type, id: res.id, poster_path: res.poster_path)) {
                                ZStack {
                                    RemoteImage(url: res.backdrop_path)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width, height: 200)
                                        .clipped()
                                        .cornerRadius(10)
                                    Text(res.name).foregroundColor(Color.white)
                                        .font(Font.system(size: 20, weight: .bold).lowercaseSmallCaps())
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .bottomLeading)
                                        .offset(x: 10, y: 85)
                                    HStack {
                                        if (res.year != "") {
                                            Text(res.media_type.uppercased()+"("+res.year+")").foregroundColor(Color.white)
                                                .font(.system(size: 20)).bold()
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .offset(x: 10, y: -85)
                                        } else {
                                            Text(res.media_type.uppercased()).foregroundColor(Color.white)
                                                .font(.system(size: 24)).bold()
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .offset(x: 10, y: -85)
                                        }
                                    }
                                    HStack {
                                        Image(systemName: "star.fill").foregroundColor(Color.red)
                                            .frame(height: 20)
                                        Text(String(res.rating.roundTo(places: 1)) + "/5.0")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 20)).bold()
                                    }.frame(maxWidth: .infinity, alignment: .topTrailing)
                                    .offset(x: -10, y: -85)
                                    .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                }
                            }
                        }.frame(height: 200)
                        
                    }
                }
            }
        }
        .onAppear() {
            debouncer.run {
                self.searchVM.fetchData(text: self.text)
                self.count = self.text.count
                self.show = true
            }
        }
        .onReceive(timer, perform: { _ in
            if (self.count != self.text.count) {
                debouncer.run {
                    self.searchVM.fetchData(text: self.text)
                    self.count = self.text.count
                    self.show = true
                }
            }
        })
    }
}
