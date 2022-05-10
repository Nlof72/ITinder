//
//  UserAction.swift
//  ITinder
//
//  Created by Nikita on 27.04.2022.
//

import Foundation
import Alamofire

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
            getUserFeed()
            getAllChats()
            getPagedUserList(limit: AppState.limit, offset: AppState.offset)
            getTopics(){
                callback()
            }
//            headers["Authorization"] = data.accessToken
//            print("result we registred and got accessToken \(data.accessToken)")
        }
    }

    static func loginUser(email:String, password:String, callback: @escaping () -> Void){
        let parameters: [String: String] = [
            "email": email,
            "password": password,
        ]
        userApi.loginUser(parameters: parameters).validate().responseDecodable(of: TokenData.self){
            response in
            debugPrint(response)
            guard let data = response.value else { return }
            UserDefaults.standard.set(data.accessToken, forKey: "accessToken")
            getTopics()
            getPagedUserList(limit: AppState.limit, offset: AppState.offset	)
            getAllChats()
            getUserFeed(){
                getCurrentUserData(){
                    callback()
                }
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(password, forKey: "password")
            }
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
    
    static func updateUserProfile(name: String? = nil, aboutMyself: String? = nil, topics: [String] = [], callback: @escaping () -> Void = emptyCallback){
        
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
            callback()
            print(data)
        }
    }
    
    static func updateUserAvatar(_ avatar: Data){
        userApi.uploadUserAvatar(avatar: avatar)
    }
    
    static func deleteUserAvatar(){
        userApi.deleteUserAvatar()
    }
    
    static func getCurrentUserData(callback: @escaping () -> Void = emptyCallback){
        userApi.getCurrentUserProfile().validate().responseDecodable(of: UserData.self){
            response in
            guard let data = response.value else {return}
            AppState.userData = data
            callback()
            print(data)
        }
    }
    
    static func getUserFeed(callback: @escaping () -> Void = emptyCallback){
        userApi.getUserFeed().validate().responseDecodable(of: [UserData].self){
            response in
            guard let data = response.value else {return}
            AppState.userFeed = data
            callback()
            debugPrint(data)
        }
    }
    
    static func refuseUser(userId: String, callback: @escaping () -> Void = emptyCallback){
        userApi.refuseUser(userId: userId)
        callback()
    }
    
    static func likeUser(userId: String, callback: @escaping (_ isMatch: Bool) -> Void = emptyBoolCallback){
        userApi.likeUser(userId: userId).validate().responseDecodable(of: UserMatch.self){
            response in
            guard let data = response.value else {return}
            callback(data.isMutual)
        }
    }
    
    static func getPagedUserList(limit: Int, offset: Int, callback: @escaping ([UserData]) -> Void = emptyUserArrayCallback){
        let parameters: [String: Int] = [
            "limit": limit,
            "offset": offset,
        ]
        
        userApi.getUsersPagination(parameters: parameters).validate().responseDecodable(of:[UserData].self){
            response in
            guard let data = response.value else {return}
            AppState.userPagedList.append(contentsOf: data)
            callback(data)
        }
    }
    
    static func getAllChats(callback: @escaping () -> Void = emptyCallback){
        
        userApi.getAllMyChats().validate().responseDecodable(of: [ChatElement].self){
            response in
            debugPrint(response)
            guard let data = response.value else {return}
            UserChatsState.chats = data
            callback()
        }
    }
    
    static func createChat(_ userId: String, callback: @escaping () -> Void = emptyCallback){
        let parameters: [String: String] = [
            "userId": userId,
        ]
        
        userApi.createChatWitUser(parameters: parameters).validate().responseDecodable(of: ChatInfo.self){
            response in
            debugPrint(response)
            guard let data = response.value else {return}
            
            UserChatsState.chats.append(ChatElement(chat: data, lastMessage: nil))
            callback()
        }
    }
    
    static func getUserMessages(_ chatId: String, limit: Int, offset: Int, callback: @escaping () -> Void = emptyCallback){
        let parameters: [String: Int] = [
            "limit": limit,
            "offset": offset,
        ]
        
        userApi.getListOfMessagesForUser(chatId: chatId, parameters: parameters).validate().responseDecodable(of: [Message].self){
            response in
            guard let data = response.value else {return}
            
            UserChatsState.currentMessages.append(contentsOf: data)
        }
    }
    
    static func sendMessageToUser(_ chatId: String, messageText: String, attachments: [Data], callback: @escaping () -> Void = emptyCallback){
        let file = MultipartFormData()

        file.append(chatId.data(using: .utf8)!, withName: "messageText")
        
        if attachments.count > 0 {
            for element in attachments {
                file.append(element, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
            }
        }
        
        userApi.sendMessageForUser(chatId: chatId, parametrs: file).responseDecodable(of: Message.self){
            response in
            guard let data = response.value else {return}
            
            UserChatsState.currentMessages.append(data)
            callback()
        }
    }
}


func emptyCallback() {
    
}

func emptyBoolCallback(isMatch: Bool) {
    
}

func emptyUserArrayCallback(userData: [UserData]) {
    
}
