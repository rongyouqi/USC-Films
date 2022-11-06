//
//  LongText.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/29.
//

import Foundation
import SwiftUI

struct LongText: View {
    /* Indicates whether the user want to see all the text or not. */
    @State private var expanded: Bool = false

    /* Indicates whether the text has been truncated in its display. */
    @State private var truncated: Bool = false

    private var text: String

    init(_ text: String) {
        self.text = text
    }
    
    private func determineTruncation(_ geometry: GeometryProxy) {
        // Calculate the bounding box we'd need to render the
        // text given the width from the GeometryReader.
        let total = self.text.boundingRect(
            with: CGSize(
                width: geometry.size.width,
                height: .greatestFiniteMagnitude
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        )

        if total.size.height > geometry.size.height {
            self.truncated = true
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 15.5))
                .lineLimit(self.expanded ? nil : 3)
                .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        self.determineTruncation(geometry)
                    }
                })
            if self.truncated {
                if (self.expanded) {
                    Button(action: {
                        self.expanded = false
                    }, label: {
                        Text("Show less")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.system(size: 15.5))
                            .foregroundColor(Color.gray)
                    })
                } else {
                    Button(action: {
                        self.expanded = true
                    }, label: {
                        Text("Show more..")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.system(size: 15.5))
                            .foregroundColor(Color.gray)
                    })
                }
            }
        }
    }
}
