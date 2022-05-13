//
//  UserChatController.swift
//  ITinder
//
//  Created by Nikita on 11.05.2022.
//

import UIKit

class UserChatController: UIViewController {

    @IBOutlet weak var Chat: UITableView!
    @IBOutlet weak var TextMessage: UITextField!
    public var ChatInfo: [Message] = []
    public var SelfChat: ChatInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        Chat.delegate = self
        Chat.dataSource = self
        Chat.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddMedia(_ sender: UIButton) {
        
    }
    
    @IBAction func SendMessage(_ sender: UIButton) {
        if let chatInfo = SelfChat{
            if let text = TextMessage.text{
                userAction.sendMessageToUser(chatInfo.id, messageText: text, attachments: [])
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}

extension UserChatController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint(UserChatsState.chats)
        return UserChatsState.currentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell = self.Chat.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        chatCell.setupMessageCell(UserChatsState.currentMessages[indexPath.item])
        return chatCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
