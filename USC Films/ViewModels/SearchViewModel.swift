//
//  SearchViewModel.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/30.
//

import Foundation
import Alamofire
import SwiftyJSON

class SearchViewModel: ObservableObject {
    @Published var searchs = [Search]()
    func fetchData(text: String) {
        print("searchVM fetch data: " + text + String(text.count))
        if (text.count != 0) {
            searchs.removeAll()
            AF.request(url+"/1/" + text.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!, encoding: JSONEncoding.default).responseJSON { response14 in
                switch response14.result {
                case .success(let value14):
                    let json14 = JSON(value14)
                    for e in json14 {
                        self.searchs.append(Search(id: e.1["id"].intValue,
                                                   name: e.1["name"].stringValue,
                                                   backdrop_path: e.1["backdrop_path"].stringValue,
                                                   poster_path: e.1["poster_path"].stringValue,
                                                   media_type: e.1["media_type"].stringValue,
                                                   rating: e.1["rating"].doubleValue,
                                                   year: e.1["year"].stringValue))
                    }
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
}
