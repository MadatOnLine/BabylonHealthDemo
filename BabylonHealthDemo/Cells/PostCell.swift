//
//  PostCell.swift
//  BabylonHealthDemo
//
//  Created by Naeem Shaikh on 11/01/17.
//  Copyright © 2017 Naeem Shaikh. All rights reserved.
//

import UIKit
import Reusable

final class PostCell: UITableViewCell, NibReusable {
  @IBOutlet weak var postTitle: UILabel!
  @IBOutlet weak var postBody: UILabel!
  
  static func height() -> CGFloat {
    return 67
  }
  
  func setup(item: Post) {
    postTitle.text = item.title
    postBody.text = item.body
  }
}
