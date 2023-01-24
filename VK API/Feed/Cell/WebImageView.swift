//
//  WebImageView.swift
//  VK API
//
//  Created by Егор Губанов on 11.10.2022.
//

import UIKit

class WebImageView: UIImageView {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    func setImage(from url: URL) {
        networkManager.downloadData(from: url) { [weak self] data, error in
            guard
                let data = data,
                let image = UIImage(data: data),
                error == nil
            else { return }
            
            self?.image = image
        }
        
    }
}
