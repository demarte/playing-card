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

  override func viewDidLoad() {
    super.viewDidLoad()

    for _ in 1...10 {
      if let card = deck.draw() {
        print(card)
      }
    }
  }
}

