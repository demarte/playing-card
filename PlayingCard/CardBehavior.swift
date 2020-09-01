//
//  CardBehaivor.swift
//  PlayingCard
//
//  Created by Ivan De Martino on 9/1/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import UIKit

final class CardBehavior: UIDynamicBehavior {

  lazy var collisionBehavior: UICollisionBehavior = {
    let behavior = UICollisionBehavior()
    behavior.translatesReferenceBoundsIntoBoundary = true
    return behavior
  }()

  lazy var itemBehavior: UIDynamicItemBehavior = {
    let behavior = UIDynamicItemBehavior()
    behavior.allowsRotation = false
    behavior.elasticity = 1.0
    behavior.resistance = 0.0
    return behavior
  }()

  private func push(_ item: UIDynamicItem) {
    let push = UIPushBehavior(items: [item], mode: .instantaneous)
    if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
      let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
      push.angle = CGFloat.random(in: 0...(CGFloat.pi / 2))

      switch (item.center.x, item.center.y) {
      case let (x, y) where x < center.x && y > center.y:
        push.angle = -1 * push.angle
      case let (x, y) where x > center.x:
        push.angle = y < center.y ? CGFloat.pi - push.angle : CGFloat.pi + push.angle
      default:
        push.angle = CGFloat.random(in: 0...(CGFloat.pi * 2))
      }
      push.magnitude = CGFloat(0.5) + CGFloat.random(in: 0...1)
      push.action = { [unowned self] in
        self.removeChildBehavior(push)
      }
      addChildBehavior(push)
    }
  }

  func addItem(_ item: UIDynamicItem) {
    collisionBehavior.addItem(item)
    itemBehavior.addItem(item)
    push(item)
  }

  func removeItem(_ item: UIDynamicItem) {
    collisionBehavior.removeItem(item)
    itemBehavior.removeItem(item)
  }

  override init() {
    super.init()
    addChildBehavior(collisionBehavior)
    addChildBehavior(itemBehavior)
  }

  convenience init(in animator: UIDynamicAnimator) {
    self.init()
    animator.addBehavior(self)
  }
}
