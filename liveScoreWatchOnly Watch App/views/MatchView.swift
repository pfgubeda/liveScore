//
//  matchView.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 3/6/24.
//

import SwiftUI

struct MatchView: View {
    @State private var match = TennisMatch()

    var body: some View {
        ScoreView(match: $match)
    }
}

struct ScoreView: View {
    @Binding var match: TennisMatch
    
    var body: some View {
        VStack {
            HStack {
                Text("Player 1")
                    .font(.headline)
                    .foregroundColor(match.server == .player1 ? .green : .primary)
                
                Divider()
                
                Text("\(match.player1Sets)")
                    .font(.subheadline)
                Divider()
                
                Text("\(match.player1Games)")
                    .font(.subheadline)
                Divider()
                
                Text(currentScore(match.player1Points))
                    .font(.subheadline)
            }
            .padding()
            
            Divider()
            
            HStack {
                Text("Player 2")
                    .font(.headline)
                    .foregroundColor(match.server == .player2 ? .green : .primary)
                
                Divider()
                
                Text("\(match.player2Sets)")
                    .font(.subheadline)
                Divider()
                
                Text("\(match.player2Games)")
                    .font(.subheadline)
                Divider()
                
                Text(currentScore(match.player2Points))
                    .font(.subheadline)
            }
            .padding()
            
            Divider()
            
            HStack {
                Button(action: {
                    match.pointWon(by: .player1)
                }) {
                    Text("Player 1 Scores")
                        .padding()
                }
                
                Button(action: {
                    match.pointWon(by: .player2)
                }) {
                    Text("Player 2 Scores")
                        .padding()
                }
            }
            
            if match.player1Sets == match.setsToWinMatch || match.player2Sets == match.setsToWinMatch {
                Text("Match Over")
                    .font(.title)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
    
    private func currentScore(_ points: Int) -> String {
        switch points {
        case 0: return "Love"
        case 1: return "15"
        case 2: return "30"
        case 3: return "40"
        default: return "ADV"
        }
    }
}

#Preview {
    MatchView()
}
