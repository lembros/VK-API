//
//  FeedModels.swift
//  VK API
//
//  Created by Егор Губанов on 01.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PostProtocol {
    var publisherName: String { get }
    var publisherImageURL: URL { get }
    
    var date: String { get }
    var text: String? { get }
    
    var showFullText: Bool? { get set }
    var foldedText: String? { get }
    
    var images: [ImageProtocol] { get }
    
    var likesCount: String { get }
    var commentsCount: String { get }
    var repostsCount: String { get }
    var viewsCount: String { get }
}

protocol ImageProtocol {
    var imageURL: String { get set }
    var imageSize: CGSize { get set }
}



enum Feed {
   
  enum Model {
    struct Request {
      enum RequestType {
          case loadFeedData
          case loadUserPicture
          case loadMoreFeedData(startFrom: String)
      }
    }
      
    struct Response {
      enum ResponseType {
          case error(_ error: Error)
          case loadedData(posts: [News], publishers: [PostSource], startFrom: String)
          case loadedMoreFeedData(posts: [News], publishers: [PostSource], startFrom: String)
          case userPictureURL(_ url: URL)
      }
    }
      
    struct ViewModel {
      enum ViewModelData {
          case errorAlert(_ alert: UIAlertController)
          case posts(_ posts: [PostProtocol], startFrom: String)
          case morePosts(_ posts: [PostProtocol], startFrom: String)
          case userPictureURL(_ url: URL)
      }
        
        struct Post: PostProtocol {
            var publisherName: String
            var publisherImageURL: URL
            var date: String
            
            var text: String?
            var images: [ImageProtocol]
            var showFullText: Bool?
            var foldedText: String?
            
            var likesCount: String
            var commentsCount: String
            var repostsCount: String
            var viewsCount: String
            
            struct Image: ImageProtocol {
                var imageURL: String
                var imageSize: CGSize
            }
        }


    }
  }
  
}


