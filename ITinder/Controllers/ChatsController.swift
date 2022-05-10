//
//  ChatsController.swift
//  ITinder
//
//  Created by Nikita on 10.05.2022.
//

import UIKit

class ChatsController: UIViewController {
    @IBOutlet weak var Chats: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Chats.delegate = self
        Chats.dataSource = self
        Chats.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        // Do any additional setup after loading the view.
    }
}


extension ChatsController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint(UserChatsState.chats)
        return UserChatsState.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell = self.Chats.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        chatCell.setupChatCell(UserChatsState.chats[indexPath.item])
        return chatCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
