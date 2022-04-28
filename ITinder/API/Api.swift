//
//  Api.swift
//  ITinder
//
//  Created by Nikita on 26.04.2022.
//

import Foundation
import Alamofire
var baseUrl = "http://193.233.85.238/itindr/api/mobile/v1/"

var	 headers: HTTPHeaders = [
    "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken")!)",
    "Accept": "application/json"
]

public struct userApi{
    static func registerUser(parameters: [String: String]) -> DataRequest{
        return AF.request("\(baseUrl)auth/register", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }

    static func loginUser(parameters: [String: String]) -> DataRequest{
        print(headers)
        return AF.request("\(baseUrl)auth/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }

    static func logoutUser(){
        AF.request("\(baseUrl)auth/logout", method: .delete, headers:headers).validate()
    }

    static func refreshToken() -> DataRequest{
        let parameters: [String: String] = [
            "refreshToken": headers["Authorization"]!
        ]
        return AF.request("\(baseUrl)auth/refresh", method: .delete, parameters: parameters, headers:headers)
    }
    
    static func getTopics() -> DataRequest{
        return AF.request("\(baseUrl)topic", method: .get, headers:headers)
    }
}
