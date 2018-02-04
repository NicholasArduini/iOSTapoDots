//
//  GameScene.swift
//  Tapo Dots
//
//  Created by Nicholas Arduini on 2018-02-03.
//  Copyright © 2018 Nicholas Arduini. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var leftTapCircle = SKSpriteNode()
    private var middleTapCircle = SKSpriteNode()
    private var rightTapCircle = SKSpriteNode()
    
    private var leftShapes = [SKSpriteNode]()
    private var middleShapes = [SKSpriteNode]()
    private var rightShapes = [SKSpriteNode]()
    
    private var scoreLabel = SKLabelNode()
    
    private final let startSpeedOfShapes = 1.5
    private final let startfreqOfShapes = 3.0
    private final let maxSpeedOfShapes = 0.85 //decreases to max speed
    private final let maxfreqOfShapes = 5.8 //increases to max speed
    private final let scoreTillMaxSpeed = 150.0 //since every other score is updated really 300
    
    private var speedOfShapes = 0.0
    private var freqOfShapes = 0.0
    private var totalScore = 0
    var ratio = CGFloat(0.0)
    
    func changeBackground(){
        let randomShapeSide = Int(arc4random_uniform(3))
        var color = SKColor()
        if(randomShapeSide == 0){
            color = SKColor.gameRedColor()
        } else if(randomShapeSide == 1){
            color = SKColor.gameGreenColor()
        } else {
            color = SKColor.gameBlueColor()
        }
        
        run(SKAction.colorize(with: color, colorBlendFactor: CGFloat(speedOfShapes), duration: speedOfShapes*2))
    }
    
    override func didMove(to view: SKView) {
        let w = (self.size.width) / 3.5
        let spacing = w/8
        ratio = ((frame.width)/(375))
        
        speedOfShapes = startSpeedOfShapes
        freqOfShapes = startfreqOfShapes
        
        leftTapCircle = SKSpriteNode(imageNamed: Common.TapCircleImage)
        addChild(leftTapCircle)
        leftTapCircle.position = CGPoint(x: spacing + w/2, y: size.height * 0.2)
        leftTapCircle.zPosition = 2
        leftTapCircle.size = CGSize(width: w, height: w)
        leftTapCircle.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.8)))
        
        middleTapCircle = SKSpriteNode(imageNamed: Common.TapCircleImage)
        addChild(middleTapCircle)
        middleTapCircle.position = CGPoint(x: size.width/2, y: size.height * 0.2)
        middleTapCircle.zPosition = 2
        middleTapCircle.size = CGSize(width: w, height: w)
        middleTapCircle.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(-Double.pi), duration: 0.8)))
        
        rightTapCircle = SKSpriteNode(imageNamed: Common.TapCircleImage)
        addChild(rightTapCircle)
        rightTapCircle.position = CGPoint(x: size.width - spacing - w/2, y: size.height * 0.2)
        rightTapCircle.zPosition = 2
        rightTapCircle.size = CGSize(width: w, height: w)
        rightTapCircle.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.8)))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addShape),
                SKAction.wait(forDuration: 1.0)
                ])
        ), withKey: Common.SpawingKey)
        
        if let action = action(forKey: Common.SpawingKey){
            action.speed = CGFloat(startfreqOfShapes)
        }
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(changeBackground),
                SKAction.wait(forDuration: 2.0)
                ])
        ))
        
        scoreLabel = SKLabelNode(fontNamed: Common.FuturaBoldFont)
        scoreLabel.fontSize = 60 * ratio
        scoreLabel.text = "0"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height * 0.85)
        addChild(scoreLabel)
    }
    
    @objc func addShape(){
        let w = (self.size.width + self.size.height) * 0.02
        let shape = SKSpriteNode(imageNamed: Common.Ball)
        shape.size = CGSize(width: w, height: w)
        shape.zPosition = 1
        
        let randomShapeSide = Int(arc4random_uniform(3))
        var removeShape = SKAction.init()
        var pos = CGPoint.init()
        if(randomShapeSide == 0){
            shape.position = CGPoint(x: size.width/2, y: size.height * 3/4)
            pos = CGPoint(x: leftTapCircle.position.x-10, y: leftTapCircle.position.y-40)
            leftShapes.append(shape)
            removeShape = SKAction.run {
                self.endGame()
                self.leftShapes.removeFirst()
            }
        } else if(randomShapeSide == 1){
            shape.position = CGPoint(x: size.width/2, y: size.height * 3/4)
            pos = CGPoint(x: middleTapCircle.position.x, y: middleTapCircle.position.y-40)
            middleShapes.append(shape)
            removeShape = SKAction.run {
                self.endGame()
                self.middleShapes.removeFirst()
            }
        } else {
            shape.position = CGPoint(x: size.width/2, y: size.height * 3/4)
            pos = CGPoint(x: rightTapCircle.position.x+10, y: rightTapCircle.position.y-40)
            rightShapes.append(shape)
            removeShape = SKAction.run {
                self.endGame()
                self.rightShapes.removeFirst()
            }
        }
        addChild(shape)
        
        shape.run(SKAction.scale(to: 2.5, duration: TimeInterval(speedOfShapes)))
        let actionMove = SKAction.move(to: pos, duration: TimeInterval(speedOfShapes))
        let waitAction = SKAction.wait(forDuration: 1.0)
        let actionMoveDone = SKAction.removeFromParent()
        
        shape.run(SKAction.sequence([actionMove, removeShape, waitAction, actionMoveDone]))
    }
    
    func updateScore(){
        if(totalScore > 0 && totalScore % 2 == 0){
            if(speedOfShapes > maxSpeedOfShapes){
                speedOfShapes -= (startSpeedOfShapes / scoreTillMaxSpeed)
            }
            if(freqOfShapes < maxfreqOfShapes){
                freqOfShapes += (maxfreqOfShapes / scoreTillMaxSpeed)
                if let action = action(forKey: Common.SpawingKey){
                    action.speed = CGFloat(freqOfShapes)
                }
            }
        }
        
        scoreLabel.text = "\(totalScore)"
        scoreLabel.run(SKAction.init(named: Common.Scale)!)
    }
    
    func endGame(){
        let scene = EndGameScene(size: (view?.bounds.size)!)
        scene.score = totalScore
        scene.scaleMode = SKSceneScaleMode.aspectFill
        view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.8))
    }
    
    func increaseRect(rect: CGRect, byPercentage percentage: CGFloat) -> CGRect {
        let startWidth = rect.width
        let startHeight = rect.height
        let adjustmentWidth = (startWidth * percentage) / 2.0
        let adjustmentHeight = (startHeight * percentage) / 2.0
        return rect.insetBy(dx: -adjustmentWidth, dy: -adjustmentHeight)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if(leftTapCircle.contains(pos)){
            leftTapCircle.run(SKAction.init(named: Common.Scale)!)
            if(leftShapes.isEmpty){return}
            let shapeFrame = increaseRect(rect: (leftShapes.first?.frame)!, byPercentage: 1.2)
            if(shapeFrame.contains((leftTapCircle.position))){
                leftShapes.first?.removeFromParent()
                leftShapes.removeFirst()
                totalScore += 1
                
            } else {
                if(totalScore > 0){
                    totalScore -= 1
                }
            }
            updateScore()
        } else if(middleTapCircle.contains(pos)){
            middleTapCircle.run(SKAction.init(named: Common.Scale)!)
            if(middleShapes.isEmpty){return}
            let shapeFrame = increaseRect(rect: (middleShapes.first?.frame)!, byPercentage: 1.2)
            if(shapeFrame.contains((middleTapCircle.position))){
                middleShapes.first?.removeFromParent()
                middleShapes.removeFirst()
                totalScore += 1
            } else {
                if(totalScore > 0){
                    totalScore -= 1
                }
            }
            updateScore()
        } else if(rightTapCircle.contains(pos)){
            rightTapCircle.run(SKAction.init(named: Common.Scale)!)
            if(rightShapes.isEmpty){return}
            let shapeFrame = increaseRect(rect: (rightShapes.first?.frame)!, byPercentage: 1.2)
            if(shapeFrame.contains((rightTapCircle.position))){
                rightShapes.first?.removeFromParent()
                rightShapes.removeFirst()
                totalScore += 1
            } else {
                if(totalScore > 0){
                    totalScore -= 1
                }
            }
            updateScore()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

