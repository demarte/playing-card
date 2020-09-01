//
//  CardGameViewController.swift
//  PlayingCard
//
//  Created by Ivan De Martino on 9/1/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import UIKit

final class CardGameViewController: UIViewController {

  // MARK: - Animator -
  private lazy var animator = UIDynamicAnimator(referenceView: view)
  private lazy var cardBehavior = CardBehavior(in: animator)
  // MARK: - Properties -
  @IBOutlet var cardViews: [PlayingCardView]!

  private var deck = PlayingCardDeck()

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    var cards: [PlayingCard] = []
    for _ in 1...((cardViews.count + 1) / 2) {
      if let card = deck.draw() {
        cards += [card, card]
      }
    }

    for cardView in cardViews {
      cardView.isFaceUp = false
      let card = cards.remove(at: Int.random(in: 0...cards.count - 1))
      cardView.rank = card.rank.order
      cardView.suit = card.suit.rawValue
      cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard)))
      cardBehavior.addItem(cardView)
    }
  }

  private var faceUpCardViews: [PlayingCardView] {
    cardViews.filter { $0.isFaceUp && !matchedCardViews.contains($0) }
  }

  private var faceUpCardViewsMatch: Bool {
    faceUpCardViews.count == 2 && faceUpCardViews[0] == faceUpCardViews[1]
  }

  private var lastChoosenCardView: PlayingCardView?

  private var matchedCardViews = Set<PlayingCardView>()

  @objc private func flipCard(_ sender: UITapGestureRecognizer) {
    switch sender.state {
    case .ended:
      if let chosenCardView = sender.view as? PlayingCardView, faceUpCardViews.count < 2 {
        lastChoosenCardView = chosenCardView
        cardBehavior.removeItem(chosenCardView)
        chosenCardView.flipCardAnimation { [unowned self] in
          if self.faceUpCardViewsMatch {
            self.faceUpCardViews.forEach {
              self.matchedCardViews.insert($0)
              $0.matchAnimation()
            }
          } else if self.faceUpCardViews.count == 2 && chosenCardView == self.lastChoosenCardView {
            self.faceUpCardViews.forEach {
              $0.flipCardAnimation { [unowned self] in
                self.cardBehavior.addItem(chosenCardView)
              }
            }
          } else if !chosenCardView.isFaceUp {
            self.cardBehavior.addItem(chosenCardView)
          }
        }
      }
    default:
      break
    }
  }
}
