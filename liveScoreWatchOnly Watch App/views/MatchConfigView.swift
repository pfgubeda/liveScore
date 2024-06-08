//
//  MatchConfigView.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 4/6/24.
//

import SwiftUI

struct MatchConfigView: View {
    @EnvironmentObject var root : ReturnRoot
    
    @State private var player1Name: String = ""
    @State private var player2Name: String = ""
    @State private var server: Player = .player1
    @State private var isFiveSets = false

    

    var body: some View {
            ScrollView{
                VStack {
                    if(player1Name.isEmpty || player2Name.isEmpty){
                        TextField("Player 1 Name", text: $player1Name)
                            .padding()
                        
                        TextField("Player 2 Name", text: $player2Name)
                            .padding()
                    }else if(!player1Name.isEmpty && !player2Name.isEmpty){
                        
                        HStack {
                            Toggle("Sets", isOn: $isFiveSets)
                                .toggleStyle(SwitchToggleStyle(tint: .blue)) // Customize toggle style
                            Text(isFiveSets ? "5" : "3")
                                .foregroundColor(.blue)
                                .font(.headline)
                        }
                        
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10) 
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
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
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                        NavigationLink("Start Match", value: 1)
                            .navigationDestination(for: Int.self){ _ in
                                MatchView(match: TennisMatch(player1: PlayerDetails(name: player1Name), player2: PlayerDetails(name: player2Name), server: server, isGamemodeFiveSets: isFiveSets))
                        }.colorMultiply(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .padding(.horizontal, 8)
                    }
                }
                .navigationTitle("Setup Match")
            }
    }
}
