//
//  Match.swift
//  liveScoreWatchOnly Watch App
//
//  Created by Pablo Fernandez Gonzalez on 3/6/24.
//

import Foundation

enum Player: String, Identifiable {
    case player1
    case player2
    
    var id: String { rawValue }
}

struct PlayerDetails {
    let name: String
    var points: Int = 0
    var games: Int = 0
    var sets: Int = 0
}

enum Score {
    case love
    case fifteen
    case thirty
    case forty
    case advantage(Player)
    case game
}

struct TennisMatch {
    private(set) var player1Points: Int = 0
    private(set) var player2Points: Int = 0
    private(set) var player1Games: Int = 0
    private(set) var player2Games: Int = 0
    private(set) var player1Sets: Int = 0
    private(set) var player2Sets: Int = 0
    private(set) var isTieBreak: Bool = false
    private(set) var player1TieBreakPoints: Int = 0
    private(set) var player2TieBreakPoints: Int = 0
    var player1: PlayerDetails
    var player2: PlayerDetails
    var server: Player
    var winner: PlayerDetails
    
    let gamesToWinSet = 6
    let pointsToWinTieBreak = 7
    let setsToWinMatch = 2
    
    mutating func pointWon(by player: Player) {
        if isTieBreak {
            handleTieBreakPoint(wonBy: player)
        } else {
            handleRegularPoint(wonBy: player)
        }
    }
    
    private mutating func handleRegularPoint(wonBy player: Player) {
        switch (player1Points, player2Points) {
        case (3, 3): // Deuce
            if player == .player1 {
                player1Points = 4
            } else {
                player2Points = 4
            }
        case (4, 3): // Advantage player1
            if player == .player1 {
                winGame(by: .player1)
            } else {
                player1Points = 3 // back to deuce
            }
        case (3, 4): // Advantage player2
            if player == .player2 {
                winGame(by: .player2)
            } else {
                player2Points = 3 // back to deuce
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
    
    private mutating func handleTieBreakPoint(wonBy player: Player) {
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
    
    private mutating func winGame(by player: Player) {
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
    
    private mutating func winSet(by player: Player) {
        if player == .player1 {
            player1Sets += 1
        } else {
            player2Sets += 1
        }
        
        player1Games = 0
        player2Games = 0
        player1TieBreakPoints = 0
        player2TieBreakPoints = 0
        
        if player1Sets == setsToWinMatch {
            winner = player1
        }
        if player2Sets == setsToWinMatch {
            winner = player2
        }
    }
    
    private mutating func switchServer() {
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
