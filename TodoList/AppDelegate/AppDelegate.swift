//
//  AppDelegate.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/9.
//

import UIKit

func TDLLog<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line)
{
#if DEBUG
    let fileName = (file as NSString).lastPathComponent
    let date: Date = Date()
    let fileFormatter: DateFormatter = DateFormatter()
    fileFormatter.dateFormat = "HH:mm:ss"
    let time = fileFormatter.string(from: date)
    Swift.debugPrint("\(time) [\(fileName)] - \(messsage)")
#endif
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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

