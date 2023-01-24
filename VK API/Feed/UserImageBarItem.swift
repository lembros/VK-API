//
//  UserImageBarItem.swift
//  VK API
//
//  Created by Егор Губанов on 17.10.2022.
//

import UIKit

class UserImageView: UIView {
    
    let imageView: WebImageView = {
       let view = WebImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = Constants.Images.publisherPlaceholder
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 13).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
        imageView.layer.cornerRadius = frame.height / 2
    }
    
}
