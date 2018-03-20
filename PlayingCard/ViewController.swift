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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<deck.cards.count {
            if let card = deck.draw() {
                print("\(card) - \(i)")
            }
        }
    }


    private func t() {
        let someDate = Date(timeIntervalSinceReferenceDate: 0)
        let dFormatter = DateFormatter()
        dFormatter.dateStyle = .full
        let sString = dFormatter.string(from: someDate)
        for ds in DateFormatter.Style.full.rawValue...DateFormatter.Style.short.rawValue  {
            dFormatter.dateStyle = DateFormatter.Style.init(rawValue: ds) ?? .none
        }
        
        //let dds = Set(DateFormatter.Style)
    }
    
    

}

