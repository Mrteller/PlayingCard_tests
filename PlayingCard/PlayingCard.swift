//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Paul on 08.03.2018.
//  Copyright © 2018 Laconic. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    var description: String {
        return "\(rank)\(suit)"
    }
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        var description: String { return rawValue }
        
        case spades = "♤"
        case hearts = "♡"
        case diamonds = "♢"
        case clubs = "♧"
        
        static var all = [Suit.spades, .hearts, .diamonds, .clubs]
    }
    
    enum Rank: CustomStringConvertible {
        
        case ace
        case face(String) // TODO: make it enum of enum
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
                //// Works just as well, but does not demonstrates "where" clause
                //            case .face(let kind): switch kind {
                //                case "J": return 11
                //                case "Q": return 12
                //                case "K": return 13
                //                default: return 0
                //                }
            default: return 0
            }
        }
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
        
        var description: String {
            switch self {
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
    }
    
//    static func createDeck() -> [PlayingCard] {
//        var n = 1
//        var deck = [PlayingCard]()
//        while let rank = Rank(rawValue: n) {
//            var m = 1
//            while let suit = Suit(rawValue: m) {
//                deck.append(Card(rank: rank, suit: suit))
//                m += 1
//            }
//            n += 1
//        }
//        return deck
//    }
    
}
