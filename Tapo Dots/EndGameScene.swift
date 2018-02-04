//
//  EndGameScene.swift
//  Tapo Dots
//
//  Created by Nicholas Arduini on 2018-01-29.
//  Copyright © 2018 Nicholas Arduini. All rights reserved.
//

import SpriteKit
import StoreKit

class EndGameScene: SKScene {
    
    private var playButton = SKSpriteNode()
    private var startLabel = SKLabelNode()
    private var scoreLabel = SKLabelNode()
    private var highScoreLabel = SKLabelNode()
    private var bestLabel = SKLabelNode()
    private var labelRetry = SKSpriteNode()
    var score: Int = 0
    var isHighScore = false
    var ratio = CGFloat(0.0)
    
    override func didMove(to view: SKView) {
        setBackgroundColor()
        ratio = ((frame.width)/(375))
        
        let randomShouldShowAd = Int(arc4random_uniform(4))
        let randomShouldShowRequestReview = Int(arc4random_uniform(10))
        if(randomShouldShowAd == 1){
            displayAd()
        }
        
        if(randomShouldShowRequestReview == 1){
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
        
        scoreLabel = SKLabelNode(fontNamed: Common.FuturaBoldFont)
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 60 * ratio
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height * 0.70)
        scoreLabel.alpha = 0.0
        scoreLabel.run(SKAction.fadeIn(withDuration: 0.8))
        addChild(scoreLabel)
        
        let defaults = UserDefaults.standard
        var highScore = defaults.integer(forKey: Common.HighScoreKey)
        
        if(score > highScore || (!(highScore > 0) && score > 0)){
            isHighScore = true
            defaults.set(score, forKey: Common.HighScoreKey)
        }
        highScore = defaults.integer(forKey: Common.HighScoreKey)
        if(highScore > 0){
            highScoreLabel = SKLabelNode(fontNamed: Common.FuturaCDMDFont)
            highScoreLabel.text = "\(highScore)"
            highScoreLabel.fontSize = 45 * ratio
            highScoreLabel.fontColor = SKColor.white
            highScoreLabel.position = CGPoint(x: size.width/2, y: size.height * 0.14)
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
        
        /* Replace with image after centering problem
        startLabel = SKLabelNode(fontNamed: Common.FuturaBoldFont)
        startLabel.text = Common.Retry
        startLabel.fontSize = 28 * ratio
        startLabel.fontColor = SKColor.white
        startLabel.position = CGPoint(x: size.width/2, y: size.height * 0.45)
        startLabel.alpha = 0.0
        startLabel.color = SKColor.white
        startLabel.run(SKAction.sequence([(SKAction.wait(forDuration: 0.5)), (SKAction.fadeIn(withDuration: 0.8))]))
        addChild(startLabel)
         */
        
        let w = (self.size.width) / 3
        let labelRetryw = w * 0.6
        let labelRetryh = labelRetryw/2.8
        labelRetry = SKSpriteNode(imageNamed: Common.Retry)
        labelRetry.position = CGPoint(x: size.width/2+3, y: size.height * 0.45)
        labelRetry.size = CGSize(width: labelRetryw, height: labelRetryh)
        labelRetry.alpha = 0.0
        labelRetry.run(SKAction.fadeIn(withDuration: 0.8))
        addChild(labelRetry)
        
        let labelSpin = SKSpriteNode(imageNamed: Common.TapCircleImage)
        labelSpin.position = CGPoint(x: size.width/2, y: size.height * 0.45)
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
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(shakePlayButton),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
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
    
    func shakePlayButton(){
        startLabel.run(SKAction.init(named: Common.Shake)!)
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
                let scene = GameScene(size: (view?.bounds.size)!)
                scene.scaleMode = SKSceneScaleMode.aspectFill
                view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.4))
            }
        }
    }
}
