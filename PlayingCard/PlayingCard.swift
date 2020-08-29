//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Ivan De Martino on 8/29/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {

  var description: String {
    "\(suit) \(rank)"
  }

  var suit: Suit
  var rank: Rank

  enum Suit: String, CustomStringConvertible {

    var description: String {
      "Suit: \(self.rawValue)"
    }

    case dimonds = "♦️"
    case clubs = "♣️"
    case hearts = "♥️"
    case spades = "♠️"

    static var all: [Suit] = [.spades, .hearts, .dimonds, .clubs]
  }

  enum Rank: CustomStringConvertible {
    var description: String {
      switch self {
      case .ace:
        return "Rank: A"
      case .number(let pips):
        return "Rank: \(pips)"
      case .face(let faceType):
        return "Rank: \(faceType.description)"
      }
    }

    case ace
    case number(Int)
    case face(FaceType)

    var order: Int {
      switch self {
      case .ace:
        return 1
      case .number(let pips):
        return pips
      case .face(let faceType):
        switch faceType {
        case .jack:
          return 11
        case .king:
          return 12
        case .queen:
          return 13
        }
      }
    }

    static var all: [Rank] {
      var allRanks: [Rank] = [.ace]
      for pips in 2...10 {
        allRanks.append(.number(pips))
      }
      for faceType in FaceType.allCases {
        allRanks.append(.face(faceType))
      }
      return allRanks
    }

    enum FaceType: String, CaseIterable, CustomStringConvertible {

      var description: String {
        "\(self.rawValue)"
      }

      case jack, queen, king
    }
  }
}
