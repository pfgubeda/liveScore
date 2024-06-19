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
    case History
}

class ReturnRoot: ObservableObject {
    @Published var path = NavigationPath()
    
    func root(){
        path.removeLast(path.count)
    }
}

struct ContentView: View {
    @EnvironmentObject var root : ReturnRoot
    @Environment(\.modelContext) var context
    
    @State private var isMatchCreated: Bool = false
    @Query (filter: #Predicate { $0.isMatchFinished == false },sort: \TennisMatch.timestamp, order: .reverse) private var match: [TennisMatch]
    
    var body: some View {
        NavigationStack(path: $root.path) {
 
                VStack {
                    Label(
                        title: { Text("Live Score") },
                        icon: { Image(systemName: "tennisball") }
                    ).font(.title2)
                    
                    ScrollView{
                    
                    if(!match.isEmpty){
                        NavigationLink("Continue Match") {
                            MatchView(match: match[0],commingFromConfig: false)
                        }.colorMultiply(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                    }
                    
                    NavigationLink("New Match", value: Routes.ConfigMatch)
                        .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                    
                    NavigationLink("History", value: Routes.History)
                        .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                        .navigationDestination(for: Routes.self){ route in
                            switch route {
                            case .ConfigMatch:
                                MatchConfigView().onAppear(perform: {
                                    if(!match.isEmpty){
                                        match[0].finishMatch()
                                        context.insert(match[0])
                                        try? context.save()
                                    }
                                })
                            case .History:
                                HisoryView()
                            }
                        }
                }
            }
        }
    }
}


#Preview {
    ContentView().environmentObject(ReturnRoot())
}
