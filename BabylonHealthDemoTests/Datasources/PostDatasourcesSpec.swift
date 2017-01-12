//
//  PostDatasourcesSpec.swift
//  BabylonHealthDemo
//
//  Created by Naeem Shaikh on 12/01/17.
//  Copyright © 2017 Naeem Shaikh. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import BabylonHealthDemo

class PostDatasourceSpec: QuickSpec {
  override func spec() {
    describe("PostDatasource") { 
      var controller: PostController!
      var post: BabylonHealthDemo.Post!
      
      beforeEach {
        let testBundle = Bundle(for: type(of: self))
        let mockLoader = MockLoader(file: "Post", in: testBundle)
        post = (mockLoader?.map(to: Post.self))!
      
        let apiMock = BabylonAPICallsMock(post: [post])
        controller = Storyboard.Main.postControllerScene.viewController() as! PostController
        controller.apiManager = apiMock
        
        //Load view components
        let _ = controller.view
      }
      
      it("should have a valid datasource") {
        expect(controller.tableDatasource).toNot(beNil())
      }
      
      it("should have a cell of expected type") {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = controller.tableDatasource!.tableView(controller.tableView, cellForRowAt: indexPath)
        expect(cell.isKind(of: PostCell.self)).to(beTruthy())
      }
      
      it("should have a configured cell") {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = controller.tableDatasource!.tableView(controller.tableView, cellForRowAt: indexPath) as! PostCell
        let name = cell.postTitle.text!
        expect(name).to(equal(post.title))
      }
      
      it("should have the right numberOfRowsInSection") {
        let count = controller.tableDatasource!.tableView(controller.tableView, numberOfRowsInSection: 0)
        expect(count).to(equal(1))
      }
    }
  }
}