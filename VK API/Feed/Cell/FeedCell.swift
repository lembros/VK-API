//
//  FeedCell.swift
//  VK API
//
//  Created by Егор Губанов on 07.10.2022.
//

import UIKit

protocol FeedCellDelegate: AnyObject {
    func moreButtonPressed(_ cell: FeedCell)
}

class FeedCell: UITableViewCell {

    static let reuseID = String(describing: FeedCell.self)
    
    weak var delegate: FeedCellDelegate?
    var images: [ImageProtocol] = []
    
    //
    // MARK: - Interface elements
    //
    
    /// First layer
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.cardViewColor
        view.layer.cornerRadius = Constants.Sizes.bottomViewHeight / 2
        
        return view
    }()
    
    /// Second layer
    private let topView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let postView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Third layer
    /// TopView
    private let publisherImageView: WebImageView = {
       let view = WebImageView()
        view.backgroundColor = Constants.Colors.vkBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = (Constants.Sizes.topViewHeight) / 2
        view.clipsToBounds = true
        return view
    }()
    
    private let publisherNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Fonts.topViewPublisherFront
        label.text = "Placeholder publisher"
        return label
    }()
    
    private let publishDateLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10:09"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    ///BottomView
    private let likesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = Constants.Colors.lightGray
        view.layer.cornerRadius = Constants.Sizes.bottomViewHeight / 2
        
        return view
    }()

    private let commentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = Constants.Colors.lightGray
        view.layer.cornerRadius = Constants.Sizes.bottomViewHeight / 2
        return view
    }()
    
    private let sharesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.lightGray
        view.layer.cornerRadius = Constants.Sizes.bottomViewHeight / 2
        return view
    }()
    
    private let viewsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.lightGray
        view.layer.cornerRadius = Constants.Sizes.bottomViewHeight / 2
        return view
    }()
    
    /// Post View
    private let postTextLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Post text"
        label.numberOfLines = 0
        label.font = Constants.Fonts.postLabelFont
        return label
    }()
    
    private let moreTextButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Show more", for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = Constants.Fonts.postLabelFont
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.sizeToFit()
        return button
    }()
    
    
    private let postImagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        layout.scrollDirection = .horizontal
        view.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        return view
    }()
    
    /// Fourth layer
    // Likes
    private let likesImageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "like")
        return view
    }()
    
    private let likesLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Fonts.bottomViewFont
        label.textColor = Constants.Colors.bottomViewFontColor
        label.text = "123K"
        return label
    }()
    
    // Comments
    private let commentsImageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "comment")
        return view
    }()
    
    private let commentsLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Fonts.bottomViewFont
        label.textColor = Constants.Colors.bottomViewFontColor
        label.text = "123"
        return label
    }()
    
    // Shares
    private let sharesImageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "share")
        return view
    }()
    
    private let sharesLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Fonts.bottomViewFont
        label.textColor = Constants.Colors.bottomViewFontColor
        label.text = "15"
        
        return label
    }()
    
    // Views
    private let viewsImageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "eye")
        return view
    }()
    
    private let viewsLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Fonts.bottomViewFont
        label.textColor = Constants.Colors.bottomViewFontColor

        label.text = "523K"
        return label
    }()
    
    //
    // MARK: - Cell Lifecycle
    //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = Constants.Colors.feedBackground
        selectionStyle = .none
        
        moreTextButton.addTarget(self, action: #selector(moreTextPressed), for: .touchUpInside)
        contentView.isHidden = true
        
        postImagesCollectionView.dataSource = self
        postImagesCollectionView.delegate = self
        
        firstLayerSetupConstraints()
        secondLayerSetupConstraints()
        thirdLayerSetupConstraints()
        fourthLayerSetupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        publisherImageView.image = nil
        
        moreTextButton.isHidden = false
        setupMoreTextButton()

        images = []
    }
    
    //
    // MARK: - Interface Setup
    //
    
    func set(with post: PostProtocol) {
        // TopView
        publisherImageView.image = Constants.Images.publisherPlaceholder
        publisherImageView.setImage(from: post.publisherImageURL)
        publisherNameLabel.text = post.publisherName
        publishDateLabel.text = post.date
        
        // PostView
        postTextLabel.text = post.showFullText == true ? post.text : post.foldedText
        self.images = post.images
        postImagesCollectionView.reloadData()
        let addingButton = !(post.showFullText ?? true)
        if !addingButton {
            moreTextButton.isHidden = true
            setupMoreTextButton(height: 0)
        }
        
        
        // BottomView
        likesLabel.text = post.likesCount
        commentsLabel.text = post.commentsCount
        sharesLabel.text = post.repostsCount
        viewsLabel.text = post.viewsCount
        postTextLabel.sizeToFit()
    }
    
    // CardView on the cell
    private func firstLayerSetupConstraints() {
        addSubview(cardView)
        
        cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.Sizes.cardViewPadding).isActive = true
        cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.Sizes.cardViewPadding).isActive = true
        cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.Sizes.cardViewPadding).isActive = true
        cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.Sizes.cardViewPadding).isActive = true
    }
    
    // Intermediate views on the cardView
    private func secondLayerSetupConstraints() {
        cardView.addSubview(topView)
        cardView.addSubview(postView)
        cardView.addSubview(bottomView)
        
        topView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.Sizes.viewsPadding).isActive = true
        topView.widthAnchor.constraint(equalTo: cardView.widthAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: Constants.Sizes.topViewHeight).isActive = true
        
        bottomView.widthAnchor.constraint(equalTo: cardView.widthAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: Constants.Sizes.bottomViewHeight).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Constants.Sizes.viewsPadding).isActive = true
        
        postView.widthAnchor.constraint(equalTo: cardView.widthAnchor).isActive = true
        postView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: Constants.Sizes.viewsPadding).isActive = true
        postView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -Constants.Sizes.viewsPadding).isActive = true
    }

    // Interface elements
    private func thirdLayerSetupConstraints() {
        // TopView
        topView.addSubview(publisherImageView)
        publisherImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: Constants.Sizes.textPadding).isActive = true
        publisherImageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        publisherImageView.heightAnchor.constraint(equalTo: topView.heightAnchor).isActive = true
        publisherImageView.widthAnchor.constraint(equalToConstant: Constants.Sizes.topViewHeight).isActive = true

        topView.addSubview(publisherNameLabel)
        publisherNameLabel.leadingAnchor.constraint(equalTo: publisherImageView.trailingAnchor, constant: Constants.Sizes.textPadding).isActive = true
        publisherNameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -Constants.Sizes.textPadding).isActive = true
        publisherNameLabel.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        publisherNameLabel.bottomAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        
        topView.addSubview(publishDateLabel)
        publishDateLabel.leadingAnchor.constraint(equalTo: publisherImageView.trailingAnchor, constant: Constants.Sizes.textPadding).isActive = true
        publishDateLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -Constants.Sizes.textPadding).isActive = true
        publishDateLabel.topAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        publishDateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true

        // PostView
        postView.addSubview(postTextLabel)
        postTextLabel.topAnchor.constraint(equalTo: postView.topAnchor).isActive = true
        postTextLabel.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: Constants.Sizes.textPadding).isActive = true
        postTextLabel.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -Constants.Sizes.textPadding).isActive = true

        postView.addSubview(moreTextButton)
        moreTextButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor).isActive = true
        moreTextButton.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: Constants.Sizes.textPadding).isActive = true
        setupMoreTextButton()

        postView.addSubview(postImagesCollectionView)
        postImagesCollectionView.topAnchor.constraint(equalTo: moreTextButton.bottomAnchor, constant: Constants.Sizes.viewsPadding).isActive = true
        postImagesCollectionView.bottomAnchor.constraint(equalTo: postView.bottomAnchor).isActive = true
        postImagesCollectionView.widthAnchor.constraint(equalTo: postView.widthAnchor).isActive = true

        // BottomView
        bottomView.addSubview(likesView)
        likesView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Constants.Sizes.bottomViewItemPadding).isActive = true
        likesView.heightAnchor.constraint(equalToConstant: Constants.Sizes.bottomViewHeight).isActive = true
        
        bottomView.addSubview(commentsView)
        commentsView.leadingAnchor.constraint(equalTo: likesView.trailingAnchor, constant: Constants.Sizes.bottomViewItemPadding).isActive = true
        commentsView.heightAnchor.constraint(equalToConstant: Constants.Sizes.bottomViewHeight).isActive = true
        
        bottomView.addSubview(sharesView)
        sharesView.leadingAnchor.constraint(equalTo: commentsView.trailingAnchor, constant: Constants.Sizes.bottomViewItemPadding).isActive = true
        sharesView.heightAnchor.constraint(equalToConstant: Constants.Sizes.bottomViewHeight).isActive = true
        
        bottomView.addSubview(viewsView)
        viewsView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -Constants.Sizes.bottomViewItemPadding).isActive = true
        viewsView.heightAnchor.constraint(equalToConstant: Constants.Sizes.bottomViewHeight).isActive = true
    }
    
    private func setupMoreTextButton(height: CGFloat = Constants.Sizes.heightOfSingleRow) {
        let constraints = moreTextButton.constraints.filter { $0.firstAttribute == .height }
        moreTextButton.removeConstraints(constraints)
        
        moreTextButton.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    // BottomView elements
    private func fourthLayerSetupConstraints() {
        helpAdding(to: likesView,
                   label: likesLabel,
                   imageView: likesImageView)
        helpAdding(to: commentsView,
                   label: commentsLabel,
                   imageView: commentsImageView)
        helpAdding(to: sharesView,
                   label: sharesLabel,
                   imageView: sharesImageView)
        helpAdding(to: viewsView,
                   label: viewsLabel, imageView:
                    viewsImageView)

    }
    
    private func helpAdding(to view: UIView, label: UILabel, imageView: UIImageView) {
        guard let imageSize = imageView.image?.size else { return }
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        label.sizeToFit()
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3 * Constants.Sizes.bottomViewItemPadding).isActive = true
        label.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        imageView.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -Constants.Sizes.bottomViewItemPadding).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -3 * Constants.Sizes.bottomViewItemPadding).isActive = true
    }
    
    @objc func moreTextPressed() {
        delegate?.moreButtonPressed(self)
    }
}

extension FeedCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
        
        let image = images[indexPath.row]
        cell.setImage(image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = images[indexPath.row]
        let height = collectionView.frame.height
        let width = height * image.imageSize.width / image.imageSize.height
        collectionView.contentOffset = .zero
        return CGSize(width: width, height: height)
    }
}
