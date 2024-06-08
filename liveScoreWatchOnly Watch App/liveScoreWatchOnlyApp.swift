//
//  liveScoreWatchOnlyApp.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 3/6/24.
//

import SwiftUI
import SwiftData

@main
struct liveScoreWatchOnly_Watch_AppApp: App {
    
    let modelContainer: ModelContainer
        
        init() {
            do {
                modelContainer = try ModelContainer(for: TennisMatch.self)
            } catch {
                fatalError("Could not initialize ModelContainer")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ReturnRoot())
                .modelContainer(modelContainer)
        }
    }
}
