//
//  ViewController.swift
//  VK API
//
//  Created by Егор Губанов on 28.09.2022.
//

import UIKit
import SafariServices

class AuthVC: UIViewController {
    
    let authManager = (UIApplication.shared.delegate as! AppDelegate).authManager
    
    //
    // MARK: - Interface elements
    //
    
    var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Text
        button.setTitle("Sign in VK", for: .normal)
        button.sizeToFit()
        
        // Color
        button.backgroundColor = .white
        button.tintColor = Constants.Colors.vkBlue
        
        // Shape
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            button.configuration = configuration
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
        
        button.layer.cornerRadius = button.frame.height / 3
        return button
    }()
    
    //
    // MARK: - ViewController Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawInterface()
        setupElements()
    }

    //
    // MARK: - @objc methods
    //
    
    @objc func signInPressed() {
        if authManager.isSignedIn {
            authManager.delegate?.didSignIn?(succeed: true)
            return
        }
        
        guard let signInVC = authManager.autheticate() else { print("no signInVC"); return }
        guard let navigationController = navigationController else { return }
        
        navigationController.pushViewController(signInVC, animated: true)
    }
    
    //
    // MARK: - Private methods
    //
    
    private func drawInterface() {
        view.backgroundColor = Constants.Colors.vkBlue
        view.addSubview(signInButton)
        
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupElements() {
        signInButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
    }
}
