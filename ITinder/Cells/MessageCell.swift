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
        
        let dateFormatter = DateFormatter()

//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//
//        let updatedAtStr = "2016-06-05T16:56:57.019+01:00"
//        let updatedAt = dateFormatter.date(from: messageData.createdAt)
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: "2015-10-17T00:00:00.000Z")
        print("date: \(date!)")
        
        print("-------------")
        print(convertDateFormatter(messageData.createdAt))
        
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "yyyy-MM-dd"
//        print("-------------")
//        print(formatter.date(from: messageData.createdAt))
//        if let date = formatter.date(from: messageData.createdAt) {
//            formatter.locale = Locale(identifier: "en_US")
//            formatter.dateStyle = .long
//
//            MessageDate.text = formatter.string(from: date)
//
//        }
    }
    
    func convertDateFormatter(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)

        guard dateFormatter.date(from: date) != nil else {
//            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "yyyy MMM HH:mm EEEE"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let timeStamp = dateFormatter.string(from: convertedDate!)

        return timeStamp
    }
    
}
