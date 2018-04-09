//
//  Common.swift
//  Tapo Dots
//
//  Created by Nicholas Arduini on 2018-02-01.
//  Copyright © 2018 Nicholas Arduini. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Common : SKScene{
    //strings
    static let TapoDots = "Tapo Dots"
    static let Best = "Best"
    
    //alerts
    static let Error = "Error"
    static let Success = "Success"
    static let EnableIAP = "Please enable In App Purchases"
    static let ProductNotFound = "Product not found"
    static let RestoreComplete = "Remove Ads Restore Complete"
    
    //Google Ads //TODO
    static let AppID = "ca-app-pub-2495825697490692~7732834181"
    static let BannerUnitID = "ca-app-pub-3940256099942544/2934735716" //testing
    static let InterstitialUnitID = "ca-app-pub-3940256099942544/4411468910" //testing
    
    //SKActionKeys
    static let SpawingKey = "Spawning"
    
    //notification keys
    static let LoadAndShowAd = "LoadAndShowAd"
    static let PurchasedGame = "PurchasedGame"
    static let OpenGameCenter = "OpenGameCenter"
    static let NewHighScore = "NewHighScore"
    static let PresentAlert = "PresentAlert"
    static let AdDissmissed = "AdDissmissed"
    
    //noificaions user info keys
    static let ScoreInfo = "scoreInfo"
    static let TitleInfo = "titleInfo"
    static let MessageInfo = "messageInfo"
    
    //user default keys
    static let HighScoreKey = "HighScore"
    static let PurchasedKey = "Purchased"
    
    //game center keys
    static let leaderboardID = "com.highscore.tapodots"
    
    //IAP Product IDS
    static let removeAdsPID = "RemoveAds"
    
    //assets
    static let TapCircleImage = "TapCircle"
    static let Ball = "Ball"
    static let Play = "Play"
    static let Retry = "Retry"
    static let GameCenter = "GameCenter"
    static let RemoveAds = "RemoveAds"
    static let Restore = "Restore"
    
    //music
    static let LoseWav = "Lose.wav"
    static let MissWav = "Miss.wav"
    static let MainGameWav = "MainGame.wav"
    static let IntroWav = "IntroMusic.wav"
    
    //fonts
    static let FuturaMDITFont = "Futura-MediumItalic"
    static let FuturaCDMDFont = "Futura-CondensedMedium"
    static let FuturaBoldFont = "Futura-Bold"
    
    //actions
    static let Shake = "Shake"
    static let ScaleBig = "ScaleBig"
    static let Scale = "Scale"
    
    //particle
    static let SparkParticle = "Spark.sks"
}

extension SKColor{
    class func gameGreenColor() -> SKColor{
        if #available(iOS 10.0, *) {
            return SKColor(displayP3Red: 75/255, green: 102/255, blue: 91/255, alpha: 1.0)
        } else {
            return SKColor(red: 75/255, green: 102/255, blue: 91/255, alpha: 1.0)
        }
    }
    class func gameRedColor() -> SKColor{
        if #available(iOS 10.0, *) {
            return SKColor(displayP3Red: 102/255, green: 75/255, blue: 88/255, alpha: 1.0)
        } else {
            return SKColor(red: 102/255, green: 75/255, blue: 88/255, alpha: 1.0)
        }
    }
    class func gameBlueColor() -> SKColor{
        if #available(iOS 10.0, *) {
            return SKColor(displayP3Red: 75/255, green: 83/255, blue: 102/255, alpha: 1.0)
        } else {
            return SKColor(red: 75/255, green: 83/255, blue: 102/255, alpha: 1.0)
        }
    }
    
}
