//
//  matchView.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 3/6/24.
//

import SwiftUI

struct MatchView: View {
    @State var match: Match
    
    var body: some View {
        ScoreView(match: $match)
    }
}

struct ScoreView: View {
    @Binding var match: Match
    
    var body: some View {
        VStack {
            HStack {
                Text(match.player1.name)
                    .font(.headline)
                Divider()
                if(match.player1.score.currentSet==0){
                    Text("\(match.player1.score.games)")
                        .font(.subheadline)
                }else{
                    Text("\(match.player1.score.setHistory[0].player1Games)")
                        .font(.subheadline)
                }
                Divider()
                if(match.player1.score.currentSet==1){
                    Text("\(match.player1.score.games)")
                        .font(.subheadline)
                }else{
                    Text("\(match.player1.score.setHistory[1].player1Games)")
                        .font(.subheadline)
                }
                Divider()
                if(match.player1.score.currentSet==2){
                    Text("\(match.player1.score.games)")
                        .font(.subheadline)
                }else{
                    Text("\(match.player1.score.setHistory[2].player1Games)")
                        .font(.subheadline)
                }
            }.padding()
            Divider()
            HStack {
                Text(match.player2.name)
                    .font(.headline)
                Divider()
                if(match.player2.score.currentSet==0){
                    Text("\(match.player2.score.games)")
                        .font(.subheadline)
                }else{
                    Text("\(match.player2.score.setHistory[0].player2Games)")
                        .font(.subheadline)
                }
                Divider()
                if(match.player2.score.currentSet==1){
                    Text("\(match.player2.score.games)")
                        .font(.subheadline)
                }else{
                    Text("\(match.player2.score.setHistory[1].player2Games)")
                        .font(.subheadline)
                }
                Divider()
                if(match.player2.score.currentSet==2){
                    Text("\(match.player2.score.games)")
                        .font(.subheadline)
                }else{
                    Text("\(match.player2.score.setHistory[2].player2Games)")
                        .font(.subheadline)
                }
            }
            .padding()
        }
        
        VStack{
            HStack{
                Button(action: {
                    var opponentScore = match.player2.score
                    var gameWon = match.player1.score.addPoint(opponentScore: &opponentScore)
                    match.player1Scores()
                    match.player2.score = opponentScore
                    print(match.lastScored)
                }) {
                    if(match.player1.score.advantage==true){
                        Text("ADV")
                            .padding()
                    }else{
                        Text("\(match.player1.score.points)")
                            .padding()
                    }
                }
                .padding()
                
                Button(action: {
                    var opponentScore = match.player1.score
                    var gameWon = match.player2.score.addPoint(opponentScore: &opponentScore)
                    match.player2Scores()
                    match.player1.score = opponentScore
                }) {
                    if(match.player2.score.advantage==true){
                        Text("ADV")
                            .padding()
                    }else{
                        Text("\(match.player2.score.points)")
                            .padding()
                    }
                }
                .padding()
            }
            if(match.lastScored != 0){
                Button(action: {
                    match.rollbackLastAction()
                }, label: {
                    Text("Undo")
                })
            }
        }
    }
}





#Preview {
    MatchView(match: Match(
        player1: Player(name: "Player 1", score: Score()),
        player2: Player(name: "Player 2", score: Score()), lastScored: 0
))
}
