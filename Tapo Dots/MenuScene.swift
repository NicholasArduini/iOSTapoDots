//
//  MenuScene.swift
//  Tapo Dots
//
//  Created by Nicholas Arduini on 2018-01-29.
//  Copyright © 2018 Nicholas Arduini. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var playButton = SKSpriteNode()
    private var startLabel = SKLabelNode()
    private var labelPlay = SKSpriteNode()
    var ratio = CGFloat(0.0)
    
    override func didMove(to view: SKView) {
        setBackgroundColor()
        ratio = ((frame.width)/(375))
        
        let gameLabel = SKLabelNode(fontNamed: Common.FuturaMDITFont)
        gameLabel.text = Common.TapoDots
        gameLabel.fontSize = 60 * ratio
        gameLabel.fontColor = SKColor.white
        gameLabel.position = CGPoint(x: size.width/2, y: size.height * 0.7)
        gameLabel.alpha = 0.0
        gameLabel.run(SKAction.fadeIn(withDuration: 0.8))
        addChild(gameLabel)
        
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: Common.HighScoreKey)
        
        if(highScore > 0){
            let highScoreLabel = SKLabelNode(fontNamed: Common.FuturaCDMDFont)
            highScoreLabel.text = "\(highScore)"
            highScoreLabel.fontSize = 45 * ratio
            highScoreLabel.fontColor = SKColor.white
            highScoreLabel.position = CGPoint(x: size.width/2, y: size.height * 0.14)
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
        
        /* Replace with image after font centering problem
        startLabel = SKLabelNode(fontNamed: Common.FuturaBoldFont)
        startLabel.text = Common.Play
        startLabel.fontSize = 30 * ratio
        startLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        startLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        startLabel.fontColor = SKColor.white
        startLabel.position = CGPoint(x: size.width/2 + 2 , y: size.height * 0.45)
        startLabel.alpha = 0.0
        startLabel.color = SKColor.white
        startLabel.run(SKAction.sequence([(SKAction.wait(forDuration: 0.5)), (SKAction.fadeIn(withDuration: 0.8))]))
        addChild(startLabel)
         */
       
        let w = (self.size.width) / 3
        let labelPlayw = w * 0.6
        let labelPlayh = labelPlayw/2.12
        labelPlay = SKSpriteNode(imageNamed: Common.Play)
        labelPlay.position = CGPoint(x: size.width/2+3, y: size.height * 0.45)
        labelPlay.size = CGSize(width: labelPlayw, height: labelPlayh)
        addChild(labelPlay)
        
        let labelSpin = SKSpriteNode(imageNamed: Common.TapCircleImage)
        labelSpin.position = CGPoint(x: size.width/2, y: size.height * 0.45)
        labelSpin.zPosition = -1
        labelSpin.size = CGSize(width: w, height: w)
        labelSpin.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.8)))
        addChild(labelSpin)
        
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
    
    func shakePlayButton(){
        startLabel.run(SKAction.init(named: Common.Shake)!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == labelPlay {
                let scene = GameScene(size: (view?.bounds.size)!)
                scene.scaleMode = SKSceneScaleMode.aspectFill
                view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.4))
            }
        }
    }
}
