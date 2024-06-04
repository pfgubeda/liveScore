//
//  matchView.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 3/6/24.
//

import SwiftUI

struct MatchView: View {
    @State private var match: TennisMatch

       init(player1Name: String, player2Name: String, server: Player) {
           _match = State(initialValue: TennisMatch(player1: PlayerDetails(name: player1Name),
                                                    player2: PlayerDetails(name: player2Name),
                                                    server: server, winner: PlayerDetails(name: "null")))
       }

       var body: some View {
           ScoreView(match: $match)
       }
}

struct ScoreView: View {
    @Binding var match: TennisMatch
    @State private var showMatchOver = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "tennisball").opacity(match.server == .player1 ? 1:0)
                Text("\(match.player1.name)")
                    .font(.headline)
                    .foregroundColor(match.server == .player1 ? .green : .primary)
                
                Divider()
                
                Text("\(match.player1Sets)")
                    .font(.subheadline)
                Divider()
                
                Text("\(match.player1Games)")
                    .font(.subheadline)
                Divider()
                
                if(match.isTieBreak){
                    Text("\(match.player1TieBreakPoints)").padding()
                }else{
                    Text(currentScore(match.player1Points))
                        .font(.subheadline)
                }
            }
            .padding()
            
            Divider()
            
            HStack {
                Image(systemName: "tennisball").opacity(match.server == .player2 ? 1:0)
                Text("\(match.player2.name)")
                    .font(.headline)
                    .foregroundColor(match.server == .player2 ? .green : .primary)
                
                Divider()
                
                Text("\(match.player2Sets)")
                    .font(.subheadline)
                Divider()
                
                Text("\(match.player2Games)")
                    .font(.subheadline)
                Divider()
                if(match.isTieBreak){
                    Text("\(match.player2TieBreakPoints)").padding()
                }else{
                    Text(currentScore(match.player2Points))
                        .font(.subheadline)
                }
            }
            .padding()
            
            Divider()
            if(showMatchOver==false){
                HStack {
                    
                    Button(action: {
                        match.pointWon(by: .player1)
                        checkMatchOver()
                    }) {
                        if(match.isTieBreak){
                            Text("\(match.player1TieBreakPoints)").padding()
                        }else{
                            Text(currentScore(match.player1Points))
                        }
                    }
                    
                    Button(action: {
                        match.pointWon(by: .player2)
                        checkMatchOver()
                    }) {
                        if(match.isTieBreak){
                            Text("\(match.player2TieBreakPoints)").padding()
                        }else{
                            Text(currentScore(match.player2Points))
                                .font(.subheadline)
                        }
                    }
                }
            }
            
            if showMatchOver {
                Text("\(match.winner.name)")
                                .font(.title)
                                .foregroundColor(.red)
                                .padding()
                                .transition(.scale)
                                .animation(.easeInOut(duration: 1), value: showMatchOver)
                        }
        }
        
    }
    
    private func checkMatchOver() {
            if match.player1Sets == match.setsToWinMatch || match.player2Sets == match.setsToWinMatch {
                withAnimation {
                    showMatchOver = true
                }
            }
        }
    
    private func currentScore(_ points: Int) -> String {
        switch points {
        case 0: return "0"
        case 1: return "15"
        case 2: return "30"
        case 3: return "40"
        default: return "ADV"
        }
    }
}

struct PlayerFront {
    let name: String
    let order: Player
}

#Preview {
    MatchView(player1Name: "Pepe", player2Name: "Pablo", server: Player.player2)
}
