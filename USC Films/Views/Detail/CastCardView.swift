//
//  CastCardView.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/28.
//

import Foundation
import SwiftUI

struct CastCardView: View {
    var cast: Cast
    var body: some View {
        VStack {
            RemoteImage(url: self.cast.profile_path)
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 135)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                .shadow(radius: 1)
            
            Text(self.cast.name)
                .foregroundColor(.primary)
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(width: 90)
    }
}
