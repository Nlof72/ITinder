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
    
    static func updateProfile(parameters: [String: Any]) -> DataRequest{
        return AF.request("\(baseUrl)profile", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    }
    
    static func uploadUserAvatar(avatar: Data){
        let localheaders: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken")!)",
            "Accept": "multipart/form-data"
        ]
        
        let file = MultipartFormData()
        file.append(avatar, withName: "avatar", fileName: "avatar.jpeg", mimeType: "image/jpeg")
        
        debugPrint(file)
        
        AF.upload(multipartFormData: file,to: "\(baseUrl)profile/avatar", method: .post, headers: localheaders).responseJSON(){
            response in
            debugPrint(response)
        }
        //AF.upload(file, to: "\(baseUrl)profile/avatar", method: .post, headers: localheaders)
//        AF.request("\(baseUrl)profile/avatar", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: localheaders).validate()
    }
    
    static func deleteUserAvatar(){
        AF.request("\(baseUrl)profile/avatar", method: .delete, headers: headers).validate()
    }
    
    static func getCurrentUserProfile() -> DataRequest{
        return AF.request("\(baseUrl)profile", method: .get, headers:headers)
    }
    
    static func getUserFeed() -> DataRequest{
        return AF.request("\(baseUrl)user/feed", method: .get, headers: headers)
    }
    
    static func refuseUser(userId: String){
        AF.request("\(baseUrl)user/\(userId)/dislike", method: .post, headers: headers).responseJSON(){
            response in
            debugPrint(response)
        }
    }
    
    static func likeUser(userId: String) -> DataRequest{
        return AF.request("\(baseUrl)user/\(userId)/like", method: .post, headers: headers)
    }
    
    static func getUsersPagination(parameters: [String: Int]) -> DataRequest{
        debugPrint(parameters)
        return AF.request("\(baseUrl)user", method: .get, parameters: parameters ,headers: headers)
    }
    
    static func getAllMyChats() -> DataRequest{
        return AF.request("\(baseUrl)chat", method: .get, headers: headers)
    }
    
    static func createChatWitUser(parameters: [String: String]) -> DataRequest{
        return AF.request("\(baseUrl)chat", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    }
    
    static func getListOfMessagesForUser(chatId: String, parameters: [String: Int]) -> DataRequest{
        return AF.request("\(baseUrl)chat/\(chatId)/message", method: .get, parameters: parameters, headers: headers)
    }
    
    static func sendMessageForUser(chatId: String, parametrs:  MultipartFormData) -> UploadRequest{
        let localheaders: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken")!)",
            "Accept": "multipart/form-data"
        ]
        
        debugPrint(parametrs)
        
        return AF.upload(multipartFormData: parametrs,to: "\(baseUrl)chat/\(chatId)/message", method: .post, headers: localheaders)
    }
}
