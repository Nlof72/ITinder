//
//  Store.swift
//  ITinder
//
//  Created by Nikita on 27.04.2022.
//

import Foundation

struct AppState {
    static var topics: [TopicData]? = nil
    static var userData: UserData? = nil
    static var userFeed: [UserData]? = nil
    static var userPagedList: [UserData] = []
    static var limit = 60
    static var offset = 0
    static var loading = false
    static var allUsers = false
}

struct UserChatsState{
    static var chats: [ChatElement] = []
    static var currentMessages: [Message] = []
    static var limit = 60
    static var offset = 0
}


let TestUser: [UserData] = [
    UserData(userId: "asdasd", name: "sadzxc", aboutMyself: "dsadasd", avatar: "asdasd", topics: []),
    UserData(userId: "asdasd", name: "sadzxc", aboutMyself: "dsadasd", avatar: "asdasd", topics: [])
]
