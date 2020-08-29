//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Ivan De Martino on 8/29/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import UIKit

final class PlayingCardView: UIView {

  var rank: Int = 5 { didSet { setNeedsDisplay(); setNeedsLayout() }}
  var suit: String = "♥️" { didSet { setNeedsDisplay(); setNeedsLayout() }}
  var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() }}

  private func centeredAttributedText(_ string: String, fontSize: CGFloat) -> NSAttributedString {
    var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
    font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    return NSAttributedString(string: string, attributes: [
      NSAttributedString.Key.font: font,
      NSAttributedString.Key.paragraphStyle: paragraphStyle
    ])
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    configureCornerLabel(upperLeftCornerLabel)
    upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)

    configureCornerLabel(lowerRightCornerLabel)
    lowerRightCornerLabel.transform = CGAffineTransform.identity
      .translatedBy(x: lowerRightCornerLabel.frame.width, y: lowerRightCornerLabel.frame.height)
      .rotated(by: CGFloat.pi)
    lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
      .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
      .offsetBy(dx: -lowerRightCornerLabel.frame.width, dy: -lowerRightCornerLabel.frame.height)
  }

  override func draw(_ rect: CGRect) {
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
    path.addClip()
    UIColor.white.setFill()
    path.fill()
  }

  // MARK: - Corner Labels -

  private lazy var upperLeftCornerLabel = createCornerLabel()
  private lazy var lowerRightCornerLabel = createCornerLabel()

  private func createCornerLabel() -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0
    addSubview(label)
    return label
  }

  private func configureCornerLabel(_ label: UILabel) {
    label.attributedText = centeredAttributedText("\(rankString)\n\(suit)", fontSize: cornerFontSize)
    label.frame.size = .zero
    label.sizeToFit()
    label.isHidden = !isFaceUp
  }

  // MARK: - Trait Collection Did Change -

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    setNeedsDisplay()
    setNeedsLayout()
  }
}

// MARK: - Constants -

extension PlayingCardView {

  private struct SizeRatio {
    static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
    static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    static let cornerOffsetToCornerRadius: CGFloat = 0.33
    static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
  }

  private var cornerRadius: CGFloat {
    bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
  }

  private var cornerOffset: CGFloat {
    cornerRadius * SizeRatio.cornerOffsetToCornerRadius
  }

  private var cornerFontSize: CGFloat {
    bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
  }

  private var rankString: String {
    switch rank {
    case 1:
      return "A"
    case 2...10:
      return String(rank)
    case 11:
      return "J"
    case 12:
      return "Q"
    case 13:
      return "K"
    default:
      return "?"
    }
  }
}

extension CGRect {
  var leftHalf: CGRect {
    CGRect(x: minX, y: minY, width: width/2, height: height)
  }

  var rightHalf: CGRect {
    CGRect(x: midX, y: minY, width: width/2, height: height)
  }

  func inset(by size: CGSize) -> CGRect {
    insetBy(dx: size.width, dy: size.height)
  }

  func sized(to size: CGSize) -> CGRect {
    CGRect(origin: origin, size: size)
  }

  func zoom(by scale: CGFloat) -> CGRect {
    let newWidth = width * scale
    let newHeight = height * scale
    return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
  }
}

extension CGPoint {
  func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
    CGPoint(x: x + dx, y: y + dy)
  }
}
