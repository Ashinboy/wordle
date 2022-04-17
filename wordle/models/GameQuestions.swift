//
//  GameStytle.swift
//  wordle
//
//  Created by Ashin Wang on 2022/4/8.
//

import Foundation

//答案
struct GameQuestions{
//    var letterCard: [String]
    let ladyNames = ["PENNY", "ALICE", "CANDY", "AVERY", "GRACE", "CHLOE", "LAYLA", "RILEY", "ELLIE", "ALEXA", "HAZEL", "SARAH", "ADELE", "NORAH", "BELLE", "PIPER", "CHLOE", "REYNA", "DIXIE", "TATUM", "FLORA", "VIOLA", "JULIA", "WILLA", "ZINIA","PETER","FIONA","GEMMA","HALEY","KIERA","JESSA","KAYLA","KYLIE","LEELA","LILLY"]
    
    func getQuestions() -> String{
        let LadyIndex = Int.random(in: 0...ladyNames.count-1)
        return ladyNames[LadyIndex]
        
        
    }
    
}
