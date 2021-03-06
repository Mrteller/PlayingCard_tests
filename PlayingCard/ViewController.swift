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
    
    
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var collisionBehaviour: UICollisionBehavior = {
        let behaviour =  UICollisionBehavior()
        behaviour.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(behaviour)
        return behaviour
    }()
    
    lazy var itemBehaviour : UIDynamicItemBehavior = {
        let behaviour = UIDynamicItemBehavior()
        behaviour.allowsRotation = false
        behaviour.elasticity = 1.0
        behaviour.resistance = 0.0
        animator.addBehavior(behaviour)
        return behaviour
    }()
    
    private var faceUpCardsViews: [PlayingCardView] {
        return cardViews.filter{ $0.isFaceUp && !$0.isHidden}
    }
    private var faceUpCardViewsMatched: Bool {
        return faceUpCardsViews.count == 2 &&
            faceUpCardsViews[0].rank == faceUpCardsViews[1].rank &&
            faceUpCardsViews[0].suit == faceUpCardsViews[1].suit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        print("\(cards)")
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            collisionBehaviour.addItem(cardView)
            itemBehaviour.addItem(cardView)
            let push = UIPushBehavior(items: [cardView], mode: .instantaneous)
            push.angle = (2.0*CGFloat.pi).arc4random
            push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
            push.action = { [unowned push] in
                push.dynamicAnimator?.removeBehavior(push)
            }
            animator.addBehavior(push)
        }
    }
    
    @objc private func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView {
                UIView.transition(with: chosenCardView,
                                  duration: 0.6,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                },
                                  completion: {finished in
                                    if self.faceUpCardViewsMatched {
                                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6,
                                                                                       delay: 0,
                                                                                       options: [],
                                                                                       animations: {
                                                                                        self.faceUpCardsViews.forEach {
                                                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)}
                                        },
                                                                                       completion: { position in
                                                                                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75,
                                                                                                                                       delay: 0,
                                                                                                                                       options: [],
                                                                                                                                       animations: {
                                                                                                                                        self.faceUpCardsViews.forEach {
                                                                                                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                                                                                                            $0.alpha = 0
                                                                                                                                        }},
                                                                                                                                        completion: { posvfvfvition in
                                                                                                                                            self.faceUpCardsViews.forEach {
                                                                                                                                                $0.isHidden = true
                                                                                                                                                $0.alpha = 1
                                                                                                                                                $0.transform = .identity
                                                                                                                                            }
                                                                                                                                        }
                                                                
                                                                                        )
                                                                                        
                                        }
                                        )
                                    } else if self.faceUpCardsViews.count == 2 {
                                        self.faceUpCardsViews.forEach{ cardView in
                                            UIView.transition(with: cardView,
                                                              duration: 0.6,
                                                              options: [.transitionFlipFromLeft],
                                                              animations: {
                                                                cardView.isFaceUp = false
                                            })
                                        }
                                    }
                                    
                })
            }
        default:
            break
        }
    }
    
}

