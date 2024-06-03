//
//  Match.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 3/6/24.
//

import Foundation

struct SetHistoryEntry: Codable {
    var player1Games: Int
    var player2Games: Int
}
//MARK: Score
struct Score: Codable {
    var points: Int = 0
    var games: Int = 0
    var sets: Int = 0
    var gameHistory: [Int] = []
    var setHistory: [SetHistoryEntry] = [SetHistoryEntry(player1Games: 0, player2Games: 0),
                                         SetHistoryEntry(player1Games: 0, player2Games: 0),
                                         SetHistoryEntry(player1Games: 0, player2Games: 0)]
    var historyStack: [(Int, Int, Int, Bool, Int)] = [] // Stack to store previous states (points, games, sets, inTiebreak, tiebreakPoints)
    var advantage: Bool = false // Tracks if the player has the advantage
    var inTiebreak: Bool = false // Tracks if the player is in a tiebreak
    var tiebreakPoints: Int = 0 // Points in tiebreak
    var currentSet = 0
    
    // Custom encoding and decoding to handle the tuple array in historyStack
    enum CodingKeys: String, CodingKey {
        case points
        case games
        case sets
        case gameHistory
        case setHistory
        case historyStack
        case advantage
        case inTiebreak
        case tiebreakPoints
    }
    
    init() { }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        points = try container.decode(Int.self, forKey: .points)
        games = try container.decode(Int.self, forKey: .games)
        sets = try container.decode(Int.self, forKey: .sets)
        gameHistory = try container.decode([Int].self, forKey: .gameHistory)
        setHistory = try container.decode([SetHistoryEntry].self, forKey: .setHistory)
        historyStack = try container.decode([HistoryItem].self, forKey: .historyStack).map { ($0.points, $0.games, $0.sets, $0.inTiebreak, $0.tiebreakPoints) }
        advantage = try container.decode(Bool.self, forKey: .advantage)
        inTiebreak = try container.decode(Bool.self, forKey: .inTiebreak)
        tiebreakPoints = try container.decode(Int.self, forKey: .tiebreakPoints)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)
        try container.encode(games, forKey: .games)
        try container.encode(sets, forKey: .sets)
        try container.encode(gameHistory, forKey: .gameHistory)
        try container.encode(setHistory, forKey: .setHistory)
        try container.encode(historyStack.map { HistoryItem(points: $0.0, games: $0.1, sets: $0.2, inTiebreak: $0.3, tiebreakPoints: $0.4) }, forKey: .historyStack)
        try container.encode(advantage, forKey: .advantage)
        try container.encode(inTiebreak, forKey: .inTiebreak)
        try container.encode(tiebreakPoints, forKey: .tiebreakPoints)
    }
    
    private struct HistoryItem: Codable {
        var points: Int
        var games: Int
        var sets: Int
        var inTiebreak: Bool
        var tiebreakPoints: Int
    }
    
    mutating func addPoint(opponentScore: inout Score) -> Bool {
        saveState()
        
        if inTiebreak {
            tiebreakPoints += 1
            if tiebreakPoints >= 7 && (tiebreakPoints - opponentScore.tiebreakPoints) >= 2 {
                winGame()
                inTiebreak = false
                opponentScore.inTiebreak = false
                return true
            }
        } else {
            if points == 40 {
                if opponentScore.points < 40 {
                    winGame()
                    points = 0
                    opponentScore.points = 0
                    return true
                } else if advantage {
                    winGame()
                    points = 0
                    opponentScore.points = 0
                    return true
                } else if opponentScore.advantage==true{
                    advantage = false
                    opponentScore.advantage = false
                }else{
                    advantage = true
                }
            } else if points == 30 {
                points = 40
            } else {
                points += 15
            }
        }
        return false
    }
    
    mutating func winGame() {
        games += 1
        points = 0
        tiebreakPoints = 0
        advantage = false
        print("Game won")
    }
    
    mutating func addSet() {
        if(setHistory[0].player1Games==0 && setHistory[0].player2Games==0){
            setHistory[0] = SetHistoryEntry(player1Games: games, player2Games: games)
            currentSet = 1
        }else if(setHistory[1].player1Games==0 && setHistory[1].player2Games==0){
            setHistory[1] = SetHistoryEntry(player1Games: games, player2Games: games)
            currentSet = 2
        }else if(setHistory[2].player1Games==0 && setHistory[2].player2Games==0){
            setHistory[2] = SetHistoryEntry(player1Games: games, player2Games: games)
        }
        sets += 1
        games = 0
    }
    
    mutating func reset() {
        points = 0
        games = 0
        sets = 0
        gameHistory.removeAll()
        setHistory.removeAll()
        historyStack.removeAll()
        advantage = false
        inTiebreak = false
        tiebreakPoints = 0
    }
    
    mutating func rollback() {
        guard let lastState = historyStack.popLast() else { return }
        points = lastState.0
        games = lastState.1
        sets = lastState.2
        advantage = false
        inTiebreak = lastState.3
        tiebreakPoints = lastState.4
    }
    
    private mutating func saveState() {
        historyStack.append((points, games, sets, inTiebreak, tiebreakPoints))
    }
}

//MARK: Player and Match

struct Player :Codable{
    var name: String
    var score: Score
}

struct Match: Codable {
    var player1: Player
    var player2: Player
    var lastScored: Int = 0
    var currentSet: Int = 0

    mutating func resetMatch() {
        player1.score.reset()
        player2.score.reset()
    }
    
    mutating func player1Scores() {
        var copy = self
        if player1.score.addPoint(opponentScore: &player2.score) {
            checkGameWin(for: &copy.player1, opponent: &copy.player2)
        }
        self = copy
        lastScored=1
    }
    
    mutating func player2Scores() {
        var copy = self
        if player2.score.addPoint(opponentScore: &player1.score) {
            checkGameWin(for: &copy.player2, opponent: &copy.player1)
        }
        self = copy
        lastScored=2
    }
    
    mutating func rollbackLastAction() {
        if(lastScored==1){
            player1.score.rollback()
        }else if(lastScored==2){
            player2.score.rollback()
        }
    }
    
    private mutating func checkGameWin(for player: inout Player, opponent: inout Player) {
        if player.score.games >= 6 && (player.score.games - opponent.score.games) >= 2 {
            player.score.addSet()
            opponent.score.addSet()
            currentSet += currentSet
            player.score.games = 0
            opponent.score.games = 0
        } else if player.score.games == 6 && opponent.score.games == 6 {
            player.score.inTiebreak = true
            opponent.score.inTiebreak = true
        }
    }
    
    func checkMatchWinner(player: Player)->Bool {
        return player.score.sets>=2
    }
}
