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
            /*NavigationLink("\(match.player1.name) - \(match.player1Sets)\n\(match.player2.name) - \(match.player2Sets)", value: match)
                .navigationDestination(for: TennisMatch.self){ match in
                    MatchView(match: match)
                }*/
            NavigationLink {
                MatchView(match: match,commingFromConfig: false)
            } label:{
                HStack{
                    VStack{
                        HStack{
                            Text("\(match.player1.name)")
                                .colorMultiply(match.winner.name==match.player1.name ? .green : .primary)
                                .frame(width: 50, height: 20, alignment: .trailing)
                                .fixedSize(horizontal: true, vertical: true)
                            Divider()
                            HStack{
                                Text("\(match.player1Sets)").frame(width: 10, alignment: .center)
                                if(!match.isMatchFinished){
                                    Divider()
                                    Text("\(match.player1Games)").frame(width: 10, alignment: .center)
                                    Divider()
                                    if(currentScore(match.player1Points)=="ADV"){
                                        Text(currentScore(match.player1Points)).frame(width: 30, alignment: .center).font(.system(size: 10))
                                    }else{
                                        Text(currentScore(match.player1Points)).frame(width: 30, alignment: .center)
                                    }
                                    Image(systemName: "tennisball")
                                        .opacity(match.server == .player1 ? 1:0)
                                        .font(.system(size: 10))
                                }
                            }.frame(alignment: .leading).fixedSize(horizontal: true, vertical: true)
                        }
                        HStack{
                            Text("\(match.player2.name)")
                                .colorMultiply(match.winner.name==match.player2.name ? .green : .primary)
                                .frame(width: 50, height: 20, alignment: .trailing)
                                .fixedSize(horizontal: true, vertical: true)
                            Divider()
                            HStack{
                                Text("\(match.player2Sets)").frame(width: 10, alignment: .center)
                                if(!match.isMatchFinished){
                                    Divider()
                                    Text("\(match.player2Games)").frame(width: 10, alignment: .center)
                                    Divider()
                                    if(match.isTieBreak){
                                        Text("\(match.player2TieBreakPoints)").frame(width: 30, alignment: .center)
                                    }else{
                                        if(currentScore(match.player2Points)=="ADV"){
                                            Text(currentScore(match.player2Points)).frame(width: 30, alignment: .center).font(.system(size: 10))
                                        }else{
                                            Text(currentScore(match.player2Points)).frame(width: 30, alignment: .center)
                                        }
                                    }
                                    Image(systemName: "tennisball")
                                        .opacity(match.server == .player2 ? 1:0)
                                        .font(.system(size: 10))
                                }
                            }.frame(alignment: .leading).fixedSize(horizontal: true, vertical: true)
                        }
                    }
                    Spacer()
                    VStack{
                        if(match.isMatchFinished){
                            Label("", systemImage: "info.circle").colorMultiply(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        }else{
                            Label("",systemImage: "chevron.right.circle").colorMultiply(.green)
                        }
                    }.padding(.trailing, 8)
                }
            }
            .navigationTitle("Match history")
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

