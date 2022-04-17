//
//  GameState.swift
//  wordle
//
//  Created by Ashin Wang on 2022/4/8.
//

import Foundation
import UIKit



struct GameState{
    var question : String?
    var playerAnswer = ""
    
    //卡片顏色
    var cardColors = [UIColor](repeating: UIColor.darkGray, count: 5)
    
    //用過的顏色
    var usedColors = [UIColor]()
    
    //檢查是否字有對上
    func checkContents()->Bool{
        let questionName = GameQuestions()
        if !questionName.ladyNames.contains(playerAnswer.uppercased()){
            return false
        }
        return true
    }
    
    
    enum mistake{
        case notExsist
        case lessThan5
        case existed
    }
    
//    let words = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",]
    
    
    //題目拆解成字母
    mutating func checkAnswer(){
        
        var guessedWord = [String]()
        var index = 0
        
        for i in 0...cardColors.count - 1 {
            cardColors[i] = .darkGray
        }
        
        if let letter = question{
            for char in letter{
                guessedWord.append(String(char))
            }
            //顏色判斷
            for char in playerAnswer.uppercased(){
                if String(char) == guessedWord[index]{
                    cardColors[index] = .systemGreen
                }else{
                    if letter.contains(char){
                        cardColors[index] = .systemYellow
                    }
                }
                usedColors.append(cardColors[index])
                index += 1
            }
        }
    }
    
}
