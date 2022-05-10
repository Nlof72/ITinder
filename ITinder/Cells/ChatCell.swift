//
//  ChatCell.swift
//  ITinder
//
//  Created by Nikita on 10.05.2022.
//

import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var UserIcon: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var LastMessage: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupChatCell(_ ChatData: ChatElement?){
        if let data = ChatData{
            if data.chat.title.count == 0{
                UserName.text = "Неизвестно"
            }else{
                UserName.text = data.chat.title
            }

            LastMessage.text = data.lastMessage?.text
            
            if let imageLink = data.chat.avatar{
                if let url = URL(string: imageLink){
                    if let data = try? Data(contentsOf: url) {
                        self.UserIcon.image = UIImage(data: data)
                    }
                }
            }else{
                self.UserIcon.image = UIImage(named: "ImagePlaceholder")
            }
            UserIcon.cornerRadius = 50
        }
    }
    
}
