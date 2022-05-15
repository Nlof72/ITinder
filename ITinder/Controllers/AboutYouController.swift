//
//  AboutYouController.swift
//  ITinder
//
//  Created by Nikita on 28.04.2022.
//

import UIKit
import PhotosUI

class AboutYouController: UIViewController {

    private let placeholder = "О себе"
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let tagsView = TagButtonView()
    
    @IBOutlet weak var Loading: UIView!
    @IBOutlet weak var UserNameField: MyTextField!
    @IBOutlet weak var AboutYouInfo: UITextView!
    @IBOutlet weak var UserImagePhoto: UIImageView!
    var UserImagePhotoHide: UIImageView = UIImageView()
    
    @IBOutlet weak var ChosePhotoButton: UIButton!
    @IBOutlet weak var LanguagesCategories: UIStackView!
    
    let userData = AppState.userData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AboutYouInfo.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        tabBarController?.tabBar.isHidden = true

        
        if let topics = AppState.topics{
            LanguagesCategories.addArrangedSubview(tagsView)

            tagsView.translatesAutoresizingMaskIntoConstraints = false
            
            tagsView.tagNames = topics
        }
        
        if let currentUserData = userData{
            UserNameField.text = currentUserData.name
            AboutYouInfo.text = currentUserData.aboutMyself
            
            if let imageLink = userData?.avatar{
                if let url = URL(string: imageLink){
                    if let data = try? Data(contentsOf: url) {
                        self.UserImagePhoto.image = UIImage(data: data)
                        UserImagePhotoHide.image = UserImagePhoto.image
                    }
                }
            }else{
                self.UserImagePhoto.image = UIImage(named: "ImagePlaceholder")
            }
            tagsView.setSelectedTags(currentUserData.topics)
        }
        
        UserImagePhoto.image = UserImagePhoto.image?.rounded(radius: 1000)
        
    }
    
    @IBAction func onButtonChosePhotoClick(_ sender: UIButton) {
        if UserImagePhotoHide.image != nil {
            UserImagePhoto.image = UIImage(named: "ImagePlaceholder")
            UserImagePhotoHide.image = nil
            self.ChosePhotoButton.setTitle("Выбрать фото", for: .normal)
            return
        }
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true )

    }
    
    @IBAction func onButtonSaveClick(_ sender: UIButton) {
        self.view.addSubview(self.Loading)
        
        if let image = UserImagePhoto.image {
            if let data = image.jpegData(compressionQuality: 0.5){
                userAction.updateUserAvatar(data)
            }
        }else{
            userAction.deleteUserAvatar()
        }

        userAction.updateUserProfile(name: UserNameField.text, aboutMyself: AboutYouInfo.text, topics: tagsView.getSelectedTopicsID()){
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "MainBar") as UIViewController
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
}

extension AboutYouController: UIImagePickerControllerDelegate, UINavigationControllerDelegate    {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            UserImagePhoto.image = image

        }
        
        UserImagePhoto.image = UserImagePhoto.image?.rounded(radius: 1000)
        UserImagePhotoHide.image = UserImagePhoto.image
        
        self.ChosePhotoButton.setTitle("Удалить фото", for: .normal)
        picker.dismiss(animated: true, completion: nil )
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil )
    }
}
