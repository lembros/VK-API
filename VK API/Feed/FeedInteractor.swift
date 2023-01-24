//
//  FeedInteractor.swift
//  VK API
//
//  Created by Егор Губанов on 01.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FeedBusinessLogic {
    func makeRequest(request: Feed.Model.Request.RequestType)
}

class FeedInteractor: FeedBusinessLogic {

    var presenter: FeedPresentationLogic?
    var service: FeedService?
    
    let networkManager: NetworkManagerProtocol = NetworkManager()
  
  func makeRequest(request: Feed.Model.Request.RequestType) {
      switch request {
      case .loadFeedData:
          loadPosts()
      case .loadUserPicture:
          loadUserPicture()
      case .loadMoreFeedData(startFrom: let startFrom):
          loadPosts(startFrom: startFrom)
      }
  }

    private func loadUserPicture() {
        guard let userID = UserDefaults.standard.string(forKey: Constants.Properties.userID) else { return }
        let parameters = ["fields" : "photo_50", "user_ids" : userID]
        
        networkManager.request(method: Constants.Methods.usersGet, parameters: parameters) { [weak self] data, error in
            
            guard
                error == nil,
                let data = data,
                let users = DataFetcher.parseData(data, of: UserResponseWrapped.self),
                let user = users.response.first,
                let url = URL(string: user.photo50)
            else { return }
            
            self?.presenter?.presentData(response: .userPictureURL(url))
        }
    }
    
    private func loadPosts(startFrom: String? = nil) {
        var parameters = ["count" : "50", "filters" : "post"]
        if let startFrom = startFrom {
            parameters["start_from"] = startFrom
        }
        
        networkManager.request(method: Constants.Methods.newsfeedGet, parameters: parameters) { [weak self] data, error in
            guard error == nil, let data = data else {
                self?.presenter?.presentData(response: .error(error!))
                return
            }
            guard let json = DataFetcher.parseData(data, of: ResponseWrapped.self) else { return }
            
            let publishers = (json.response.groups as [PostSource]) + (json.response.profiles as [PostSource])
            
            if let _ = startFrom {
                self?.presenter?.presentData(response: .loadedMoreFeedData(posts: json.response.news, publishers: publishers, startFrom: json.response.nextFrom))
            } else {
                self?.presenter?.presentData(response: .loadedData(posts: json.response.news, publishers: publishers, startFrom: json.response.nextFrom))
            }
        }
    }
  
}
