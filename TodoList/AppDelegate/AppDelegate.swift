//
//  AppDelegate.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/9.
//

import UIKit
import CoreData
import RealmSwift

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
        do {
            let realm = try Realm()
        } catch {
            TDLLog("Realm Error \(error)")
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
