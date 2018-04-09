//
//  EndGameScene.swift
//  Tapo Dots
//
//  Created by Nicholas Arduini on 2018-01-29.
//  Copyright © 2018 Nicholas Arduini. All rights reserved.
//

import SpriteKit
import StoreKit
import AVFoundation

class EndGameScene: SKScene {
    
    private var playButton = SKSpriteNode()
    private var startLabel = SKLabelNode()
    private var scoreLabel = SKLabelNode()
    private var highScoreLabel = SKLabelNode()
    private var bestLabel = SKLabelNode()
    private var labelRetry = SKSpriteNode()
    private var gameCenterButton = SKSpriteNode()
    private var removeAdsButton = SKSpriteNode()
    private var restoreAdsButton = SKSpriteNode()
    var score: Int = 0
    var isHighScore = false
    var ratio = CGFloat(0.0)
    var bottomY = CGFloat(0.15)
    var bottomMiddleY = CGFloat(0.4)
    var middleY = CGFloat(0.5)
    var upperY = CGFloat(0.75)
    var backgroundMusicPlayer : AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        let randomShouldShowAd = Int(arc4random_uniform(3))
        let randomShouldShowRequestReview = Int(arc4random_uniform(10))
        if(randomShouldShowAd == 1){
            run(SKAction.sequence([
                SKAction.run { self.backgroundMusicPlayer?.pause() },
                SKAction.wait(forDuration: 0.05), //wait for delay of opening scene
                SKAction.run { self.displayAd()}]))
        }
        
