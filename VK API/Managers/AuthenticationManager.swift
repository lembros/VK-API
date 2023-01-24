//
//  AuthenticationManager.swift
//  VK API
//
//  Created by Егор Губанов on 28.09.2022.
//

import Foundation
import SafariServices

@objc protocol AuthenticationManagerProtocol {
    @objc optional func didSignIn(succeed: Bool)
    @objc optional func didSignOut()
}

class AuthenticationManager: NSObject, WebAuthenticationViewControllerDelegate {
    
    var isSignedIn: Bool {
        self.token != nil
    }
    
    weak var delegate: AuthenticationManagerProtocol?
    
    //
    // MARK: - Computed properties
    //
    
    var token: String? {
        UserDefaults.standard.string(forKey: Constants.Properties.accessToken)
    }
    
    var userID: String? {
        UserDefaults.standard.string(forKey: Constants.Properties.userID)
    }
    
    //
    // MARK: - Public methods
    //
    
    func autheticate() -> UIViewController? {
        guard !isSignedIn else { return nil }
        guard let signInURL = getAuthURL() else { return nil }
        
        let webVC = WebAuthenticationViewController(url: signInURL)
        webVC.delegate = self
        return webVC
    }
    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: Constants.Properties.accessToken)
        UserDefaults.standard.removeObject(forKey: Constants.Properties.userID)
        delegate?.didSignOut?()
    }
    
    //
    // MARK: - Private methods
    //
    
    private func getAuthURL() -> URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.authHost
        components.path = Constants.authPath
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.appID),
            URLQueryItem(name: "redirect_uri", value: Constants.URI.redirectURI.absoluteString),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "scope", value: "offline,wall,friends"),
            URLQueryItem(name: "revoke", value: "1")
        ]
        
        return components.url
    }
  
    //
    // MARK: - WebAuthenticationViewControllerDelegate
    //
    
    func webAuthenticationViewController(_ viewController: UIViewController, serverRedirectedTo url: URL) {
        guard let urlString = url.absoluteString.removingPercentEncoding?.removingPercentEncoding, let url = URL(string: urlString) else { return }
        guard url.lastPathComponent == "auth_redirect" else { return }
        

        var components = URLComponents()
        components.query = URLComponents(url: url, resolvingAgainstBaseURL: false)?.fragment
        
        guard let queryItems = components.queryItems else { return }
        
        for item in queryItems {
            UserDefaults.standard.set(item.value, forKey: item.name)
            
            if item.name == "error" {
                delegate?.didSignIn?(succeed: false)
                return
            }
        }

        viewController.dismiss(animated: false) { [weak self] in
            self?.delegate?.didSignIn?(succeed: true)
        }
    }

    
}
