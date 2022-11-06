//
//  TvDetailViewModel.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/27.
//

import Foundation
import Alamofire
import SwiftyJSON

class TvDetailViewModel: ObservableObject {
    @Published var fetchComplete = false
    @Published var key = [String]()
    @Published var detail = [Detail]()
    @Published var casts = [Cast]()
    @Published var reviews = [Review]()
    @Published var recommendations = [Post]()
    
    func fetchDetail(id: Int) {
        fetchComplete = false
        key.removeAll()
        detail.removeAll()
        casts.removeAll()
        reviews.removeAll()
        recommendations.removeAll()
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .medium
        formatter2.timeStyle = .none
        
        AF.request(url+"/15/"+String(id), encoding: JSONEncoding.default).responseJSON { response6 in
            switch response6.result {
            case .success(let value6):
                let json6 = JSON(value6)
                for e in json6 {
                    self.recommendations.append(Post(
                                        id: e.1["id"].intValue,
                                        name: e.1["name"].stringValue,
                                        year: e.1["year"].stringValue,
                                        poster_path: e.1["poster_path"].stringValue,
                                        media_type: e.1["media_type"].stringValue))
                }
                AF.request(url+"/17/"+String(id), encoding: JSONEncoding.default).responseJSON { response8 in
                    switch response8.result {
                    case .success(let value8):
                        let json8 = JSON(value8)
                        for e in json8 {
                            self.key.append(e.1["key"].stringValue)
                        }
                        AF.request(url+"/19/"+String(id), encoding: JSONEncoding.default).responseJSON { response10 in
                            switch response10.result {
                            case .success(let value10):
                                let json10 = JSON(value10)
                                for e in json10 {
                                    let date = formatter1.date(from: e.1["created_at"].stringValue)!
                                    let finalDate = formatter2.string(from: date)
                                    self.reviews.append(Review(
                                                            author: e.1["author"].stringValue,
                                                            content: e.1["content"].stringValue,
                                                            created_at: finalDate,
                                                            rating: e.1["rating"].doubleValue))
                                }
                                AF.request(url+"/20/"+String(id), encoding: JSONEncoding.default).responseJSON { response11 in
                                    switch response11.result {
                                    case .success(let value11):
                                        let json11 = JSON(value11)
                                        for e in json11 {
                                            self.casts.append(Cast(
                                                                name: e.1["name"].stringValue,
                                                                profile_path: e.1["profile_path"].stringValue))
                                        }
                                        AF.request(url+"/18/"+String(id), encoding: JSONEncoding.default).responseJSON { response9 in
                                            switch response9.result {
                                            case .success(let value9):
                                                let json9 = JSON(value9)
                                                self.detail.append(Detail(
                                                                    id: json9["id"].intValue,
                                                                    name: json9["name"].stringValue,
                                                                    genres: json9["genres"].stringValue,
                                                                    year: json9["year"].stringValue,
                                                                    overview: json9["overview"].stringValue,
                                                                    vote_average: json9["vote_average"].doubleValue,
                                                                    poster_path: json9["poster_path"].stringValue))
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
    }
}
