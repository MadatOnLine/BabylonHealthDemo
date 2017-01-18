//
//  PostController.swift
//  BabylonHealthDemo
//
//  Created by Naeem Shaikh on 11/01/17.
//  Copyright © 2017 Naeem Shaikh. All rights reserved.
//

import UIKit
import SVProgressHUD
import RealmSwift
import RxSwift

protocol PostsDelegate {
  func didSelectPost(at index: IndexPath)
}

final class PostController: UIViewController {
  var apiManager: BabylonAPICalls = BabylonAPIManger()
  var posts: [Post] = []
  
  var refreshControl = UIRefreshControl()
  var dateFormatter = DateFormatter()
  var lastUpdate = Date()
  
  var collectionDatasource: PostsDatasource?
  var collectionDelegate:   PostCollectionDelegate?
  @IBOutlet weak var collectionView: UICollectionView!
}

extension PostController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPullToRefresh()
    fetchSavePosts()
    if posts.isEmpty {
      fetchPosts()
    }
  }
}

extension PostController {
  func setupPullToRefresh() {
    // set up the refresh control
    setupDateFormatter()
    updatePullToRefresh()
    self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
    self.collectionView?.addSubview(refreshControl)
  }
  
  func setupDateFormatter() {
    // set up date format
    self.dateFormatter.dateStyle = .short
    self.dateFormatter.timeStyle = .long
  }
  
  func updatePullToRefresh() {
    // update "last updated" title for refresh control
    if let timeSaved = posts.first?.timeSaved {
      self.lastUpdate = timeSaved
    }
    let updateString = "Last Updated at " + self.dateFormatter.string(from: lastUpdate)
    self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
  }
  
  func dismissPullToRefresh() {
    // tell refresh control it can stop showing up now
    if self.refreshControl.isRefreshing {
      self.refreshControl.endRefreshing()
    }
  }
  
  func refresh(sender: AnyObject) {
    fetchPosts()
  }
}

extension PostController {
  func fetchPosts() {
    if CommonUtility.isConnected() {
      SVProgressHUD.show()
      apiManager.posts() { posts in
        SVProgressHUD.dismiss()
        self.dismissPullToRefresh()
        if let posts = posts {
          self.setupCollectionView(with: posts)
        }
      }
    } else {
      dismissPullToRefresh()
      CommonUtility.showNotConnected()
    }
  }
  
  func fetchSavePosts() {
    do {
      let realm = try Realm()
      let offlinePosts = realm.objects(Post.self)
      for offlinePost in offlinePosts {
        posts.append(offlinePost)
      }
      
      if !posts.isEmpty {
        self.setupCollectionView(with: posts)
      }
    } catch let error as NSError {
      CommonUtility.showError(error)
    }
  }
}

extension PostController {
  func setupCollectionView(with posts: [Post]) {
    self.updatePullToRefresh()
    collectionDelegate = PostCollectionDelegate(self)
    collectionDatasource = PostsDatasource(posts: posts,
                                           collectionView: self.collectionView,
                                           delegate: collectionDelegate!)
  }
}

extension PostController: PostsDelegate {
  func didSelectPost(at index: IndexPath) {
    guard let nextController = Storyboard.Main
      .postDetailControllerScene
      .viewController() as? PostDetailController else {
        return
    }
    
    let post = posts[index.row]
    nextController.post = post
    self.navigationController?.pushViewController(nextController,
                                                  animated: true)
  }
}
