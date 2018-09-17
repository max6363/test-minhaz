//
//  AppServerInfo.swift
//  test-project-minhaz
//
//  Created by Minhaz on 16/09/18.
//

import Foundation
import Alamofire

// Base URL (DEVELOPMENT)
let BaseUrl = "http://localhost:8080/"

// Base URL (PRODUCTION) // Enter production Url & Run the project
//let BaseUrl = "http://localhost:8080/"

// Delivery Items
let DeliveryItems = "deliveries"

// Get URL for all deliveries with give "offset" & "limit"
func getURLForAllDeliveries(offset: Int, limit: Int) -> String {
    let urlString = BaseUrl + DeliveryItems + "?offset=\(offset)" + "&limit=\(limit)"
    return urlString
}

class APIData: NSObject {
    
    var tag : Int = 0
    var isLoadMore : Bool = false
    var delegate : APIDataDelegate?
    
    func getAllDeliveriesWithOffset(_ offset: Int, limit: Int) {
        let myURLString = getURLForAllDeliveries(offset: offset, limit: limit)
        let url = URL(string: myURLString)!
        let urlRequest = URLRequest(url: url)
        Alamofire.request(urlRequest)
            .responseJSON { response in
                DispatchQueue.main.async {                 
                    self.delegate?.didReceiveResponse(response: response, api_object: self)
                }
        }
    }
}

protocol APIDataDelegate {
    func didReceiveResponse(response: DataResponse<Any>, api_object: APIData)
}

