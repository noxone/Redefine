//
//  SpotifyConnector.swift
//  Redefine
//
//  Created by Olaf Neumann on 12.05.24.
//

import Foundation
import SpotifyiOS
import os.log

fileprivate let LOGGER = Logger(subsystem: "Redefine", category: "SpotifyConnector")

class SpotifyConnector : NSObject, SPTAppRemoteDelegate {
    static let shared = SpotifyConnector()

    private static let kAccessTokenKey = "access-token-key"

    private static let spotifyClientID = SPOTIFY_CLIENT_ID
    private static let spotifyRedirectURL = URL(string: "audio-book-redefine://spotify-login-callback")!
    
    var window: UIWindow?
    
    override private init() {}
    
    lazy var appRemote: SPTAppRemote = {
        let configuration = SPTConfiguration(clientID: SpotifyConnector.spotifyClientID, redirectURL: SpotifyConnector.spotifyRedirectURL)
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: SpotifyConnector.kAccessTokenKey)
        }
    }
    
    func handleOpenOf(url: URL?) {
        guard let url else {
            return
        }
        
        let parameters = appRemote.authorizationParameters(from: url);
        
        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = access_token
            self.accessToken = access_token
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            //playerViewController.showError(errorDescription)
            LOGGER.error("There is an error: \(errorDescription)")
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        handleOpenOf(url: URLContexts.first?.url)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        connect();
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        appRemote.disconnect()
    }
    
    func connect() {
        appRemote.connect()
    }
    
    // MARK: AppRemoteDelegate
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        LOGGER.debug("didEstablishConnection")
        //playerViewController.appRemoteConnected()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        LOGGER.debug("didFailConnectionAttemptWithError")
        //playerViewController.appRemoteDisconnect()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        LOGGER.debug("didDisconnectWithError")
        //playerViewController.appRemoteDisconnect()
    }
    
    /*var playerViewController: ViewController {
        get {
            let navController = self.window?.rootViewController?.children[0] as! UINavigationController
            return navController.topViewController as! ViewController
        }
    }*/
    
}
