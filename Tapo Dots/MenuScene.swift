//
//  MenuScene.swift
//  Tapo Dots
//
//  Created by Nicholas Arduini on 2018-01-29.
//  Copyright © 2018 Nicholas Arduini. All rights reserved.
//

import SpriteKit
import StoreKit
import AVFoundation

class MenuScene: SKScene {
    var playButton = SKSpriteNode()
    private var startLabel = SKLabelNode()
    private var labelPlay = SKSpriteNode()
    private var gameCenterButton = SKSpriteNode()
    private var removeAdsButton = SKSpriteNode()
    private var restoreAdsButton = SKSpriteNode()
    var ratio = CGFloat(0.0)
    var bottomY = CGFloat(0.15)
    var bottomMiddleY = CGFloat(0.4)
    var middleY = CGFloat(0.5)
    var upperY = CGFloat(0.75)
    var backgroundMusicPlayer : AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        buildMenu()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuScene.purchasedGame), name: NSNotification.Name(rawValue: Common.PurchasedGame), object: nil)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == labelPlay {
                labelPlay.run(SKAction.init(named: Common.ScaleBig)!)
                let scene = GameScene(size: (view?.bounds.size)!)
                scene.scaleMode = SKSceneScaleMode.aspectFill
                view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.4))
            } else if node == gameCenterButton {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Common.OpenGameCenter), object: nil)
                gameCenterButton.run(SKAction.init(named: Common.ScaleBig)!)
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
        
        let gameLabel = SKLabelNode(fontNamed: Common.FuturaMDITFont)
        gameLabel.text = Common.TapoDots
        gameLabel.fontSize = 60 * ratio
        gameLabel.fontColor = SKColor.white
        gameLabel.position = CGPoint(x: size.width/2, y: size.height * upperY)
        gameLabel.alpha = 0.0
        gameLabel.run(SKAction.fadeIn(withDuration: 0.8))
        addChild(gameLabel)
        
        let buttonsWeight = (self.size.width) / 6
        let buttonsSize = buttonsWeight * 0.8
        gameCenterButton = SKSpriteNode(imageNamed: Common.GameCenter)
        gameCenterButton.position = CGPoint(x: size.width/2, y: size.height * bottomY)
        gameCenterButton.size = CGSize(width: buttonsSize, height: buttonsSize)
        gameCenterButton.color = UIColor.clear
        addChild(gameCenterButton)
        
        if(!isPurchased()){
            removeAdsButton = SKSpriteNode(imageNamed: Common.RemoveAds)
            removeAdsButton.position = CGPoint(x: gameCenterButton.frame.minX - buttonsSize*0.75, y: size.height * bottomY)
            removeAdsButton.size = CGSize(width: buttonsSize, height: buttonsSize)
            addChild(removeAdsButton)
            
            restoreAdsButton = SKSpriteNode(imageNamed: Common.Restore)
            restoreAdsButton.position = CGPoint(x: gameCenterButton.frame.maxX + buttonsSize*0.75, y: size.height * bottomY)
            restoreAdsButton.size = CGSize(width: buttonsSize, height: buttonsSize)
            addChild(restoreAdsButton)
        }
        
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: Common.HighScoreKey)
        
        if(highScore > 0){
            let highScoreLabel = SKLabelNode(fontNamed: Common.FuturaCDMDFont)
            highScoreLabel.text = "\(highScore)"
            highScoreLabel.fontSize = 45 * ratio
            highScoreLabel.fontColor = SKColor.white
            highScoreLabel.position = CGPoint(x: size.width/2, y: gameCenterButton.frame.maxY + buttonsSize*bottomMiddleY)
            highScoreLabel.alpha = 0.0
            highScoreLabel.run(SKAction.fadeIn(withDuration: 0.8))
            
            let bestLabel = SKLabelNode(fontNamed: Common.FuturaCDMDFont)
            bestLabel.text = Common.Best
            bestLabel.fontSize = 26 * ratio
            bestLabel.fontColor = SKColor.white
            bestLabel.position = CGPoint(x: 0, y: highScoreLabel.frame.height+4)
            bestLabel.alpha = 0.0
            bestLabel.run(SKAction.fadeIn(withDuration: 0.8))
            
            highScoreLabel.addChild(bestLabel)
            
            addChild(highScoreLabel)
        }
        
        let w = (self.size.width) / 3
        let labelPlayw = w * 0.6
        let labelPlayh = labelPlayw/2.12
        labelPlay = SKSpriteNode(imageNamed: Common.Play)
        labelPlay.position = CGPoint(x: size.width/2+3, y: size.height * middleY)
        labelPlay.size = CGSize(width: labelPlayw, height: labelPlayh)
        labelPlay.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.init(named: Common.Shake, duration: 0.5)!,
                SKAction.wait(forDuration: 0.5)
                ])
        ))
        addChild(labelPlay)
        
        let labelSpin = SKSpriteNode(imageNamed: Common.TapCircleImage)
        labelSpin.position = CGPoint(x: size.width/2, y: size.height * middleY)
        labelSpin.zPosition = -1
        labelSpin.size = CGSize(width: w, height: w)
        labelSpin.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.8)))
        addChild(labelSpin)
        
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
