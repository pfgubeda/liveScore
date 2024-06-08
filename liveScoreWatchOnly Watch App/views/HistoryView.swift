//
//  HistoryView.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 9/6/24.
//

import SwiftUI
import SwiftData

struct HisoryView: View{
    
    @EnvironmentObject var root : ReturnRoot
    @Environment(\.modelContext) var context
    @Query (sort: \TennisMatch.timestamp, order: .reverse) private var matches: [TennisMatch]
    
    var body: some View {
        List(matches) { match in
            NavigationLink("\(match.player1.name) - \(match.player1Sets)\n\(match.player2.name) - \(match.player2Sets)", value: match)
                .navigationDestination(for: TennisMatch.self){ match in
                    MatchView(match: match)
                }
                .navigationTitle("Match history")
        }
    }
}
