//
//  ProfileController.swift
//  ITinder
//
//  Created by Nikita on 30.04.2022.
//

import UIKit

class ProfileController: UIViewController {
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var UserTAgs: UIStackView!
    @IBOutlet weak var UserDescription: UITextView!

    let userData = AppState.userData
    let tagsView = TagLabelView()
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageLink = userData?.avatar{
            if let url = URL(string: imageLink){
                if let data = try? Data(contentsOf: url) {
                    self.ProfileImage.image = UIImage(data: data)
                }
            }else{
                self.ProfileImage.image = UIImage(named: "ImagePlaceholder")
            }
        }else{
            self.ProfileImage.image = UIImage(named: "ImagePlaceholder")
        }
        
        if let userName = userData?.name{
            NameLabel.text = userName
        }else{
            NameLabel.text = "Введите имя"
        }
        
        if let userDesc = userData?.aboutMyself{
            UserDescription.text = userDesc
        }else{
            UserDescription.text = "Расскажите о себе!"
            
        }
        
        if let userTags = userData?.topics{
            UserTAgs.addArrangedSubview(tagsView)

            tagsView.translatesAutoresizingMaskIntoConstraints = false
            
            tagsView.tagNames = userTags
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Профиль"
        backItem.tintColor = UIColor(red: 250/255, green: 19/255, blue: 171/255, alpha: 1)
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }

    @IBAction func OnEditClick(_ sender: UIButton) {
        let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "ProfileInfoEdit") as UIViewController
            nextViewController.modalPresentationStyle = .fullScreen
            self.show(nextViewController, sender: self)
    }
}
