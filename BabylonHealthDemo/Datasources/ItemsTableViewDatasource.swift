//
//  ItemsTableViewDatasource.swift
//  BabylonHealthDemo
//
//  Created by Naeem Shaikh on 11/01/17.
//  Copyright © 2017 Naeem Shaikh. All rights reserved.
//

import UIKit

protocol ItemsTableViewDatasource: UITableViewDataSource {
  associatedtype T
  var items:[T] {get}
  weak var tableView: UITableView? { get }
  weak var delegate: UITableViewDelegate? { get }
  
  init(items: [T], tableView: UITableView, delegate: UITableViewDelegate)
  
  func setupTableView()
}

extension ItemsTableViewDatasource {
  func setupTableView() {
    self.tableView?.dataSource = self
    self.tableView?.delegate = self.delegate
    self.tableView?.reloadData()
  }
}
