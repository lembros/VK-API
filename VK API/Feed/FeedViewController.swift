//
//  FeedViewController.swift
//  VK API
//
//  Created by Егор Губанов on 01.10.2022.
//  Copyright (c) 2022 Goobanov. All rights reserved.
//

import UIKit

protocol FeedDisplayLogic: AnyObject {
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData)
    var layoutCalculator: LayoutCalculatorProtocol { get }
}

class FeedViewController: UIViewController, FeedDisplayLogic {

    var interactor: FeedBusinessLogic?
    var router: (NSObjectProtocol & FeedRoutingLogic)?
    let authManager = (UIApplication.shared.delegate as! AppDelegate).authManager
    
    var posts: [PostProtocol] = []
    var startFrom: String?
    var isLoading = false
    lazy var layoutCalculator: LayoutCalculatorProtocol = LayoutCalculator(screenSize: view.frame.size)
    
    // Table view
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Constants.Colors.feedBackground
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    let leftBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: Constants.Images.publisherPlaceholder, style: .plain, target: nil, action: nil)
        let height = Constants.Sizes.topViewHeight
        let customView = UserImageView(frame: CGRect(origin: .zero, size: CGSize(width: height, height: height)))
        item.customView = customView
        
        return item
    }()
    
    let refreshControl: UIRefreshControl = {
       let control = UIRefreshControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.userActivity?.title = "Pull to refresh"
        return control
    }()

  // MARK: - Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
  }
  
  // MARK: - Setup
  
    private func setup() {
        let viewController        = self
        let interactor            = FeedInteractor()
        let presenter             = FeedPresenter()
        let router                = FeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    private func drawInterface() {
        navigationItem.title = "Feed"
        view.backgroundColor = .systemBackground
        
        interactor?.makeRequest(request: .loadUserPicture)
        navigationItem.leftBarButtonItem = leftBarItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOutPressed))

        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        indicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }
    
    private func setupViewController() {
        view.addSubview(tableView)
        tableView.addSubview(indicator)

        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.prefetchDataSource = self
        tableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }

  
  // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        drawInterface()
        
        indicator.startAnimating()
        
        isLoading = true
        interactor?.makeRequest(request: .loadFeedData)
    }
  
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .errorAlert(let alert):
            present(alert, animated: true)
            indicator.stopAnimating()
        case .posts(let posts, let startFrom):
            self.posts = posts
            self.startFrom = startFrom
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.indicator.stopAnimating()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.isLoading = false
            }
        case .userPictureURL(let url):
            (leftBarItem.customView as! UserImageView).imageView.setImage(from: url)
        case .morePosts(let posts, let startFrom):
            print(#function)
            self.posts += posts
            self.startFrom = startFrom
            isLoading = false
            DispatchQueue.main.async { [weak tableView] in
                print("morePosts")
                guard let tableView = tableView else { return }
                let offset = tableView.contentOffset
                tableView.reloadData()
                tableView.contentOffset = offset
            }
        }
    }
  
    @objc private func signOutPressed() {
        authManager.signOut()
    }
    
    @objc private func pullToRefresh() {
        guard !isLoading else { return }
        interactor?.makeRequest(request: .loadFeedData)
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseID) as! FeedCell
        let post = posts[indexPath.row]
        
        cell.delegate = self
        cell.set(with: post)
                    
        return cell
    }

}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        let photoSizes = post.images.map { $0.imageSize }
        let text = post.showFullText == true ? post.text : post.foldedText
        
        let addingButton = !(post.showFullText ?? true)
        
        let cellSize = layoutCalculator.getCellSize(withPhotosOfSize: photoSizes, andText: text, addingMoreButton: addingButton)
        
        return cellSize.height
    }
}

/*
// Infinte scroll
extension FeedViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard
            let lastCellRow = indexPaths.max(by: { $0.row > $1.row })?.row,
            let startFrom = self.startFrom,
            !isLoading
        else { return }
        if lastCellRow + 10 > posts.count {
            isLoading = true
            //interactor?.makeRequest(request: .loadMoreFeedData(startFrom: startFrom))
        }
    }
}
*/
extension FeedViewController: FeedCellDelegate {
    func moreButtonPressed(_ cell: FeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        posts[indexPath.row].showFullText = true
        tableView.reloadData()
    }
}
