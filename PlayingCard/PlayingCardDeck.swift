//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by Ivan De Martino on 8/29/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import Foundation

struct PlayingCardDeck {

  var cards: [PlayingCard] = []

  init() {
    for suit in PlayingCard.Suit.all {
      for rank in PlayingCard.Rank.all {
        cards.append(PlayingCard(suit: suit, rank: rank))
      }
    }
  }

  mutating func draw() -> PlayingCard? {
    if cards.count > 0 {
      let randomIndex = Int.random(in: 0..<cards.count)
      return cards.remove(at: randomIndex)
    }
    return nil
  }

}
