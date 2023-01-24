//
//  ImageCell.swift
//  VK API
//
//  Created by Егор Губанов on 14.10.2022.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    static let reuseID = String(describing: ImageCell.self)
    
    private let postImageView: WebImageView = {
       let view = WebImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.lightGray
        view.layer.cornerRadius = Constants.Sizes.bottomViewHeight / 2
        view.clipsToBounds = true
        return view
    }()
    
    func setImage(_ image: ImageProtocol) {
        if let url = URL(string: image.imageURL) {
            postImageView.setImage(from: url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layerSetupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
    func layerSetupConstraints() {
        addSubview(postImageView)
        postImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        postImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        postImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        postImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
