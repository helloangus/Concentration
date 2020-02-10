//
//  ViewController.swift
//  Concentration
//
//  Created by Angus Lee on 2019/11/27.
//  Copyright © 2019 Angus Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //可选的emoji
    private var emojiChoices = ["🎃", "🤡", "😈", "👻", "👹", "🦇", "🍭", "🙀"]
    //设置卡牌对数
    private lazy var game: Contentration = Contentration(numberOfPairsOfCards: numberOfPairsOfCards, emojiChoicesCount: emojiChoices.count)
    
    //只读计算属性
    var numberOfPairsOfCards: Int{
        return (cardButtons.count + 1)/2
    }
    
    private var gameIsOver: Bool = false
    
    //链接view和controller
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    //显示成功页面
    @IBOutlet private var successLabel: UILabel!
    
    //检测到按钮被按下
    @IBAction private func touchCard(_ sender: UIButton) {
        
        //确认按钮在序列中，翻牌
        if let cardNumber = cardButtons.firstIndex(of: sender){
            //flipCard(withEmoji: emojisChoices[cardNumber], on: sender)
            gameIsOver = game.chooseCard(at: cardNumber)
            if gameIsOver {
                successLabel.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
            updateViewFromModel()
        }else{
            print("cardNumber is not in the cardButtons")
        }
    }
    
    //从Model中获取信息更新
    private func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"        //更新翻牌次数
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            
            //面朝上
            if card.isFaceup{
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)     //如果matched，变透明
            }
        }
    }
    
    //生成的随机emoji字典
    private var emoji = [Int: String]()
    
    //
    private func emoji(for card: Card) -> String {
        if emoji[card.indentifier] == nil{
            emoji[card.indentifier] = emojiChoices[game.emojiRandomIndex[card.indentifier-1]]
        }
        return emoji[card.indentifier] ?? "?"
    }
    
    //重新开始游戏
    @IBOutlet private var restartButton: UIButton!
    @IBAction private func restartGame(sender: UIButton){
        game = Contentration(numberOfPairsOfCards: (cardButtons.count + 1)/2, emojiChoicesCount: emojiChoices.count)
        game.flipCount = 0
        updateViewFromModel()
        successLabel.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
    }
    
    //test
    
}

