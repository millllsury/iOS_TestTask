//
//  ItemRowView.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import SwiftUI

struct ItemRowView: View {
    let item: ListItem

    var body: some View {
        HStack(spacing: 12) {
            Image(item.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(item.description)
                    .font(.footnote)
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    Color(
                        red: 210 / 255.0,
                        green: 231 / 255.0,
                        blue: 225 / 255.0
                    )
                )
        )
    }
}

#Preview {
    ItemRowView(
        item: ListItem(
            id: "preview-waterfall",
            title: "Waterfall",
            description: "A calm waterfall hidden deep in nature.",
            imageName: "img2"
        )
    )
    .padding()
}
