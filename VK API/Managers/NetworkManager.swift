//
//  NetworkManager.swift
//  VK API
//
//  Created by Егор Губанов on 29.09.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func request(method: String, parameters: [String: String], _ completion: ((Data?, Error?) -> Void)?)
    func downloadData(from url: URL, _ completion: ((Data?, Error?) -> Void)?)
}

class NetworkManager: NetworkManagerProtocol {

    let token: String = {
        guard
            let token = UserDefaults.standard.string(forKey: Constants.Properties.accessToken)
        else { fatalError("Did not sign in") }
        
        return token
    }()
    
    func downloadData(from url: URL, _ completion: ((Data?, Error?) -> Void)?) {
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        if let response = URLCache.shared.cachedResponse(for: request) {
            DispatchQueue.main.async {
                completion?(response.data, nil)
            }
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion?(data, error)
            }
        }
        
        task.resume()
    }
    
    
    func request(method: String, parameters: [String : String], _ completion: ((Data?, Error?) -> Void)?) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            guard let url = self.getMethodRequest(method: method, parameters: parameters) else { return }
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    completion?(data, error)
                }
            }

            task.resume()
        }
        

    }
    
    private func getMethodRequest(method: String, parameters: [String : String]) -> URL? {
        var components = URLComponents()
        
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.methodPath + method
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: Constants.Properties.accessToken, value: token),
            URLQueryItem(name: Constants.Properties.version, value: Constants.apiVersion)
        ])
        
        return components.url
    }
}