        if(randomShouldShowRequestReview == 1){
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
        
        buildMenu()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EndGameScene.purchasedGame), name: NSNotification.Name(rawValue: Common.PurchasedGame), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EndGameScene.resumeMusic), name: NSNotification.Name(rawValue: Common.AdDissmissed), object: nil)
    }
    
    func setBackgroundColor(){
        let randomShapeSide = Int(arc4random_uniform(3))
        var color = SKColor()
        if(randomShapeSide == 0){
            color = SKColor.gameRedColor()
        } else if(randomShapeSide == 1){
            color = SKColor.gameGreenColor()
        } else {
            color = SKColor.gameBlueColor()
        }
        backgroundColor = color
    }
    
    func displayAd() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Common.LoadAndShowAd), object: nil)
    }
    
    func animiateScore(){
        bestLabel.run(SKAction.init(named: Common.ScaleBig)!)
        highScoreLabel.run(SKAction.init(named: Common.ScaleBig)!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == labelRetry {
                labelRetry.run(SKAction.init(named: Common.ScaleBig)!)
                let scene = GameScene(size: (view?.bounds.size)!)
                scene.scaleMode = SKSceneScaleMode.aspectFill
                view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.4))
            } else if node == gameCenterButton {
                gameCenterButton.run(SKAction.init(named: Common.ScaleBig)!)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Common.OpenGameCenter), object: nil)
            } else if node == removeAdsButton {
                removeAdsButton.run(SKAction.init(named: Common.ScaleBig)!)
                appDelegate().IAPM.pay()
            } else if node == restoreAdsButton {
                restoreAdsButton.run(SKAction.init(named: Common.ScaleBig)!)
                appDelegate().IAPM.restore()
            }
        }
    }
    
    @objc func purchasedGame(){
        removeAdsButton.isHidden = true
        restoreAdsButton.isHidden = true
    }
    
    @objc func resumeMusic(){
        backgroundMusicPlayer?.play()
    }
    
    func isPurchased() ->Bool{
        let save = UserDefaults.standard
        if((save.value(forKey: Common.PurchasedKey)) == nil){
            return false
        } else {
            return true
        }
    }
    
    func buildMenu(){
        setBackgroundColor()
        ratio = ((frame.width)/(375))
        
        scoreLabel = SKLabelNode(fontNamed: Common.FuturaBoldFont)
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 60 * ratio
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height * upperY)
        scoreLabel.alpha = 0.0
        scoreLabel.run(SKAction.fadeIn(withDuration: 0.8))
        addChild(scoreLabel)
        
        let buttonsWeight = (self.size.width) / 6
        let buttonsSize = buttonsWeight * 0.8
        gameCenterButton = SKSpriteNode(imageNamed: Common.GameCenter)
        gameCenterButton.position = CGPoint(x: size.width/2, y: size.height * bottomY)
        gameCenterButton.size = CGSize(width: buttonsSize, height: buttonsSize)
        gameCenterButton.color = UIColor.clear
        gameCenterButton.alpha = 0.0
        gameCenterButton.run(SKAction.fadeIn(withDuration: 0.8))
        addChild(gameCenterButton)
        
        if(!isPurchased()){
            removeAdsButton = SKSpriteNode(imageNamed: Common.RemoveAds)
            removeAdsButton.position = CGPoint(x: gameCenterButton.frame.minX - buttonsSize*0.75, y: size.height * bottomY)
            removeAdsButton.size = CGSize(width: buttonsSize, height: buttonsSize)
            removeAdsButton.alpha = 0.0
            removeAdsButton.run(SKAction.fadeIn(withDuration: 0.8))
            addChild(removeAdsButton)
            
            restoreAdsButton = SKSpriteNode(imageNamed: Common.Restore)
            restoreAdsButton.position = CGPoint(x: gameCenterButton.frame.maxX + buttonsSize*0.75, y: size.height * bottomY)
            restoreAdsButton.size = CGSize(width: buttonsSize, height: buttonsSize)
            restoreAdsButton.alpha = 0.0
            restoreAdsButton.run(SKAction.fadeIn(withDuration: 0.8))
            addChild(restoreAdsButton)
        }
        
        let defaults = UserDefaults.standard
        var highScore = defaults.integer(forKey: Common.HighScoreKey)
        
        if(score > highScore || (!(highScore > 0) && score > 0)){
            isHighScore = true
            defaults.set(score, forKey: Common.HighScoreKey)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Common.NewHighScore), object: nil, userInfo: [Common.ScoreInfo: score])
        }
        highScore = defaults.integer(forKey: Common.HighScoreKey)
        if(highScore > 0){
            highScoreLabel = SKLabelNode(fontNamed: Common.FuturaCDMDFont)
            highScoreLabel.text = "\(highScore)"
            highScoreLabel.fontSize = 45 * ratio
            highScoreLabel.fontColor = SKColor.white
            highScoreLabel.position = CGPoint(x: size.width/2, y: gameCenterButton.frame.maxY + buttonsSize*bottomMiddleY)
            highScoreLabel.alpha = 0.0
            highScoreLabel.run(SKAction.fadeIn(withDuration: 0.8))
            
            bestLabel = SKLabelNode(fontNamed: Common.FuturaCDMDFont)
            bestLabel.text = Common.Best
            bestLabel.fontSize = 26 * ratio
            bestLabel.fontColor = SKColor.white
            bestLabel.position = CGPoint(x: 0, y: highScoreLabel.frame.height+4)
            bestLabel.alpha = 0.0
            bestLabel.run(SKAction.fadeIn(withDuration: 0.8))
            
            highScoreLabel.addChild(bestLabel)
            
            addChild(highScoreLabel)
        }
        
        let w = (self.size.width) / 2.8
        let labelRetryw = w * 0.6
        let labelRetryh = labelRetryw/2.8
        labelRetry = SKSpriteNode(imageNamed: Common.Retry)
        labelRetry.position = CGPoint(x: size.width/2+3, y: size.height * middleY)
        labelRetry.size = CGSize(width: labelRetryw, height: labelRetryh)
        labelRetry.alpha = 0.0
        labelRetry.run(SKAction.fadeIn(withDuration: 0.8))
        labelRetry.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.init(named: Common.Shake, duration: 0.5)!,
                SKAction.wait(forDuration: 0.5)
                ])
        ))
        addChild(labelRetry)
        
        let labelSpin = SKSpriteNode(imageNamed: Common.TapCircleImage)
        labelSpin.position = CGPoint(x: size.width/2, y: size.height * middleY)
        labelSpin.zPosition = -1
        labelSpin.size = CGSize(width: w, height: w)
        labelSpin.alpha = 0.0
        labelSpin.run(SKAction.fadeIn(withDuration: 0.8))
        labelSpin.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.8)))
        addChild(labelSpin)
        
        if(isHighScore){
            run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(animiateScore),
                    SKAction.wait(forDuration: 2.0)
                    ])
            ))
        }
        
        self.playMusic(filename: Common.IntroWav)
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func playMusic(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
        }
        do { backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!, fileTypeHint: nil) }
        catch let error as NSError { print(error.description) }
        if let player = backgroundMusicPlayer {
            player.volume = 1
            player.numberOfLoops = -1
            player.enableRate = true
            player.rate = 1.0
            player.prepareToPlay()
            player.play()
        }
    }
}
