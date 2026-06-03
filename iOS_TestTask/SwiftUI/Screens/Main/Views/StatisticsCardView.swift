//
//  StatisticsCardView.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import SwiftUI

struct StatisticsCardView: View {
    let statistic: PageStatistic

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(statistic.pageTitle)
                    .font(.headline)

                Text("\(statistic.itemCount) items")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if statistic.topCharacters.isEmpty {
                Text("No characters available")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(statistic.topCharacters, id: \.character) { characterStatistic in
                        HStack {
                            Text(characterStatistic.character)
                                .font(.body.monospaced())
                                .fontWeight(.semibold)
                            Text("=")
                                .foregroundStyle(.secondary)
                            Text("\(characterStatistic.count)")
                                .font(.body.monospaced())
                            Spacer()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    StatisticsCardView(statistic: PageStatisticsBuilder.make(from: [MockPages.data[0]])[0])
        .padding()
}
