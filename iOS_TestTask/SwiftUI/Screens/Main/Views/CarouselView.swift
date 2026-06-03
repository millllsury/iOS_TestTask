//
//  CarouselView.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import SwiftUI

struct CarouselView: View {
    let pages: [Page]
    @Binding var selectedPageIndex: Int

    private var pageCount: Int { pages.count }

    var body: some View {
        VStack(spacing: 12) {
            TabView(selection: $selectedPageIndex) {
                ForEach(0..<CarouselLoop.virtualItemCount(pageCount: pageCount), id: \.self) { virtualIndex in
                    let realIndex = CarouselLoop.realIndex(for: virtualIndex, pageCount: pageCount)
                    CarouselCardView(imageName: pages[realIndex].imageName)
                        .tag(virtualIndex)
                        .padding(.horizontal, 14)
                }
            }
            .frame(height: 220)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeOut(duration: 0.2), value: selectedPageIndex)

            HStack(spacing: 8) {
                let realIndex = CarouselLoop.realIndex(for: selectedPageIndex, pageCount: pageCount)
                ForEach(pages.indices, id: \.self) { index in
                    Circle()
                        .frame(width: 7, height: 7)
                        .foregroundStyle(
                            realIndex == index ? Color.blue : Color.gray.opacity(0.5)
                        )
                }
            }
            .padding(.vertical, 2)
        }
    }
}

#Preview {
    CarouselView(
        pages: MockPages.data,
        selectedPageIndex: .constant(CarouselLoop.middleIndex(pageCount: MockPages.data.count))
    )
}
