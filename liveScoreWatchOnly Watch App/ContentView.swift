//
//  ContentView.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 3/6/24.
//

import SwiftUI
import SwiftData
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
    @State private var isMatchCreated: Bool = false
    @Query (filter: #Predicate { $0.isMatchFinished == false },sort: \TennisMatch.timestamp, order: .reverse) private var match: [TennisMatch]
    
    
    
    var body: some View {
        NavigationStack(path: $root.path) {
            VStack {
                Label(
                    title: { Text("Live Score") },
                    icon: { Image(systemName: "tennisball") }
                ).font(.title2)
                
                
                
                if(!match.isEmpty){
                    NavigationLink("Continue Match", value: Routes.ContinueMatch)
                        .colorMultiply(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .padding()
                }
                
                NavigationLink("New Match", value: Routes.ConfigMatch)
                .padding()
                .navigationDestination(for: Routes.self){ route in
                    switch route {
                    case .ContinueMatch:
                        MatchView(match: match[0])
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
