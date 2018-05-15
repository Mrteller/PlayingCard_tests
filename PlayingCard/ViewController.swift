//
//  ViewController.swift
//  PlayingCard
//
//  Created by Paul on 08.03.2018.
//  Copyright © 2018 Laconic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var deck = PlayingCardDeck()
    
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            //swipe.numberOfTouchesRequired = 1
            playingCardView.addGestureRecognizer(swipe)
            
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(adjustFaceCardScale (byHandlingGestureRecognizedby: )))
            playingCardView.addGestureRecognizer(pinch)
            
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            playingCardView.isFaceUp = !playingCardView.isFaceUp
        default:
            break
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
       /*
        for i in 0..<deck.cards.count {
            if let card = deck.draw() {
                print("\(card) - \(i)")
            }
        }*/
    }
    
    @objc func nextCard(){
        print("swiped")
        if let card = deck.draw() {
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
            
        }
    }
    
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedby recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            playingCardView.faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
            // playingCardView.faceCardScale = recognizer.scale * playingCardView.SizeRatio.faceCardImageSizeToBoundsSize
        default:
            break
        }
    }
// Playing with Date and DateFormatter - delete it
    private func t() {
        let someDate = Date(timeIntervalSinceReferenceDate: 0)
        let dFormatter = DateFormatter()
        dFormatter.dateStyle = .full
        var dateString = dFormatter.string(from: someDate)
        for dateStyle in DateFormatter.Style.full.rawValue...DateFormatter.Style.short.rawValue  {
            dFormatter.dateStyle = DateFormatter.Style.init(rawValue: dateStyle) ?? .none
            dateString = dFormatter.string(from: someDate)
            print(dateString)
        }
        
        //let dds = Set(DateFormatter.Style)
    }
    
    

}

