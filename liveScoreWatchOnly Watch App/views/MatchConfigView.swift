//
//  MatchConfigView.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 4/6/24.
//

import SwiftUI

struct MatchConfigView: View {
    @State private var player1Name: String = ""
    @State private var player2Name: String = ""
    @State private var server: Player = .player1
    @State private var navigateToMatchView = false

    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    if(player1Name.isEmpty || player2Name.isEmpty){
                        TextField("Player 1 Name", text: $player1Name)
                            .padding()
                        
                        TextField("Player 2 Name", text: $player2Name)
                            .padding()
                    }else if(!player1Name.isEmpty && !player2Name.isEmpty){
                        HStack {
                            VStack{
                                Button("\(player1Name)", action: {
                                    server = .player1
                                })
                                Image(systemName: "tennisball").opacity(server == .player1 ? 1:0)
                            }
                            VStack{
                                Button("\(player2Name)", action: {
                                    server = .player2
                                })
                                Image(systemName: "tennisball").opacity(server == .player2 ? 1:0)
                            }
                        }
                        NavigationLink("Start Match"){
                            MatchView(player1Name: player1Name, player2Name: player2Name, server: server)
                        }.colorMultiply(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                }
                .navigationTitle("Setup Match")
            }
        }
    }
}
