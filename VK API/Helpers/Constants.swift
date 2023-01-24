//
//  Constants.swift
//  VK API
//
//  Created by Егор Губанов on 28.09.2022.
//

import UIKit

struct Constants {
    static let appID        = "51436500"
    static let apiVersion   = "5.194"
    static let scheme       = "https"
    static let host         = "api.vk.com"
    static let authHost     = "oauth.vk.com"
    static let authPath     = "/authorize"
    static let methodPath   = "/method/"
    
    struct URI {
        static let redirectURI = URL(string: "https://oauth.vk.com/blank.html")!
    }
    
    struct Properties {
        static let userID = "user_id"
        static let accessToken = "access_token"
        static let version = "v"
    }
    
    struct Methods {
        static let wallGet = "wall.get"
        static let newsfeedGet = "newsfeed.get"
        static let usersGet = "users.get"
    }
    
    struct Colors {
        static let vkBlue = UIColor(rgb: 0x55749F)
        static let feedBackground = UIColor(named: "Feed Background")!
        static let lightGray = UIColor(named: "Light Gray")!
        static let cardViewColor = UIColor(named: "Card View")!
        static let bottomViewFontColor = UIColor(red: 155, green: 164, blue: 174)
    }
    
    struct Sizes {
        static let topViewHeight: CGFloat = 40
        static let bottomViewHeight: CGFloat = 30
        
        static let cardViewPadding: CGFloat = 5
        
        static let textPadding: CGFloat = 5
        static let bottomViewItemWidth = bottomViewHeight * 2.5
        static let bottomViewItemPadding: CGFloat = 3
        
        static let viewsPadding: CGFloat = 5

        static let maxPostTextHeight: CGFloat = 80
        static let heightOfSingleRow: CGFloat = {
            let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: CGFloat.greatestFiniteMagnitude))
            label.font = Constants.Fonts.postLabelFont
            label.numberOfLines = 0
            label.text = "Show more..."
            label.sizeToFit()
            return label.frame.height
        }()
    }
    
    struct Fonts {
        static let bottomViewFont = UIFont.systemFont(ofSize: 13, weight: .medium)
        static let topViewPublisherFront = UIFont.systemFont(ofSize: 15, weight: .medium)
        static let postLabelFont = UIFont.systemFont(ofSize: 15)
    }
    
    struct Images {
        static let publisherPlaceholder = UIImage(named: "PlaceholderImage")!
    }
}
