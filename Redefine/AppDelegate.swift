//
//  AppDelegate.swift
//  Redefine
//
//  Created by Olaf Neumann on 12.05.24.
//

import Foundation
import UIKit
import SpotifyiOS

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        SpotifyConnector.shared.handleOpenOf(url: url)
        return true
    }

}
