//
//  UserChatController.swift
//  ITinder
//
//  Created by Nikita on 11.05.2022.
//

import UIKit

class UserChatController: UIViewController {

    @IBOutlet weak var TextMessage: UITextField!
    public var ChatInfo: [Message] = []
    public var SelfChat: ChatInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
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
