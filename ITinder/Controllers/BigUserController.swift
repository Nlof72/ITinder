//
//  BigUserController.swift
//  ITinder
//
//  Created by Nikita on 13.05.2022.
//

import UIKit

class BigUserController: UIViewController {
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var AboutUser: UILabel!
    @IBOutlet weak var Tags: UIStackView!
    
    let tagsView = TagLabelView()
    public var currentUserData: UserData? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let link = currentUserData?.avatar{
            if let url = URL(string: link){
                if let data = try? Data(contentsOf: url) {
                    self.UserImage.image = UIImage(data: data)
                }
            }else{
                self.UserImage.image = UIImage(named: "ImagePlaceholder")
            }
        }else{
            self.UserImage.image = UIImage(named: "ImagePlaceholder")
        }
        
        UserName.text = currentUserData?.name
        
        AboutUser.text = currentUserData?.aboutMyself
        
        if let userTags = currentUserData?.topics{
            Tags.addArrangedSubview(tagsView)

            tagsView.translatesAutoresizingMaskIntoConstraints = false
            
            tagsView.tagNames = userTags
        }
        // Do any additional setup after loading the view.
    }
    
    func hideTabBar(){
        hidesBottomBarWhenPushed = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
}
