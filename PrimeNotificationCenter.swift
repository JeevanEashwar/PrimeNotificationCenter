
// Created by Jeevan Eashwar on 14/07/2023

import Foundation

/** A custom Notification center to handle local notifications in iOS
 - Storing the list of notifications and observers listening to each notification.
 - Adding any object as an listener to any notification.
 - Removing listeners.
 - Posting notifications.
 */
class PrimeNotificationCenter {
    static let shared = PrimeNotificationCenter()
    private init() {
        notificationsStorage = [:]
    }
    // Format of the dictionary `notificationsStorage` [ClassName: [NotificationName: Closure]]
    private var notificationsStorage: [String: [String: [(String, Any) -> Void]]]
    
    
    // Adding any object as an listener to any notification.
    func addObserver(_ _class: Any, name: String, closure: @escaping (String, Any) -> Void) {
        // 1
        guard let inputClass = type(of: _class) as? AnyClass else {
            return
        }
        let className = String(describing: inputClass)
        // 2
        if notificationsStorage[className] != nil && notificationsStorage[className]?[name] != nil {
            notificationsStorage[className]?[name]?.append(closure)
        } else {
            notificationsStorage[className] = [name: [closure]]
        }
    }
    
    // Removing listeners.
    func removeObserver(_ _class: Any) {
       guard let inputClass = type(of: _class) as? AnyClass else {
          return
       }
       let className = String(describing: inputClass)
       guard notificationsStorage[className] != nil else {
          print("Notification not found")
          return
       }
       notificationsStorage.removeValue(forKey: className)
     }
    
    // Post a notification
    func postNotification(_ name: String, object: Any) {
        for (_, notificationData) in notificationsStorage {
            for (notificationName, closures) in notificationData {
                guard notificationName == name else { continue }
                for closure in closures {
                    closure(name, object)
                }
            }
        }
    }
}


/**
 An example class to demonstrate the functionality of `PrimeNotificationCenter`
 */
class MobileListener {
    init() {}
    let notificationName: String = "Live score alerts" // Use same name for posting and listening to a notification

    func addSelfObserverToLiveScoresNotification() {
        let notificationCenter = PrimeNotificationCenter.shared
        notificationCenter.addObserver(self, name: notificationName) { (name, object) in
            let notificationReceivedSuccessMessage = "\(self.notificationName) notification closure"
            print(notificationReceivedSuccessMessage)
        }
    }
    
    func removeSelfAsObserverFromLiveScoresNotification() {
        let notificationCenter = PrimeNotificationCenter.shared
        notificationCenter.removeObserver(self)
    }
}

// Uncomment the following in a playground to test

// let listener1 = MobileListener()
// let notificationName: String = "Live score alerts" // Use same name for posting and listening to a notification
// listener1.addSelfObserverToLiveScoresNotification()
// PrimeNotificationCenter.shared.postNotification(notificationName, object: "Can be anything")
// listener1.removeSelfAsObserverFromLiveScoresNotification()
