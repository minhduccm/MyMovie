//
//  ReachabilityManager.swift
//  MyMovie
//
//  Created by Duc Dinh on 10/16/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import Foundation
import ReachabilitySwift

protocol ReachabilityDelegate {
  func didReachableInternet()
  func didUnreachableInternet()
}

class ReachabilityManager {
  static var reachability = Reachability()!
  var reachibilityDelegate: ReachabilityDelegate!
  
  init() {
    NotificationCenter.default.addObserver(self, selector: #selector(ReachabilityManager.reachabilityChanged),name: ReachabilityChangedNotification,object: ReachabilityManager.reachability)
    do {
      try ReachabilityManager.reachability.startNotifier()
    } catch {
      print("could not start reachability notifier")
    }
  }
  
  @objc func reachabilityChanged(note: NSNotification) {
    let reachability = note.object as! Reachability
    
    if reachability.isReachable {
      if reachability.isReachableViaWiFi {
        print("Reachable via WiFi")
        reachibilityDelegate.didReachableInternet()
      } else {
        print("Reachable via Cellular")
        reachibilityDelegate.didReachableInternet()
      }
    } else {
      print("Network not reachable")
      reachibilityDelegate.didUnreachableInternet()
    }
  }
  
  func isUnreachable() -> Bool {
    return !ReachabilityManager.reachability.isReachable
  }
  
  func isReachable() -> Bool {
    return ReachabilityManager.reachability.isReachable
  }
  
  func isReachableViaWifi() -> Bool {
    return ReachabilityManager.reachability.isReachableViaWiFi
  }
  
  func isReachableViaWWAN() -> Bool {
    return ReachabilityManager.reachability.isReachableViaWWAN
  }
  
  func showNetworkProblemAlert(sender: AnyObject) {
    let alertController = UIAlertController(title: "Error", message:
      "Networ error", preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
    
    sender.present(alertController, animated: true, completion: nil)
  }
}
