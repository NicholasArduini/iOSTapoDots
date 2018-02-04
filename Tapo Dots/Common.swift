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
    
    //Google Ads
    static let AppID = "ca-app-pub-2495825697490692~7732834181"
    static let BannerUnitID = "ca-app-pub-3940256099942544/2934735716"
    static let InterstitialUnitID = "ca-app-pub-3940256099942544/4411468910"
    
    //SKActionKeys
    static let SpawingKey = "Spawning"
    
    //notification keys
    static let LoadAndShowAd = "LoadAndShowAd"
    
    //user default keys
    static let HighScoreKey = "HighScore"
    
    //assets
    static let TapCircleImage = "TapCircle"
    static let Ball = "Ball"
    static let Play = "Play"
    static let Retry = "Retry"
    
    //fonts
    static let FuturaMDITFont = "Futura-MediumItalic"
    static let FuturaCDMDFont = "Futura-CondensedMedium"
    static let FuturaBoldFont = "Futura-Bold"
    
    //actions
    static let Shake = "Shake"
    static let ScaleBig = "ScaleBig"
    static let Scale = "Scale"
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
