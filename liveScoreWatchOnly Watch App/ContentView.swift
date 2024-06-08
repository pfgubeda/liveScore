//
//  ContentView.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 3/6/24.
//

import SwiftUI

enum Routes: Hashable {
    case ConfigMatch
    case ContinueMatch
}

class ReturnRoot: ObservableObject {
    @Published var path = NavigationPath()
    
    func root(){
        path.removeLast(path.count)
    }
}

struct ContentView: View {
    @EnvironmentObject var root : ReturnRoot
    @State private var match: TennisMatch?
    @State private var isMatchCreated: Bool = false
    
    var body: some View {
        NavigationStack(path: $root.path) {
            VStack {
                Label(
                    title: { Text("Live Score") },
                    icon: { Image(systemName: "tennisball") }
                ).font(.title2)
                
                NavigationLink("New Match", value: Routes.ConfigMatch)
                .padding()
    
                NavigationLink("Continue Match", value: Routes.ContinueMatch)
                .colorMultiply(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .padding()
                
                .navigationDestination(for: Routes.self){ route in
                    switch route {
                    case .ContinueMatch:
                        MatchView(player1Name: "Test1", player2Name: "Test2", server: Player.player1, isFiveSets: false)
                    case .ConfigMatch:
                        MatchConfigView()
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView().environmentObject(ReturnRoot())
}
