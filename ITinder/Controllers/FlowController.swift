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
    
    let userData = AppState.userFeed
    let tagsView = TagLabelView()
    var currentUserIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MatchView.removeFromSuperview()
        initUser()
    }
    
    func initUser(){
        let currentUser = userData?[currentUserIndex]
        
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
        let id = self.userData?[self.currentUserIndex].userId
        if id != nil{
            userAction.refuseUser(userId: id!)
            currentUserIndex = currentUserIndex + 1
            initUser()
        }
        
    }
    
    @IBAction func onLikeClick(_ sender: UIButton) {
        //self.tabBarController?.view.addSubview(self.MatchView)
        let id = self.userData?[self.currentUserIndex].userId
        if id != nil{
            userAction.likeUser(userId: id!){
                isMutual in
                if isMutual{
                    if let tabBarController = self.tabBarController {
                        tabBarController.view.addSubview(self.MatchView)
                    }
                }else{
                    self.currentUserIndex = self.currentUserIndex + 1
                    self.initUser()
                }
            }
        }
    }
    
    
    @IBAction func onWriteMessage(_ sender: UIButton) {
        MatchView.removeFromSuperview()
    }
}
