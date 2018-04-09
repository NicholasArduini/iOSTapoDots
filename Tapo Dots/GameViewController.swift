//
//  GameViewController.swift
//  Tapo Dots
//
//  Created by Nicholas Arduini on 2018-02-03.
//  Copyright © 2018 Nicholas Arduini. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, GKGameCenterControllerDelegate {
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.purchasedGame), name: NSNotification.Name(rawValue: Common.PurchasedGame), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.openGameCenter), name: NSNotification.Name(rawValue: Common.OpenGameCenter), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.submitScore), name: NSNotification.Name(rawValue: Common.NewHighScore), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.loadAndShow), name: NSNotification.Name(rawValue: Common.LoadAndShowAd), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showAlert(_:)), name: NSNotification.Name(rawValue: Common.PresentAlert), object: nil)
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = Common.BannerUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
        
        authenticateLocalPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(isPurchased()){
            purchasedGame()
        }
    }
    
    @objc func loadAndShow() {
        if(!isPurchased()){
            interstitial = GADInterstitial(adUnitID: Common.InterstitialUnitID)
            let request = GADRequest()
            interstitial.delegate = self
            interstitial.load(request)
        }
    }
    
    func isPurchased() ->Bool{
        let save = UserDefaults.standard
        if((save.value(forKey: Common.PurchasedKey)) == nil){
            return false
        } else {
            return true
        }
    }
    
    @objc func purchasedGame(){
        if(bannerView != nil){
            bannerView.isHidden = true
            bannerView.alpha = 0
        }
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if (self.interstitial.isReady) {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Common.AdDissmissed), object: nil)
    }

    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                self.gcEnabled = true
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error ?? "")
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                self.gcEnabled = false
            }
        }
    }
    
    @objc func submitScore(_ notification: NSNotification){
        if let score = notification.userInfo?[Common.ScoreInfo] as? Int {
            let bestScoreInt = GKScore(leaderboardIdentifier: Common.leaderboardID)
            bestScoreInt.value = Int64(score)
            GKScore.report([bestScoreInt]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    @objc func openGameCenter(){
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = Common.leaderboardID
        present(gcVC, animated: true, completion: nil)
    }
    
    @objc func showAlert(_ notification: NSNotification){
        guard let title = notification.userInfo?[Common.TitleInfo] as? String else { return }
        guard let message = notification.userInfo?[Common.MessageInfo] as? String else { return }
        presentAlert(withMessage: message, title: title)
    }
    
    func presentAlert(withMessage: String, title: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: withMessage, preferredStyle: .alert)
            alert.view.tintColor = UIColor.blue
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.view.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
