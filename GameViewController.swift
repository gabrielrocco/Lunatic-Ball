//
//  GameViewController.swift
//  F.arrow
//
//  Created by Gabriel Rocco on 11/07/2018.
//  Copyright © 2018 GRDeveloper. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import GameKit
class GameViewController: UIViewController, GKGameCenterControllerDelegate, GADInterstitialDelegate {
    
    func createAndLoadInterstitial() -> GADInterstitial {
       var interstitial = GADInterstitial(adUnitID: "cac-app-pub-8409835855520197/5541073662")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true) {
              gameCenterViewController.removeFromParentViewController()
        }
      
    }
    

    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    

    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "com.score.lunaticball"
    
    
     @objc  func openGameCenter(){
    let gcVC = GKGameCenterViewController()
    gcVC.gameCenterDelegate = self
    gcVC.viewState = .leaderboards
    gcVC.leaderboardIdentifier = LEADERBOARD_ID
    present(gcVC, animated: true, completion: nil)
    }
    
    
    
    @objc  func uploadGameCenter(){
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(UserDefaults.standard.integer(forKey: "bestscoreSaved"))
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    
    
      @objc  func alphaSaveMe(){
            view.alpha = 0.99
    }
    
    @objc  func showInter(){
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        view.alpha = 0.99
 // UIScreen.main.brightness = 0.25
    }
    
    override func viewDidAppear(_ animated: Bool) {
  IAPService.shared.getProducts()
    }
    
     var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
 authenticateLocalPlayer()
        
        
        //Para os anuncios que vão aparecer a cada 3 jogos
       interstitial = createAndLoadInterstitial()
        let request = GADRequest()
        interstitial.load(request)
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
         
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                

                
                // Set the scale mode to scale to fit the windowß
                sceneNode.scaleMode = .resizeFill
                
                // Present the scene
                if let view = self.view as! SKView? {
   view.presentScene(sceneNode)
                    
               view.preferredFramesPerSecond = 60
                 
  //  view.showsDrawCount = true
                    view.ignoresSiblingOrder = true
   //  view.showsPhysics = true
    //view.showsFPS = true
       //         view.showsNodeCount = true
                }
            }
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
    

    
    override func viewWillLayoutSubviews() {
         if UserDefaults.standard.bool(forKey: "adsRemovedSaved") == false {
            
        NotificationCenter.default.addObserver(self, selector: #selector(self.startVideoAd), name: NSNotification.Name(rawValue: "showVideoRewardAd"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.showInter), name: NSNotification.Name(rawValue: "showInterObserver"), object: nil)
     
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.alphaSaveMe), name: NSNotification.Name(rawValue: "alphaSaveMeHE"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openGameCenter), name: NSNotification.Name(rawValue: "openGameCenterObserver"), object: nil)
        
          NotificationCenter.default.addObserver(self, selector: #selector(self.uploadGameCenter), name: NSNotification.Name(rawValue: "uploadGameCenterObserver"), object: nil)
        
     
        
    }
    
    
    
    
    @objc func startVideoAd() {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }

    

    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize the Google Mobile Ads SDK.
        // Sample AdMob app ID: INFO
  GADMobileAds.configure(withApplicationID: "INFO")
        return true
    }
    

    
    
    
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
  
  

   
    
    
    
    
    
}
