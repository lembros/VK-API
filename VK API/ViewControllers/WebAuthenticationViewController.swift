//
//  WebAuthenticationViewController.swift
//  VK API
//
//  Created by Егор Губанов on 17.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import WebKit


protocol WebAuthenticationViewControllerDelegate {
    func webAuthenticationViewController(_ viewController: UIViewController, serverRedirectedTo url: URL)
}

class WebAuthenticationViewController: UIViewController {

    let initialURL: URL
    var delegate: WebAuthenticationViewControllerDelegate?
    
    let webView: WKWebView = {        
        let view = WKWebView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    

    // MARK: Object lifecycle
    
    init(url: URL) {
        self.initialURL = url
        super.init(nibName: nil, bundle: nil)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: Setup

    private func setupInterface() {
        view.addSubview(webView)
        
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    

    // MARK: Routing



    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        navigationItem.title = "Authentication"
        view.backgroundColor = .systemBackground
        let request = URLRequest(url: initialURL)
        
        DispatchQueue.main.async {[weak webView] in
            webView?.load(request)
        }
    }

  
}

extension WebAuthenticationViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let url = webView.url {
            delegate?.webAuthenticationViewController(self, serverRedirectedTo: url)
        }
    }
}
