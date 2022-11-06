//
//  CarouselView.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/27.
//

import Foundation
import SwiftUI

struct CarouselView: View {
    var title: String
    var posts: [Post]
    var body: some View {
        Text(self.title)
            .font(.system(size: 24)).bold()
            .frame(maxWidth: .infinity, alignment: .leading)
        
        GeometryReader { geometry in
            ImageCarouselView(numberOfImages: posts.count) {
                ForEach(self.posts) { post in
                    NavigationLink(destination: DetailView(media_type: post.media_type, id: post.id, poster_path: post.poster_path)) {
                        ZStack {
                            RemoteImage(url: post.poster_path)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: 300)
                                .blur(radius: 10).clipped()
                            
                            RemoteImage(url: post.poster_path)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 300)
                        }
                    }
                }
            }
        }.frame(height: 300)
    }
}
