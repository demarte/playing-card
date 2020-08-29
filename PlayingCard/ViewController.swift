//
//  ViewController.swift
//  PlayingCard
//
//  Created by Ivan De Martino on 8/29/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var deck = PlayingCardDeck()

  @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
    switch sender.state {
    case .ended:
      playingCardView.isFaceUp.toggle()
    default:
      break
    }
  }
  @IBOutlet weak var playingCardView: PlayingCardView! {
    didSet {
      let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
      swipe.direction = [.left, .right]
      playingCardView.addGestureRecognizer(swipe)

      let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGestureRecognizerBy:)))
      playingCardView.addGestureRecognizer(pinch)
    }
  }

  @objc func nextCard() {
    if let card = deck.draw() {
      playingCardView.rank = card.rank.order
      playingCardView.suit = card.suit.rawValue
    }
  }
}

