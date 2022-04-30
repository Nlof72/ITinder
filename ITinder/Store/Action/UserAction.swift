//
//  UserAction.swift
//  ITinder
//
//  Created by Nikita on 27.04.2022.
//

import Foundation

struct userAction{
    static func registerUser(email:String, password:String, callback: @escaping () -> Void){
        
        let parameters: [String: String] = [
            "email": email,
            "password": password,
        ]
        
        userApi.registerUser(parameters: parameters).validate().responseDecodable(of: TokenData.self){
            response in
            guard let data = response.value else { return }
            UserDefaults.standard.set(data.accessToken, forKey: "accessToken")
            UserDefaults.standard.set(data.refreshToken, forKey: "refreshToken")
            getTopics(){
                callback()
            }
//            headers["Authorization"] = data.accessToken
//            print("result we registred and got accessToken \(data.accessToken)")
        }
    }

    static func loginUser(email:String, password:String){
        let parameters: [String: String] = [
            "email": email,
            "password": password,
        ]
        userApi.loginUser(parameters: parameters).validate().responseDecodable(of: TokenData.self){
            response in
            guard let data = response.value else { return }
            UserDefaults.standard.set(data.accessToken, forKey: "accessToken")
            getTopics()
//            headers["Authorization"] = data.accessToken
//            print("result we login and got accessToken \(data.accessToken)")
        }
    }


    static func logoutUser(){
        userApi.logoutUser()
    }

    static func refreshToken(){
        userApi.refreshToken().validate().responseDecodable(of: TokenData.self){
            response in
            guard let data = response.value else { return }
            headers["Authorization"] = data.accessToken
        }
    }
    
    static func getTopics(callback: @escaping () -> Void = emptyCallback){
        userApi.getTopics().validate().responseDecodable(of: [TopicData].self){
            response in
            guard let data = response.value else { return }
            AppState.topics = data
            callback()
        }
    }
    
    static func updateUserProfile(name: String? = nil, aboutMyself: String? = nil, topics: [String] = []){
        
        var parameters: [String: Any] = [:]
        if let na = name {
            parameters.updateValue(na, forKey: "name")
        }
        if let info = aboutMyself{
            parameters.updateValue(info, forKey: "aboutMyself")
        }
        
        if topics.count > 0 {
            parameters.updateValue(topics, forKey: "topics")
        }
        
        if parameters.isEmpty{
            return
        }
        
        userApi.updateProfile(parameters: parameters).validate().responseDecodable(of: UserData.self){
            response in
            guard let data = response.value else {return}
            AppState.userData = data
            print(data)
        }
    }
    
    static func updateUserAvatar(_ avatar: Data){
        userApi.uploadUserAvatar(avatar: avatar)
    }
    
    static func deleteUserAvatar(){
        userApi.deleteUserAvatar()
    }
}


func emptyCallback() {
    
}
