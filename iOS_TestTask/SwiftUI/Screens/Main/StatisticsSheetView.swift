//
//  StatisticsSheetView.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import SwiftUI

struct StatisticsSheetView: View {
    let statistic: PageStatistic

    var body: some View {
        NavigationStack {
            ScrollView {
                StatisticsCardView(statistic: statistic)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    StatisticsSheetView(statistic: PageStatisticsBuilder.make(from: [MockPages.data[0]])[0])
}
