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
        NavigationStack {
            VStack {
                Label(
                    title: { Text("Live Score") },
                    icon: { Image(systemName: "tennisball") }
                ).font(.title2)
                
                NavigationLink("New Match"){
                    MatchConfigView()
                }
                .padding()
                
                
                NavigationLink("Continue Match"){
                    MatchConfigView()
                }
                .colorMultiply(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .padding()
            }
        }
    }
}


#Preview {
    ContentView()
}
