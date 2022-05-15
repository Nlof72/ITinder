//
//  FlowController.swift
//  ITinder
//
//  Created by Nikita on 01.05.2022.
//

import UIKit

class FlowController: UIViewController {
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserTags: UIStackView!
    @IBOutlet weak var UserDescription: UITextView!
    @IBOutlet var MatchView: UIView!
    @IBOutlet weak var Loading: UIView!
    
    let userData = AppState.userFeed
    let tagsView = TagLabelView()
    var currentUserIndex = 0
    public var currentUserOutsid: UserData? = nil
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognize = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        UserImage.isUserInteractionEnabled = true
        UserImage.addGestureRecognizer(tapGestureRecognize)
        
        MatchView.removeFromSuperview()
        initUser(userData?[currentUserIndex])
        if currentUserOutsid != nil{
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    func initUser(_ user: UserData?){
        let currentUser: UserData?
        
        if let data = currentUserOutsid {
            currentUser = data
        }else{
            currentUser = user
        }
        
        if let imageLink = currentUser?.avatar{
            if let url = URL(string: imageLink){
                if let data = try? Data(contentsOf: url) {
                    self.UserImage.image = UIImage(data: data)
                }
            }else{
                self.UserImage.image = UIImage(named: "ImagePlaceholder")
            }
        }else{
            self.UserImage.image = UIImage(named: "ImagePlaceholder")
        }
        
//        UserImage.cornerRadius = 80
        
        if let userName = currentUser?.name{
            UserName.text = userName
        }else{
            UserName.text = "Без имени"
        }
        
        if let userDesc = currentUser?.aboutMyself{
            UserDescription.text = userDesc
        }else{
            UserDescription.text = "Информация отсутствует"
            
        }
        
        if let userTags = currentUser?.topics{
            UserTags.addArrangedSubview(tagsView)

            tagsView.translatesAutoresizingMaskIntoConstraints = false
            
            tagsView.tagNames = userTags
        }
    }
    

    @IBAction func onRefuseClick(_ sender: UIButton) {
        var id: String?
    
        if let outsideId = currentUserOutsid?.userId{
            id = outsideId
        }else{
            id = self.userData?[self.currentUserIndex].userId
        }

        if id != nil{
            userAction.refuseUser(userId: id!)
            if currentUserOutsid == nil {
                currentUserIndex = currentUserIndex + 1
                initUser(userData?[currentUserIndex])
            }
        }
        
    }
    
    @IBAction func onLikeClick(_ sender: UIButton) {
        
        //self.tabBarController?.view.addSubview(self.MatchView)

        self.Loading.frame.size.height = (self.navigationController?.view.bounds.height)!
        tabBarController?.tabBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        let id = self.userData?[self.currentUserIndex].userId
        debugPrint("99999999")
        debugPrint(id)
        if id != nil{
            self.view.addSubview(self.Loading)
            userAction.likeUser(userId: id!, errorCallBack: {
                self.Loading.removeFromSuperview()
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
            }){
                isMutual in
                self.Loading.removeFromSuperview()
                if isMutual{
                    if let tabBarController = self.tabBarController {
                        tabBarController.view.addSubview(self.MatchView)
                        self.MatchView.frame.size.height = (self.navigationController?.view.bounds.height)!
                    }
                }else{
                    self.tabBarController?.tabBar.isUserInteractionEnabled = true
                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                    if self.currentUserOutsid == nil{
                        self.currentUserIndex = self.currentUserIndex + 1
                        self.initUser(self.userData?[self.currentUserIndex])
                    }
                }
            }
        }
    }
    
    
    @IBAction func onWriteMessage(_ sender: UIButton) {
        var id: String?
        
        
        self.view.addSubview(self.Loading)
        self.Loading.frame.size.height = (self.navigationController?.view.bounds.height)!
        if let outsideId = currentUserOutsid?.userId{
            id = outsideId
        }else{
            id = self.userData?[self.currentUserIndex].userId
        }
        if let userId = id{
            debugPrint("-----====-----")
            userAction.createChat(userId){
                chat in
                let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "UserChat") as! UserChatController
                nextViewController.modalPresentationStyle = .fullScreen
                nextViewController.SelfChat = chat
                
                self.show(nextViewController, sender: self)
            }
        }
        

        MatchView.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "BigUser") as! BigUserController
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.currentUserData = self.userData?[self.currentUserIndex]
        nextViewController.hideTabBar()
        self.show(nextViewController, sender: self)
    }
}
