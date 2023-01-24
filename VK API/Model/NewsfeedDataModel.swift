//
//  NewsfeedDataModel.swift
//  VK API
//
//  Created by Егор Губанов on 29.09.2022.
//

import Foundation

struct ResponseWrapped: Decodable {
    let response: Response
}

struct Response: Decodable {
    let news: [News]
    let profiles: [Profile]
    let groups: [Group]
    let nextFrom: String
    
    enum CodingKeys: String, CodingKey {
        case news = "items"
        case profiles, groups, nextFrom
    }
}

protocol PostSource {
    var id: Int { get }
    var name: String { get }
    var photoURL: URL { get }
    
    var photo: Data? { get set }
}

struct Profile: Decodable, PostSource {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var photo: Data?
    
    var name: String {
        firstName + " " + lastName
    }
    
    var photoURL: URL {
        URL(string: photo100)!
    }
}

struct Group: Decodable, PostSource {
    let id: Int
    let name: String
    let photo100: String
    
    var photo: Data?
    
    var photoURL: URL {
        URL(string: photo100)!
    }
}

struct News: Decodable {
    let postID: Int
    let sourceID: Int
    let date: Double
    
    let text: String?
    let comments: CountableItem
    let likes: CountableItem
    let reposts: CountableItem
    let views: CountableItem
        
    let attachments: [Attachment]?
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "sourceId", postID = "postId"
        case date, text, comments, likes, reposts, views, attachments
    }
}

struct Attachment: Decodable {
    let type: String
    let photo: Photo?
}

struct Photo: Decodable {
    let sizes: [PhotoSize]
}

struct PhotoSize: Decodable {
    let height: Int
    let width: Int
    let type: String
    let url: String
}

struct CountableItem: Decodable {
    let count: Int
}

//
//
//

struct UserResponseWrapped: Decodable {
    let response: [User]
}

struct User: Decodable {
    let id: Int
    let photo50: String
    let firstName: String
    let lastName: String
}
