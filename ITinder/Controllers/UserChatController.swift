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
            userAction.getUserMessages(id, limit: UserChatsState.limit, offset: UserChatsState.offset){
                data in
                UserChatsState.currentMessages = data
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
        
        if let avatar = SelfChat?.avatar{
            if let url = URL(string: avatar){
                if let data = try? Data(contentsOf: url) {
                    self.navigationItem.titleView = navTitleWithImageAndText(titleText: SelfChat?.title, imageData: data)
                }
            }
        }


        // Do any additional setup after loading the view.
    }
    
    func navTitleWithImageAndText(titleText: String?, imageData: Data) -> UIView {

        // Creates a new UIView
        let titleView = UIView()

        // Creates a new text label
        let label = UILabel()
        label.text = titleText
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center
        //label.font = label.font.withSize(18.0)

        // Creates the image view
        let image = UIImageView()
        image.image = UIImage(data: imageData)

        // Maintains the image's aspect ratio:
        let imageAspect = image.image!.size.width / image.image!.size.height

        // Sets the image frame so that it's immediately before the text:
        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect
        let imageY = label.frame.origin.y

        let imageWidth = label.frame.size.height * imageAspect
        let imageHeight = label.frame.size.height

        image.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)

        image.contentMode = UIView.ContentMode.scaleAspectFit
        
        image.cornerRadius = 10

        // Adds both the label and image view to the titleView
        titleView.addSubview(label)
        titleView.addSubview(image)

        // Sets the titleView frame to fit within the UINavigation Title
        titleView.sizeToFit()

        return titleView

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
                TextMessage.text = nil
                userAttachment = nil
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserChatsState.currentMessages = []
        timer.invalidate()
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
        
//        if indexPath.item > UserChatsState.currentMessages.count{
//            return
//        }
        debugPrint(indexPath)
        let currentMessage = UserChatsState.currentMessages[indexPath.item]
        chatCell.setupMessageCell(currentMessage)
        chatCell.selectionStyle = .none
        
        if currentMessage.user.userId == AppState.userData?.userId{
            chatCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        }else{
            chatCell.contentView.transform = CGAffineTransform(scaleX: -1, y: -1)
            chatCell.reverseCell()
        }
            

        return chatCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentItemNumber = indexPath.item
        let middleCountOfUser = (UserChatsState.currentMessages.count)/2
        guard let id = SelfChat?.id else {return}
        if currentItemNumber > middleCountOfUser{
            if UserChatsState.loading  || UserChatsState.allMessages{
                return
            }
            UserChatsState.loading = true
            userAction.getUserMessages(id,limit: UserChatsState.limit, offset: UserChatsState.offset + UserChatsState.limit){
                response in
                self.Chat.reloadData()
                if response.count < UserChatsState.limit {
                    UserChatsState.allMessages = true
                    UserChatsState.loading = false
                    return
                }
                UserChatsState.offset = UserChatsState.offset + UserChatsState.limit
                UserChatsState.loading = false
                debugPrint(response)
            }
        }
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
