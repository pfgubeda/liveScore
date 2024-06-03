//
//  ContentView.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var match: TennisMatch?
    @State private var isMatchCreated: Bool = false
    
    var body: some View {
        if(isMatchCreated==false){
            VStack {
                Label(
                    title: { Text("Live Score") },
                    icon: { Image(systemName: "tennisball") }
                ).font(.title2)
                
                Button(action: {
                    match = TennisMatch()
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
            MatchView()
        }
    }
}


#Preview {
    ContentView()
}
