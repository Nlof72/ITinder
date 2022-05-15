//
//  Types.swift
//  ITinder
//
//  Created by Nikita on 27.04.2022.
//

import Foundation
import SwiftUI

struct TokenData: Decodable{
    let accessToken: String
    let accessTokenExpiredAt: String
    let refreshToken: String
    let refreshTokenExpiredAt: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case accessTokenExpiredAt
        case refreshToken
        case refreshTokenExpiredAt
      }
}

struct TopicData:Decodable{
    let id: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
      }
}


struct UserData:Decodable{
    let userId: String?
    let name: String?
    let aboutMyself: String?
    let avatar: String?
    let topics: [TopicData]
    
    enum CodingKeys: String, CodingKey {
        case userId
        case name
        case aboutMyself
        case avatar
        case topics
    }
}

struct UserMatch:Decodable{
    let isMutual: Bool
    
    enum CodingKeys: String, CodingKey{
        case isMutual
    }
}

struct ChatInfo:Decodable{
    let id: String
    let title: String
    let avatar: String?
}

struct UserChatInfo:Decodable{
    let userId: String
    let name: String
    let aboutMyself: String?
    let avatar: String?
}

struct Message:Decodable{
    let id: String
    let text: String?
    let createdAt: String
    let user: UserChatInfo
    let attachments: [String]
}

struct ChatElement: Decodable{
    let chat: ChatInfo
    let lastMessage: Message?
}
