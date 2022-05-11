//
//  MessageCell.swift
//  ITinder
//
//  Created by Nikita on 11.05.2022.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var MessageText: UILabel!
    @IBOutlet weak var MessageDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupMessageCell(_ messageData: Message){
        if let imageLink = messageData.user.avatar{
            if let url = URL(string: imageLink){
                if let data = try? Data(contentsOf: url) {
                    self.UserImage.image = UIImage(data: data)
                }
            }
        }else{
            self.UserImage.image = UIImage(named: "ImagePlaceholder")
        }
        UserImage.cornerRadius = 50
        MessageText.text = messageData.text
        
        MessageDate.text = messageData.createdAt
    }
    
}
