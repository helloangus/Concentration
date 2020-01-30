//
//  Card.swift
//  Concentration
//
//  Created by Angus Lee on 2019/12/4.
//  Copyright © 2019 Angus Lee. All rights reserved.
//

import Foundation

//卡牌结构体
struct Card {
    var isFaceup = false
    var isMatched = false
    var indentifier: Int
    
    //每张卡牌生成唯一的indentifier
    static var indentifierFactory = 0
    
    static func getUniqueIndentifier() -> Int{
        indentifierFactory += 1
        return indentifierFactory
    }
    
    init(newGame: Bool) {
        if newGame{
            Card.indentifierFactory = 0
        }
        self.indentifier = Card.getUniqueIndentifier()  //调用内部函数
    }
}
