//
//  AppDelegate.swift
//  musicnow
//
//  Created by Quyen on 10/4/20.
//

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        YoutubeKit.shared.setAPIKey("AIzaSyCXd3M-Cb0KvyBMKTNS23nfaoiez6l51Go")
        PlayerManager.shared.Setup()
        //loadConfig()
        do
        {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
        }
        catch let error as NSError
        {
            print(error)
        }
        return true
    }
    
    func loadConfig() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent("data.json") {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    let channels = filePath.decode(FeautureChannelList.self)
                } else {
                    let channels = Bundle.main.decode(FeautureChannelList.self, from: "data.json")
                    
                }
            } else {
                let channels = Bundle.main.decode(FeautureChannelList.self, from: "data.json")
            }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

