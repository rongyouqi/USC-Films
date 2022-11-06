//
//  HomeViewModel.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/27.
//

import Foundation
import Alamofire
import SwiftyJSON

class HomeViewModel: ObservableObject {
    
    @Published var posts4 = [Post]()
    @Published var posts3 = [Post]()
    @Published var posts5 = [Post]()
    @Published var posts12 = [Post]()
    @Published var posts13 = [Post]()
    @Published var posts14 = [Post]()
    @Published var fetchComplete = false
    
    init() {
        // removeAll()
        AF.request(url+"/4", encoding: JSONEncoding.default).responseJSON { response4 in
            switch response4.result {
            case .success(let value4):
                let json4 = JSON(value4)
                for e in json4 {
                    self.posts4.append(Post(
                                        id: e.1["id"].intValue,
                                        name: e.1["name"].stringValue,
                                        year: e.1["year"].stringValue,
                                        poster_path: e.1["poster_path"].stringValue,
                                        media_type: e.1["media_type"].stringValue))
                }
                AF.request(url+"/3", encoding: JSONEncoding.default).responseJSON { response3 in
                    switch response3.result {
                    case .success(let value3):
                        let json3 = JSON(value3)
                        for e in json3 {
                            self.posts3.append(Post(
                                                id: e.1["id"].intValue,
                                                name: e.1["name"].stringValue,
                                                year: e.1["year"].stringValue,
                                                poster_path: e.1["poster_path"].stringValue,
                                                media_type: e.1["media_type"].stringValue))
                        }
                        AF.request(url+"/5", encoding: JSONEncoding.default).responseJSON { response5 in
                            switch response5.result {
                            case .success(let value5):
                                let json5 = JSON(value5)
                                for e in json5 {
                                    self.posts5.append(Post(
                                                        id: e.1["id"].intValue,
                                                        name: e.1["name"].stringValue,
                                                        year: e.1["year"].stringValue,
                                                        poster_path: e.1["poster_path"].stringValue,
                                                        media_type: e.1["media_type"].stringValue))
                                }
                                AF.request(url+"/12", encoding: JSONEncoding.default).responseJSON { response12 in
                                    switch response12.result {
                                    case .success(let value12):
                                        let json12 = JSON(value12)
                                        for e in json12 {
                                            self.posts12.append(Post(
                                                                id: e.1["id"].intValue,
                                                                name: e.1["name"].stringValue,
                                                                year: e.1["year"].stringValue,
                                                                poster_path: e.1["poster_path"].stringValue,
                                                                media_type: e.1["media_type"].stringValue))
                                        }
                                        AF.request(url+"/13", encoding: JSONEncoding.default).responseJSON { response13 in
                                            switch response13.result {
                                            case .success(let value13):
                                                let json13 = JSON(value13)
                                                for e in json13 {
                                                    self.posts13.append(Post(
                                                                        id: e.1["id"].intValue,
                                                                        name: e.1["name"].stringValue,
                                                                        year: e.1["year"].stringValue,
                                                                        poster_path: e.1["poster_path"].stringValue,
                                                                        media_type: e.1["media_type"].stringValue))
                                                }
                                                AF.request(url+"/14", encoding: JSONEncoding.default).responseJSON { response14 in
                                                    switch response14.result {
                                                    case .success(let value14):
                                                        let json14 = JSON(value14)
                                                        for e in json14 {
                                                            self.posts14.append(Post(
                                                                                id: e.1["id"].intValue,
                                                                                name: e.1["name"].stringValue,
                                                                                year: e.1["year"].stringValue,
                                                                                poster_path: e.1["poster_path"].stringValue,
                                                                                media_type: e.1["media_type"].stringValue))
                                                        }
                                                        self.fetchComplete = true
                                                    case .failure(let error):
                                                        debugPrint(error)
                                                    }
                                                }
                                            case .failure(let error):
                                                debugPrint(error)
                                            }
                                        }
                                    case .failure(let error):
                                        debugPrint(error)
                                    }
                                }
                            case .failure(let error):
                                debugPrint(error)
                            }
                        }
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
