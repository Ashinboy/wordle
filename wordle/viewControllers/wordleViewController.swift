//
//  wordleViewController.swift
//  wordle
//
//  Created by Ashin Wang on 2022/4/7.
//

import UIKit
import AVKit
import AVFoundation

class wordleViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    //page control
    @IBOutlet weak var pageControlOutlet: UIPageControl!
    
    //規則view
    @IBOutlet weak var ruleView: UIView!
    //結果View
    @IBOutlet var resultView: UIView!
    //遊戲結果
    @IBOutlet weak var resultLabel: UILabel!
    //字卡
    @IBOutlet var lettersLabel: [UILabel]!
    //鍵盤
    @IBOutlet var keyboardBtn: [UIButton]!
    //enter
    @IBOutlet weak var enterBtnOutlet: UIButton!
    //刪除
    @IBOutlet weak var backBtnOutlet: UIButton!
    //聲音
    @IBOutlet weak var soundKitOutlet: UIButton!
    //背景圖
    @IBOutlet weak var bgImageView: UIImageView!
    //廣告叉叉
    @IBOutlet weak var AdCancelOutlet: UIButton!
    //廣告圖
    @IBOutlet weak var adImageView: UIImageView!
    //記錄猜過的單字
    var letterRecord = [String]()
    //紀錄當前案的字母
    var currentLettersRecord = [String](repeating: "", count: 5)
    
    var currentLetterIndex = 0
    //猜中題庫的次數
    var guessTimes = 0
    //存放按過的按鈕
    var currentButtonIndex = [Int]()
    
    //結果view
    var emojis = [UILabel]()
    
    var gameState = GameState()
    var gameQuestion =  GameQuestions()
    
    //videoPlayer
    var player = AVPlayer()
    let playerLoop = AVQueuePlayer()
    var looper : AVPlayerLooper?
    
    
    
    //    var currentLetters : Character!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        var config = UIButton.Configuration.filled()
        //GIF
        AdCancelOutlet.alpha = 0.6
        let animatedImage = UIImage.animatedImageNamed("e3319bbc7d384d06a032c9f529c1538630awKMVxRrJzVjdU-", duration: 10)
        adImageView.image = animatedImage
        bgImageView.alpha = 0.3
        //產生問題
        makeQuestuin()
        //結果view
        resultView.isHidden = true
        resultView.backgroundColor = .white
        resultView.alpha = 0.9
        view.backgroundColor = UIColor(red: 33/255, green: 50/255, blue: 93/255, alpha: 1)
        
        //
        for i in 0...keyboardBtn.count-1{
            keyboardBtn[i].layer.cornerRadius = 3
            
        }
        
        enterBtnOutlet.layer.cornerRadius = 3
        backBtnOutlet.layer.cornerRadius = 3
        
        for i in 0...lettersLabel.count-1{
            lettersLabel[i].layer.borderWidth = 2.0
            lettersLabel[i].layer.cornerRadius = 6
            lettersLabel[i].layer.borderColor = CGColor(red: 236/255, green: 203/255, blue: 139/255, alpha: 0.3)
        }
        //        soundKitOutlet.tintColor = .white
        playMusic()
    }
    
    
    @IBSegueAction func showWebView(_ coder: NSCoder) -> resultViewController? {
        let controller =  resultViewController(coder: coder)
        
        return controller
    }
    @IBAction func adImageBtn(_ sender: UIButton) {
        
    }
    @IBAction func adCancelBtn(_ sender: UIButton) {
        adImageView.alpha = 0
    }
    
    @IBAction func keyBoardBtns(_ sender: UIButton) {
        //        sender.isEnabled = false
        //        sender.backgroundColor = UIColor.systemGray
        //將單字顯示在label上
        //        let letterSender = sender.title(for: .normal)!
        //        let letter = Character(letterSender.uppercased())
        
        var buttonIndex = 0
        let letterIndex = currentLetterIndex % 5
        
        while sender != keyboardBtn[buttonIndex] {
            buttonIndex += 1
        }
        
        
        
        if currentButtonIndex.count < 5 {
            currentButtonIndex.append(buttonIndex)
            
            if let title = keyboardBtn[buttonIndex].configuration?.title{
                currentLettersRecord[letterIndex] = title
                lettersLabel[currentLetterIndex].text = currentLettersRecord[letterIndex]
                
                currentLetterIndex += 1
                
            }
            
            print(currentButtonIndex)
            //            currentLetters = Character(letterSender.uppercased())
        }
        
    }
    
    
    @IBAction func enterBtn(_ sender: UIButton) {
        
        var time: Double = 0
        var greenLetter = 0
        
        //檢查是否為五個字
        if currentButtonIndex.count == 5{
            
            gameState.playerAnswer = ""
            for letter in currentLettersRecord {
                gameState.playerAnswer += letter
            }
            
            //確認是否在題庫內
            if gameState.checkContents() == false{
                mistake(state: .notExsist)
            }else if letterRecord.contains(gameState.playerAnswer){
                mistake(state: .existed)
            }else{
                enableButtons(enable: false)
                
                //檢查單字
                gameState.checkAnswer()
                
                
                for i in 0...currentLettersRecord.count-1{
                    //鍵盤提示顏色
                    keyboardBtn[currentButtonIndex[i]].configuration?.baseForegroundColor = gameState.cardColors[i]
                    
                    //翻轉
                    _ = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { _ in
                        self.goAnimation(label: self.lettersLabel[self.currentLetterIndex-5+i])
                    })
                    
                    //label提示顏色
                    _ = Timer.scheduledTimer(withTimeInterval: time+0.2, repeats: false, block: { _ in
                        self.lettersLabel[self.currentLetterIndex-5+i].textColor = self.gameState.cardColors[i]
                    })
                    
                    
                    //有正確的就換成綠色
                    if gameState.cardColors[i] == UIColor.systemGreen{
                        greenLetter += 1
                    }
                    
                    time += 0.2
                }
                
                //猜幾次
                guessTimes += 1
                
                //判斷是否結束遊戲
                
                if greenLetter == 5{
                    _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in
                        self.gameResult(isWin: true)
                    })
                }else if guessTimes == 6 && greenLetter != 5 {
                    _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in
                        self.gameResult(isWin: false)
                    })
                }
                
                print("check",guessTimes,greenLetter)
                
                
                //更新單字和按鈕
                letterRecord.append(gameState.playerAnswer)
                currentButtonIndex = []
                for i in 0...currentLettersRecord.count-1{
                    currentLettersRecord[i] = ""
                }
                
            }
            
            enableButtons(enable: true)
            
        }else{
            mistake(state: .lessThan5)
        }
        
        
        
        print(currentButtonIndex.count)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        //        let letterIndex = (currentLetterIndex - 1)%5
        
        if currentButtonIndex.count > 0 {
            
            
            //刪除陣列元件
            currentButtonIndex.removeLast()
            //            lettersLabel[letterIndex].text = ""
            
            currentLetterIndex -= 1
            lettersLabel[currentLetterIndex].text = ""
            
            
            gameState.playerAnswer = ""
            for letter in currentLettersRecord{
                gameState.playerAnswer += letter
            }
            
            
        }
    }
    
    @IBAction func pageControl(_ sender: UIPageControl) {
        let point = CGPoint(x: scrollView.bounds.width * CGFloat(sender.currentPage), y: 0)
        scrollView.setContentOffset(point, animated: true)
    }
    
    
    @IBAction func soundKit(_ sender: UIButton) {
        if soundKitOutlet.tintColor == .white{
            soundKitOutlet.tintColor = .lightGray
            soundKitOutlet.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
            playerLoop.pause()
        }else if soundKitOutlet.tintColor == .lightGray{
            soundKitOutlet.tintColor = .white
            soundKitOutlet.setImage(UIImage(systemName: "volume.1.fill"), for: .normal)
            playerLoop.play()
        }
    }
    
    @IBAction func ruleKit(_ sender: UIButton) {
        if ruleView.isHidden{
            ruleView.isHidden = false
        }else{
            ruleView.isHidden = true
        }
        
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        
        for i in 0...emojis.count-1{
            emojis[i].removeFromSuperview()
        }
        emojis.removeAll()
        resultView.isHidden = true
        reset()
    }
    
    func reset(){
        currentLetterIndex = 0
        guessTimes = 0
        gameState.usedColors = []
        letterRecord = []
        for i in 0...lettersLabel.count-1{
            lettersLabel[i].text = "".uppercased()
            lettersLabel[i].textColor = UIColor(red: 236/255, green: 203/255, blue: 139/255, alpha: 1)
        }
        
        for i in 0...keyboardBtn.count-1{
            keyboardBtn[i].configuration?.baseForegroundColor = .white
        }
        makeQuestuin()
    }
    
    func gameResult(isWin: Bool){
        resultView.isHidden = false
        view.bringSubviewToFront(resultView)
        var index = 0
        
        for col in 0...(((currentLetterIndex+1)/5)-1){
            for row in 0...4{
                let emoji = UILabel(frame: CGRect(x: 70+55*row, y: 250+col*55, width: 70, height: 70))
                emojis.append(emoji)
                
                switch gameState.usedColors[index]{
                case .systemGreen:
                    emoji.text = "🟩"
                case .systemYellow:
                    emoji.text = "🟨"
                default:
                    emoji.text = "⬛️"
                }
                resultView.addSubview(emoji)
                index += 1
            }
        }
        
        
        
        if isWin {
            if guessTimes == 1{
                resultLabel.text = "WTF!\nIncredible!"
            }else if guessTimes < 6{
                resultLabel.text = "Fantastic!"
            }else if guessTimes == 6 {
                resultLabel.text = "Good work.\nYou guessed \(guessTimes)times. "}
        }else {
            resultLabel.text = "Lol\n The answer is \(gameState.question!)"
        }
    }
    
    func makeQuestuin(){
        gameState.question = gameQuestion.getQuestions()
    }
    
    
    
    func goAnimation(label: UILabel){
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0
        animation.byValue = CGFloat.pi * 2
        animation.duration = 1
        label.layer.add(animation, forKey: nil)
    }
    
    
    //錯誤彈跳視窗
    func mistake(state: GameState.mistake){
        var controller = UIAlertController()
        switch state{
        case .notExsist:
            controller = UIAlertController(title: "not in the List ", message: nil, preferredStyle: .alert)
        case .lessThan5:
            controller = UIAlertController(title: "not enough words", message: nil, preferredStyle: .alert)
        case .existed:
            controller = UIAlertController(title: "The word existed", message: nil, preferredStyle: .alert)
        }
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    
    func playMusic(){
        let url = Bundle.main.url(forResource: "desesperebolo-9006", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: url)
        looper = AVPlayerLooper(player: playerLoop, templateItem: playerItem)
        playerLoop.play()
    }
    
    //鍵盤功能
    func enableButtons(enable: Bool){
        if enable == true{
            for i in 0...keyboardBtn.count - 1{
                keyboardBtn[i].isEnabled = true
            }
            backBtnOutlet.isEnabled = true
            enterBtnOutlet.isEnabled = true
        }else{
            for i in 0...keyboardBtn.count - 1{
                keyboardBtn[i].isEnabled = false
            }
            backBtnOutlet.isEnabled = false
            enterBtnOutlet.isEnabled = false
        }
    }
}

extension wordleViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        pageControlOutlet.currentPage = Int(page.rounded())
        
        
    }
}
