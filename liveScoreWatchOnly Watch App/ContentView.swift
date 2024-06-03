//
//  ContentView.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var match: Match?
    @State private var isMatchCreated: Bool = false
    
    var body: some View {
        if(isMatchCreated==false){
            VStack {
                Label(
                    title: { Text("Live Score") },
                    icon: { Image(systemName: "tennisball") }
                ).font(.title2)
                
                Button(action: {
                    match = Match(
                        player1: Player(name: "Player 1", score: Score()),
                        player2: Player(name: "Player 2", score: Score()), lastScored:0
                    )
                    isMatchCreated = true
                }) {
                    Text("New Match")
                        .padding()
                }
                .padding()
                
                Button(action: {
                    //implement load match
                }) {
                    Text("Continue Match")
                        .padding()
                }
                .colorMultiply(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .padding()
            }
        }else if(isMatchCreated==true){
            MatchView(match: match!)
        }
    }
}


#Preview {
    ContentView()
}
