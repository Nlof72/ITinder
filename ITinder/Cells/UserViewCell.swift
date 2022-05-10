//
//  UserViewCell.swift
//  ITinder
//
//  Created by Nikita on 04.05.2022.
//

import UIKit

class UserViewCell: UICollectionViewCell {
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    
    var cellUserData: UserData? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        UserImage.image = UIImage(named: "ImagePlaceholder")
        UserName.text = "Без имени"
    }
    
    func setupUserCell(_ userData: UserData?){

        if let imageLink = userData?.avatar{
            if let url = URL(string: imageLink){
                if let data = try? Data(contentsOf: url) {
                    self.UserImage.image = UIImage(data: data)
                }
            }
        }else{
            self.UserImage.image = UIImage(named: "ImagePlaceholder")
        }
        UserImage.cornerRadius = 60
        
        
        
        if let name = userData?.name{
            if name.count == 0{
                UserName.text = "Без имени"
            }else{
                UserName.text = name
            }
        }else{
            UserName.text = "Без имени"
            print("------------")
        }

        cellUserData = userData
    }

}
