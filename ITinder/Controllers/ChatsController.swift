//
//  ChatsController.swift
//  ITinder
//
//  Created by Nikita on 10.05.2022.
//

import UIKit

class ChatsController: UIViewController {
    @IBOutlet weak var Chats: UITableView!
    @IBOutlet weak var Loading: UIView!
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (tabBarController as! MainContainerController).Controllers.append(self)
        
        Chats.delegate = self
        Chats.dataSource = self
        Chats.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")

        // Do any additional setup after loading the view.
    }
    
    func reloadChat(){
        self.view.addSubview(self.Loading)
        self.Loading.frame.size.height = (self.navigationController?.view.bounds.height)!
        tabBarController?.tabBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        userAction.getAllChats(){
            self.Loading.removeFromSuperview()
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            self.Chats.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadChat()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.addSubview(self.Loading)
        self.Loading.frame.size.height = (self.navigationController?.view.bounds.height)!
        tabBarController?.tabBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        userAction.getUserMessages(UserChatsState.chats[indexPath.item].chat.id, limit: UserChatsState.limit, offset: UserChatsState.offset){
            data in 
            self.Loading.removeFromSuperview()
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "UserChat") as! UserChatController
                    nextViewController.modalPresentationStyle = .fullScreen
            nextViewController.ChatInfo = UserChatsState.currentMessages
            nextViewController.SelfChat = UserChatsState.chats[indexPath.item].chat
            self.show(nextViewController, sender: self)
        }
    }
}
