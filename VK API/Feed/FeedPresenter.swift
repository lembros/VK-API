//
//  FeedPresenter.swift
//  VK API
//
//  Created by Егор Губанов on 01.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FeedPresentationLogic {
    func presentData(response: Feed.Model.Response.ResponseType)
}

class FeedPresenter: FeedPresentationLogic {
    weak var viewController: FeedDisplayLogic?

    func presentData(response: Feed.Model.Response.ResponseType) {
        switch response {
        case .error(let error):
            let errorAlert = AlertConstructor.alert(withMessage: error.localizedDescription, andTitle: "Error loading data")
            viewController?.displayData(viewModel: .errorAlert(errorAlert))
        case .loadedData(let news, let publishers, let startFrom):
            let posts = prepareLoadedPosts(news, publishers)
            viewController?.displayData(viewModel: .posts(posts, startFrom: startFrom))
        case .userPictureURL(let url):
            viewController?.displayData(viewModel: .userPictureURL(url))
        case .loadedMoreFeedData(let news,let publishers, let startFrom):
            let posts = prepareLoadedPosts(news, publishers)
            viewController?.displayData(viewModel: .morePosts(posts, startFrom: startFrom))
        }
    }
    
    private func prepareLoadedPosts(_ news: [News], _ publishers: [PostSource]) -> [PostProtocol] {
        let posts = news.compactMap { news -> PostProtocol? in
            
            let publisher = publishers.first { $0.id == abs(news.sourceID) }
            guard let publisher = publisher else { return nil }
            
            let date = formatDate(news.date)
            let images = getURLsAndSizes(from: news)
            
            let foldedText = foldText(news.text)

            var post = Feed.Model.ViewModel.Post(publisherName: publisher.name,
                            publisherImageURL: publisher.photoURL,
                            date: date,
                            text: news.text,
                            images: images,
                            foldedText: foldedText,
                            likesCount: format(countableItem: news.likes),
                            commentsCount: format(countableItem: news.comments),
                            repostsCount: format(countableItem: news.reposts),
                            viewsCount: format(countableItem: news.views))
            
            if foldedText?.count != news.text?.count {
                post.showFullText = false
            }
            
            return post
        }
        
        return posts
    }
    
    private func format(countableItem item: CountableItem) -> String {
        if item.count < 1000 {
            return String(item.count)
        }
        let count = item.count / 100
        let stringRepresentation = String(Double(count) / 2) + "K"
        
        return stringRepresentation
    }
    
    private func formatDate(_ date: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM 'в' HH:mm"
        
        let date = Date(timeIntervalSince1970: date)
        return dateFormatter.string(from: date)
    }
    
    private func getURLsAndSizes(from post: News) -> [ImageProtocol] {
        guard let attachments = post.attachments else { return [] }
        let images = attachments.compactMap({ attachment -> ImageProtocol? in
            guard
                attachment.type == "photo",
                let photo = attachment.photo
            else { return nil }
            
            let size = photo.sizes.first { size in
                size.type == "y"
            }
            
            let sizeToReturn = size ?? photo.sizes.last
            guard let sizeToReturn = sizeToReturn else { return nil }
            
            return Feed.Model.ViewModel.Post.Image(imageURL: sizeToReturn.url, imageSize: CGSize(width: sizeToReturn.width, height: sizeToReturn.height))
        })
    
        return images
        
    }
    
    private func foldText(_ text: String?) -> String? {
        guard var folded = text else { return nil }
        
        while (viewController?.layoutCalculator.textLabelHeight(folded + "...") ?? 0) > Constants.Sizes.maxPostTextHeight {
            folded = String(folded.dropLast())
        }
        
        return (text! == folded) ? folded : folded + "..."
    }

}
