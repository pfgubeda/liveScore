//
//  Match.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 3/6/24.
//

import Foundation
import SwiftData

enum Player: String, Identifiable, Codable{
    case player1
    case player2
    
    var id: String { rawValue }
}

struct PlayerDetails: Codable {
    let name: String
    var points: Int = 0
    var games: Int = 0
    var sets: Int = 0
    var server: Int = 0
}

enum Score {
    case love
    case fifteen
    case thirty
    case forty
    case advantage(Player)
    case game
}

@Model
final class TennisMatch {
    private(set) var player1Points: Int
    private(set) var player2Points: Int
    private(set) var player1Games: Int
    private(set) var player2Games: Int
    private(set) var player1Sets: Int
    private(set) var player2Sets: Int
    private(set) var isTieBreak: Bool
    private(set) var player1TieBreakPoints: Int
    private(set) var player2TieBreakPoints: Int
    private(set) var isMatchFinished: Bool
    var player1: PlayerDetails
    var player2: PlayerDetails
    var server: Player
    var winner: PlayerDetails
    var isGamemodeFiveSets: Bool
    
    let gamesToWinSet = 6
    let pointsToWinTieBreak = 7
    var setsToWinMatch =  2
    let timestamp: Date = Date()
    
    init(player1: PlayerDetails, player2: PlayerDetails, server: Player, isGamemodeFiveSets: Bool) {
        self.player1Points = 0
        self.player2Points = 0
        self.player1Games = 0
        self.player2Games = 0
        self.player1Sets = 0
        self.player2Sets = 0
        self.isTieBreak = false
        self.player1TieBreakPoints = 0
        self.player2TieBreakPoints = 0
        self.player1 = player1
        self.player2 = player2
        self.server = server
        self.winner = PlayerDetails(name: "Unfinished")
        self.isGamemodeFiveSets = isGamemodeFiveSets
        self.timestamp = Date()
        self.isMatchFinished = false
    }
    
    func pointWon(by player: Player) {
        if isTieBreak {
            handleTieBreakPoint(wonBy: player)
        } else {
            handleRegularPoint(wonBy: player)
        }
    }
    
    private func handleRegularPoint(wonBy player: Player) {
        switch (player1Points, player2Points) {
        case (3, 3):
            if player == .player1 {
                player1Points = 4
            } else {
                player2Points = 4
            }
        case (4, 3):
            if player == .player1 {
                winGame(by: .player1)
            } else {
                player1Points = 3
            }
        case (3, 4):
            if player == .player2 {
                winGame(by: .player2)
            } else {
                player2Points = 3
            }
        default:
            if player == .player1 {
                player1Points += 1
            } else {
                player2Points += 1
            }
            if player1Points == 4 {
                winGame(by: .player1)
            } else if player2Points == 4 {
                winGame(by: .player2)
            }
        }
    }
    
    private func handleTieBreakPoint(wonBy player: Player) {
        if player == .player1 {
            player1TieBreakPoints += 1
        } else {
            player2TieBreakPoints += 1
        }
        
        if (player1TieBreakPoints >= pointsToWinTieBreak || player2TieBreakPoints >= pointsToWinTieBreak) &&
            abs(player1TieBreakPoints - player2TieBreakPoints) >= 2 {
            if player1TieBreakPoints > player2TieBreakPoints {
                winSet(by: .player1)
            } else {
                winSet(by: .player2)
            }
            isTieBreak = false
        }
    }
    
    private func winGame(by player: Player) {
        if player == .player1 {
            player1Games += 1
        } else {
            player2Games += 1
        }
        
        player1Points = 0
        player2Points = 0
        
        if (player1Games >= gamesToWinSet || player2Games >= gamesToWinSet) && abs(player1Games - player2Games) >= 2 {
            winSet(by: player)
        } else if player1Games == 6 && player2Games == 6 {
            isTieBreak = true
        }
        
        switchServer()
    }
    
    private func winSet(by player: Player) {
        if player == .player1 {
            player1Sets += 1
        } else {
            player2Sets += 1
        }
        
        player1Games = 0
        player2Games = 0
        player1TieBreakPoints = 0
        player2TieBreakPoints = 0
        let setsToWinMatch = isGamemodeFiveSets ? 3 : 2
        
        if player1Sets == setsToWinMatch {
            winner = player1
            finishMatch()
        }
        if player2Sets == setsToWinMatch {
            winner = player2
           finishMatch()
        }
    }
    
    public func finishMatch(){
        isMatchFinished = true
    }
    
    private func switchServer() {
        server = (server == .player1) ? .player2 : .player1
    }
    
    func currentScore() -> (player1: Score, player2: Score) {
        return (convertPointsToScore(player1Points), convertPointsToScore(player2Points))
    }

    private func convertPointsToScore(_ points: Int) -> Score {
        switch points {
        case 0: return .love
        case 1: return .fifteen
        case 2: return .thirty
        case 3: return .forty
        case 4: return .advantage(server == .player1 ? .player1 : .player2)
        default: return .love
        }
    }
}
