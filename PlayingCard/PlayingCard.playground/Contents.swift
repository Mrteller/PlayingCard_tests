//: Playground - noun: a place where people can play

import UIKit
import Foundation

// Case1: Make own protocol that iterates (Extension is not nesessary)
// TODO: Generalize, conform to Sequence to do for i in .first...last

protocol EnumerableEnum {
    init?(rawValue: Int) //Is it used somehow?
    static func firstRawValue() -> Int
}

extension EnumerableEnum {
    static func enumerate() -> AnyIterator<Self> {
        var nextIndex = firstRawValue()
        
        let iterator: AnyIterator<Self> = AnyIterator {
            defer { nextIndex = nextIndex + 1 }
            return Self(rawValue: nextIndex)
        }
        
        return iterator
    }
    
    static func firstRawValue() -> Int {
        return 0
        
    }
}
enum Suit: Int, CustomStringConvertible, EnumerableEnum {
    case Spades, Hearts, Diamonds, Clubs
    var description: String {
        switch self {
        case .Spades:   return "Spades"
        case .Hearts:   return "Hearts"
        case .Diamonds: return "Diamonds"
        case .Clubs:    return "Clubs"
        }
    }
}
// ...
for suit in Suit.enumerate() {
    print(suit.description)
    
}


//enum SuitSeq: Int, CustomStringConvertible, Sequence {
//    case Spades, Hearts, Diamonds, Clubs
//    var description: String {
//        switch self {
//        case .Spades:   return "Spades"
//        case .Hearts:   return "Hearts"
//        case .Diamonds: return "Diamonds"
//        case .Clubs:    return "Clubs"
//        }
//    }
//    mutating func next() -> T? {
//        if items.isEmpty { return .None }
//        let item = items[0]
//        items = items[1..items.count]
//        return item
//    }
//}
//// ...
//for suitSeq in Suit.enumerate() {
//    print(suit.description)
//
//}

// "Int" to get rawValue, and {Strideable} so we can iterate
enum MyColorEnum : Int, CustomStringConvertible, Strideable {
    case Red
    case Green
    case Blue
    case Black
    
    //-------- required by {Strideable}
    typealias Stride = Int
    
    func advanced(by n:Stride) -> MyColorEnum {
        var next = self.rawValue + n
        if next > MyColorEnum.Black.rawValue {
            next = MyColorEnum.Black.rawValue
        }
        return MyColorEnum(rawValue: next)!
    }
    
    func distance(to other: MyColorEnum) -> Int {
        return other.rawValue - self.rawValue
    }
    
    //-------- just for printing
    var description: String {
        switch self {
        case .Red: return "Red"
        case .Green: return "Green"
        case .Blue: return "Blue"
        case .Black: return "Black"
        }
    }
}


// this is how you use it:
for i in MyColorEnum.Red ... MyColorEnum.Black {
    print("ENUM: \(i)")
}


enum Reindeer: Int, CustomStringConvertible {
    case Dasher, Dancer, Prancer, Vixen, Comet, Cupid, Donner, Blitzen
    // and don't forget Rudolph!
    case Rudolph
    
    var description: String {
        let names = ["Dasher", "Dancer", "Prancer", "Vixen", "Comet", "Cupid", "Donner", "Blitzen", "Rudolph"]
        return names[self.rawValue]
    }
}

//All Cases (Extension is not nesessary)
// TODO: Generalize

extension Reindeer {
    static var allCases: [Reindeer] {
        var nextIndex = 0
        return Array(
            AnyIterator<Reindeer> {
                defer { nextIndex = nextIndex + 1 }
                return Reindeer(rawValue: nextIndex)
            }
        )
    }
}

for reindeer in Reindeer.allCases {
    print("On \(reindeer.description)!")
}
// As above, but without extension
enum ValidSuits:String {
    case Clubs, Spades, Hearts, Diamonds
    func description()->String{
        switch self{
        case .Clubs:
            return "♣︎"
        case .Spades:
            return "♠︎"
        case .Diamonds:
            return "♦︎"
        case .Hearts:
            return "♥︎"
        }
    }
    
//    static var allSuits:[ValidSuits]{
//        return Array(
//            AnyIterator<ValidSuits> {
//                var nextIndex = 0
//                defer { nextIndex = nextIndex + 1 }
//                return ValidSuits(rawValue: nextIndex)
//            }
//        )
//    }
}

//print(ValidSuits.allSuits)


func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

for i in iterateEnum(ValidSuits.self) {
    print(i)
}
