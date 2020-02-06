//
//  Concentration.swift
//  Concentration
//
//  Created by Angus Lee on 2019/12/4.
//  Copyright © 2019 Angus Lee. All rights reserved.
//

import Foundation

class Contentration{
    
    private(set)  var cards = [Card]()    //设置卡牌数组
    
    var emojiRandomIndex = Array<Int>() //设置emoji随机编号
    
    //计算属性，当只有一张卡牌被翻开时有值，为其索引
    private var indexOfOneAndOnlyFacedUpCard: Int?{
        
        //返回正确的只有一张被翻开的牌的索引
        get{
            var foundIndex: Int?
            for index in cards.indices{
                if cards[index].isFaceup {
                    if foundIndex == nil{
                        foundIndex = index
                    }else{
                        return nil
                    }
                }
            }
            return foundIndex
        }
        
        //遍历所有卡牌，只有新选中的那张才被翻开
        //没有牌被翻开或者有两张不同被翻开
        set{
            for index in cards.indices{
                cards[index].isFaceup = (index == newValue)
            }
        }
    }
    
    var flipCount: Int = 0
    
    //选中则翻牌
    func chooseCard(at index:  Int) -> Bool {
        
        //断言，确保Model中的card数UI中能够满足，否则程序崩溃
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index): chosen index not in the cards")
        
        //新翻的牌没有标记为匹配
        if !cards[index].isMatched {
            //只有一张牌已经被翻开
            if let matchIndex = indexOfOneAndOnlyFacedUpCard{
                //且第二次翻开不是同一张
                if matchIndex != index{
                    //匹配成功
                    if cards[matchIndex].indentifier == cards[index].indentifier{
                        cards[matchIndex].isMatched = true
                        cards[index].isMatched = true
                    }
                    cards[index].isFaceup = true
                    flipCount += 1
                }
            }else{
                indexOfOneAndOnlyFacedUpCard = index
                flipCount += 1
            }
        }
        
        
        //如果所有卡牌全都匹配，则反转所有卡牌
        var allCardsIsMatched = true
        
        for index in cards.indices{
            if cards[index].isMatched == false{
                allCardsIsMatched = false
            }
        }
        if allCardsIsMatched == true {
            for flipDownIndex in cards.indices{
                cards[flipDownIndex].isFaceup = false
            }
            return true
        }
        return false
    }


        
        
    //生成对应数量的卡牌
    init(numberOfPairsOfCards: Int, emojiChoicesCount: Int) {
        //断言，确保最少有一对卡牌，否则程序崩溃
        assert(numberOfPairsOfCards > 0, "Concentration.init(at: \(numberOfPairsOfCards): must have at least one pair of cards")
        
        for index in 1...numberOfPairsOfCards{
            if index == 1 {
                let card = Card(newGame: true)
                cards += [card, card]
            }else{
                let card = Card(newGame: false)
                cards += [card, card]
            }

        }
        
        //卡牌随机放置，即乱序放置cards数组中的元素
        var tempCard: Card
        for index in cards.indices{
            let radomCardIndex = Int(arc4random_uniform(UInt32(cards.count)))
            tempCard = cards[index]
            cards[index] = cards[radomCardIndex]
            cards[radomCardIndex] = tempCard
        }
        
        //方法同上，生成顺序数组，再随机化
        for num in 0..<emojiChoicesCount {
            emojiRandomIndex.append(num)
        }
        
        var tempIndex: Int
        for index in 0..<emojiChoicesCount {
            let radomEmojiIndex = Int(arc4random_uniform(UInt32(emojiChoicesCount)))
            tempIndex = emojiRandomIndex[index]
            emojiRandomIndex[index] = emojiRandomIndex[radomEmojiIndex]
            emojiRandomIndex[radomEmojiIndex] = tempIndex
        }
        
    }
    
}
