//
//  PlayerManager.swift
//  musicnow
//
//  Created by Quyen on 10/7/20.
//

import Foundation

protocol PlayerManagerDelegate {
    func playerTimmer(_ isRun: Bool, seconds: Int)
}

class PlayerManager: NSObject{
    
    /// Shared instance
    static let shared: PlayerManager = {
        return PlayerManager()
    }()
    var delegate: PlayerManagerDelegate?
    
    var seconds = 0
    var timer = Timer()
    var isTimerRunning = false
    static  let player = AudioPlayer()
    private var items: [AudioItem] = []
    
    public func Setup(){
//        playerVC = (UIStoryboard(name: "Player", bundle: nil).instantiateViewController(withIdentifier: "playerViewController") as! PlayerViewController)
//        NotificationCenter.default.addObserver(playerVC!, selector: #selector(MainViewController.play(_:)), name: NSNotification.Name(rawValue: "playvc"), object: nil)
//        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6885402663640641/3419803473")
//        interstitial.delegate = self
//        let request = GADRequest()
//        //request.testDevices = ["a1e468bba1feb82a28064160ae2591fb"]
//        interstitial.load(request)
//        interstitialAd = FBInterstitialAd(placementID: "661927758093283_661929838093075")
//        interstitialAd.delegate = self
//        interstitialAd.load()
    }
    
    func runTimer(_ timeSeconds: Int) {
        seconds = timeSeconds
        if isTimerRunning == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(updateTimer), userInfo: nil, repeats: true)
            isTimerRunning = true
        }
        
    }
    
    @objc func updateTimer() {
        
        if seconds < 1 {
            timer.invalidate()
            PlayerManager.player.pause()
            isTimerRunning = false
        } else {
            seconds -= 1
            print(seconds)
        }
        self.delegate?.playerTimmer(isTimerRunning, seconds: seconds)
    }
}

//extension PlayerManager: FBInterstitialAdDelegate{
//    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
//        print("interstitialAdDidLoad")
//    }
//    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
//        
//    }
//    
//    func interstitialAdDidClick(_ interstitialAd: FBInterstitialAd) {
//        
//    }
//    
//    func interstitialAdWillClose(_ interstitialAd: FBInterstitialAd) {
//        
//    }
//    
//    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
//}
//extension PlayerManager: GADInterstitialDelegate {
//    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
//      print("interstitialDidReceiveAd")
//    }
//
//    /// Tells the delegate an ad request failed.
//    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
//      print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
//        
//    }
//
//    /// Tells the delegate that an interstitial will be presented.
//    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
//      print("interstitialWillPresentScreen")
//    }
//
//    /// Tells the delegate the interstitial is to be animated off the screen.
//    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
//      print("interstitialWillDismissScreen")
//    }
//
//    /// Tells the delegate the interstitial had been animated off the screen.
//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//      print("interstitialDidDismissScreen")
//    }
//
//    /// Tells the delegate that a user click will open another app
//    /// (such as the App Store), backgrounding the current app.
//    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
//      print("interstitialWillLeaveApplication")
//    }
//}
