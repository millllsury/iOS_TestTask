//
//  MainView.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import SwiftUI

struct MainView: View {
    private enum Layout {
        static let fabSize: CGFloat = 56
        static let fabPadding: CGFloat = 20
        static let fabShadowRadius: CGFloat = 12
        static let bottomReserve: CGFloat = fabSize + fabPadding + fabShadowRadius
        static let searchBarUnpinOffset: CGFloat = 44
    }

    @StateObject private var viewModel: MainViewModel
    @StateObject private var router: MainViewRouter
    @State private var isSearchPinned = false

    init(viewModel: MainViewModel, router: MainViewRouter) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GeometryReader { proxy in
                scrollContent(proxy: proxy)
                    .overlay(alignment: .top) {
                        if isSearchPinned {
                            searchBar.shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                        }
                    }
            }
            fab
        }
        .sheet(isPresented: $router.isStatisticsPresented) {
            StatisticsSheetView(statistic: viewModel.currentPageStatistic)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private func scrollContent(proxy: GeometryProxy) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                CarouselView(pages: viewModel.pages, selectedPageIndex: $viewModel.selectedPageIndex)
                    .padding(.top, 12)

                searchBar
                    .opacity(isSearchPinned ? 0 : 1)
                    .allowsHitTesting(!isSearchPinned)
                    .background(stickyDetector)

                itemsSection
            }
        }
        .coordinateSpace(name: "scroll")
        .padding(.top, 1)
        .simultaneousGesture(TapGesture().onEnded { hideKeyboard() })
    }

    private var searchBar: some View {
        SearchBarView(text: $viewModel.searchText)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
    }

    private var itemsSection: some View {
        Group {
            if viewModel.filteredItems.isEmpty {
                Text("No results found")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(24)
            } else {
                LazyVStack(spacing: 6) {
                    ForEach(viewModel.filteredItems) { item in
                        ItemRowView(item: item).padding(.horizontal, 16)
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, Layout.bottomReserve)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.background)
    }

    private var fab: some View {
        Button {
            viewModel.showStatisticSheet()
        } label: {
            Image(systemName: "ellipsis")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: Layout.fabSize, height: Layout.fabSize)
                .background(Circle().fill(Color.accentColor))
                .shadow(color: .black.opacity(0.2), radius: Layout.fabShadowRadius, x: 0, y: 8)
                .rotationEffect(.degrees(90))
        }
        .padding([.trailing, .bottom], Layout.fabPadding)
    }

    private var stickyDetector: some View {
        GeometryReader { inner in
            Color.clear.onChange(of: inner.frame(in: .named("scroll")).minY) { minY in
                if isSearchPinned {
                    if minY > Layout.searchBarUnpinOffset {
                        isSearchPinned = false
                    }
                } else {
                    if minY <= 0 {
                        isSearchPinned = true
                    }
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    MainViewBuilder.build()
}
