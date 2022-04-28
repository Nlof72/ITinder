//
//  UserAction.swift
//  ITinder
//
//  Created by Nikita on 27.04.2022.
//

import Foundation

struct userAction{
    static func registerUser(email:String, password:String){
        
        let parameters: [String: String] = [
            "email": email,
            "password": password,
        ]
        
        userApi.registerUser(parameters: parameters).validate().responseDecodable(of: TokenData.self){
            response in
            guard let data = response.value else { return }
            UserDefaults.standard.set(data.accessToken, forKey: "accessToken")
            UserDefaults.standard.set(data.refreshToken, forKey: "refreshToken")
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
    
    static func getTopics(){
        userApi.getTopics().validate().responseDecodable(of: [TopicData].self){
            response in
            guard let data = response.value else { return }
            AppState.topics = data
        }
    }
}
