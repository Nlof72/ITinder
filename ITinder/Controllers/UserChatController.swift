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
    @IBOutlet var Loading: UIView!
    public var ChatInfo: [Message] = []
    public var SelfChat: ChatInfo? = nil
    var userAttachment: UIImage? = nil
    
    var timer = Timer()

    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
          
    @objc func updateCounting(){
        if let id = SelfChat?.id{
            UserChatsState.currentMessages = []
            userAction.getUserMessages(id, limit: UserChatsState.limit, offset: UserChatsState.offset){
                NSLog("counting..")
                self.Chat.reloadData()
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduledTimerWithTimeInterval()
        
        tabBarController?.tabBar.isHidden = true
        
        Chat.delegate = self
        Chat.dataSource = self
        Chat.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        self.Chat.separatorStyle = UITableViewCell.SeparatorStyle.none
        Chat.transform = CGAffineTransform(scaleX: 1, y: -1)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddMedia(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true )
    }
    
    @IBAction func SendMessage(_ sender: UIButton) {
        self.view.addSubview(Loading)
        var attachmentDatas: [Data] = []
        if let chatInfo = SelfChat{
            if let text = TextMessage.text{
                if let data = userAttachment?.jpegData(compressionQuality: 0.5){
                    attachmentDatas.append(data)
                }
                userAction.sendMessageToUser(chatInfo.id, messageText: text, attachments: attachmentDatas){
                    self.Loading.removeFromSuperview()
                    self.Chat.reloadData()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserChatsState.currentMessages = []
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
        
        let currentMessage = UserChatsState.currentMessages[indexPath.item]
        chatCell.setupMessageCell(currentMessage)
        
        if currentMessage.user.userId == AppState.userData?.userId{
            chatCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        }else{
            chatCell.contentView.transform = CGAffineTransform(scaleX: -1, y: -1)
            chatCell.reverseCell()
        }
            

        return chatCell
    }
    

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 96
//    }
}

extension UserChatController: UIImagePickerControllerDelegate, UINavigationControllerDelegate    {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            userAttachment = image

        }
//        
//        UserImagePhoto.image = UserImagePhoto.image?.rounded(radius: 1000)
//        UserImagePhotoHide.image = UserImagePhoto.image
//        
//        self.ChosePhotoButton.setTitle("Удалить фото", for: .normal)
        picker.dismiss(animated: true, completion: nil )
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil )
    }
}
