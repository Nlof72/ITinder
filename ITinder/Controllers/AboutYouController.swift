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
    let tagsView = TagLabelsView()
    
    @IBOutlet weak var UserNameField: MyTextField!
    @IBOutlet weak var AboutYouInfo: UITextView!
    @IBOutlet weak var UserImagePhoto: UIImageView!
    var UserImagePhotoHide: UIImageView = UIImageView()
    
    @IBOutlet weak var ChosePhotoButton: UIButton!
    @IBOutlet weak var LanguagesCategories: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AboutYouInfo.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        
        UserImagePhoto.image = UserImagePhoto.image?.rounded(radius: 20)
        
        if let topics = AppState.topics{
            LanguagesCategories.addArrangedSubview(tagsView)

            tagsView.translatesAutoresizingMaskIntoConstraints = false
            
            tagsView.tagNames = topics
        }
        
    }
    
    @IBAction func onButtonChosePhotoClick(_ sender: UIButton) {
        if UserImagePhotoHide.image != nil {
            userAction.deleteUserAvatar()
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
        userAction.updateUserProfile(name: UserNameField.text, aboutMyself: AboutYouInfo.text, topics: tagsView.getSelectedTopicsID())
        
        
        let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "MainBar") as UIViewController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated: false, completion: nil)
    }
    
    
}

extension AboutYouController: UIImagePickerControllerDelegate, UINavigationControllerDelegate    {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            UserImagePhoto.image = image
            
            print(image)
            
            if let data = image.jpegData(compressionQuality: 0.5){
                userAction.updateUserAvatar(data)
            }

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
