//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Paul on 20.03.2018.
//  Copyright © 2018 Laconic. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    @IBInspectable
    var rank: Int = 12 { didSet {setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var suit: String = "❤️" { didSet {setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var isFaceUp: Bool = true { didSet {setNeedsDisplay(); setNeedsLayout() } }
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize  { didSet {setNeedsDisplay() } }
    
    private lazy var upperLeftCorner = createCornerLabel()
    private lazy var lowerRightCorner = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        // Playing with font metrics
        print("Original fontSize: \(fontSize), scaled fontSize: \(font.fontDescriptor.fontAttributes[UIFontDescriptor.AttributeName.size] ?? "?"), scaledValue for orig fontSize \(UIFontMetrics(forTextStyle: .body).scaledValue(for: fontSize))")
        let paragraphStyle = NSMutableParagraphStyle() //What if use NSParagraphStyle instead?
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize)
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp {
            if let faceCardImage = UIImage(named: rankString+suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            } else {
                drawPips()
            }
        } else {
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerLabel(upperLeftCorner)
        upperLeftCorner.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerRightCorner)
        lowerRightCorner.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCorner.frame.width, y: lowerRightCorner.frame.height)
            .rotated(by: CGFloat.pi)
        lowerRightCorner.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCorner.frame.width, dy: -lowerRightCorner.frame.height)
    }
    
    private func drawPips()
    {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
//    // DEMO
//    override func draw(_ rect: CGRect) {
//        // CG WAY TO DRAW
//        if let context = UIGraphicsGetCurrentContext() {
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0.0, endAngle: 2*CGFloat.pi, clockwise: true)
//            
//            context.setLineWidth(5.0)
//            UIColor.green.setFill() // UIColor.setFill(green) - reads a bit nicer to me. Also mind context.setFillColor(color: CGColor)
//            UIColor.red.setStroke() // context.setStrokeColor(color: CGColor) - looks more logical but CGColor
//            // Ways to stroke
//            context.strokePath() //After the path is stroked it does'n exists anymore
//            // context.replacePathWithStrokedPath() - another way that can be used to stroke?
//            
//            // Ways to stroke
//            context.fillPath() // Nothing to Stroke!
//            // context.fillPath(using: .evenOdd or .winding)
//        }
        
//        // UI WAY TO DRAW (OO)
//        let path = UIBezierPath() //There is a CG version of UIBeizerPath. We can get it from path.cgPath
//        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0.0, endAngle: 2*CGFloat.pi, clockwise: true)
//        path.lineWidth = 5.0
//        UIColor.green.setFill() // UIColor.setFill(green) - reads a bit nicer to me.
//        UIColor.red.setStroke()  // Here is why we ever need these UIColor.setFill and setStroke - UIBezierPath()!
//        path.stroke()
//        path.fill()
//
//    }

}

extension PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {
        return bounds.size.width * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}
