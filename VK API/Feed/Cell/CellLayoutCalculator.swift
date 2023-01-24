//
//  CellLayoutCalculator.swift
//  VK API
//
//  Created by Егор Губанов on 11.10.2022.
//

import Foundation
import UIKit

protocol LayoutCalculatorProtocol: AnyObject {
    var screenSize: CGSize { get }
    
    func getCellSize(withPhotosOfSize photoSizes: [CGSize], andText text: String?, addingMoreButton: Bool) -> CGSize
    func textLabelHeight(_ text: String?) -> CGFloat?
}

class LayoutCalculator: LayoutCalculatorProtocol {
    let screenSize: CGSize
    
    var photoSize: CGSize?
    var photoSizes: [CGSize] = []
    var text: String?
    
    init(photoSizes: [CGSize] = [], screenSize: CGSize, text: String? = nil) {
        self.photoSizes = photoSizes
        self.screenSize = screenSize
        self.text = text
    }
    
    var cardViewWidth: CGFloat {
        screenSize.width - 2 * Constants.Sizes.cardViewPadding
    }
    
    var textLabelWidth: CGFloat {
        return cardViewWidth - 2 * Constants.Sizes.textPadding
    }
    
    var imageViewHeight: CGFloat? {
        guard photoSizes.isEmpty == false else { return nil }
        guard let maxWidthPhoto = photoSizes.max(by: { $0.height/$0.width > $1.height/$1.width }) else { return nil }
        let aspectRatio = maxWidthPhoto.height / maxWidthPhoto.width
        return aspectRatio * cardViewWidth
    }
    
    var labelHeight: CGFloat? {
        return text?.heightWithConstrainedWidth(width: textLabelWidth, font: Constants.Fonts.postLabelFont)
    }
    
    var postViewHeight: CGFloat {
        let labelHeight = labelHeight ?? 0
        let imageViewHeight = imageViewHeight ?? 0
        
        return labelHeight + Constants.Sizes.viewsPadding + imageViewHeight
    }
    
    func getCellSize(withPhotosOfSize photoSizes: [CGSize], andText text: String?, addingMoreButton: Bool) -> CGSize {
        self.photoSizes = photoSizes
        self.text = text
        
        let width = screenSize.width
        var height =    Constants.Sizes.cardViewPadding +
                        Constants.Sizes.viewsPadding +
                        Constants.Sizes.topViewHeight +
                        Constants.Sizes.viewsPadding +
                        postViewHeight +
                        Constants.Sizes.viewsPadding +
                        Constants.Sizes.bottomViewHeight +
                        Constants.Sizes.viewsPadding +
                        Constants.Sizes.cardViewPadding
        
        if addingMoreButton {
            height += Constants.Sizes.heightOfSingleRow            
        }
        
        return CGSize(width: width, height: height)
    }
    
    func textLabelHeight(_ text: String?) -> CGFloat? {
        self.text = text
        return labelHeight
    }
}
