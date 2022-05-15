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
    @IBOutlet weak var Attachment: UIImageView!
    
    @IBOutlet weak var MessageContent: UIStackView!
    
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
        UserImage.cornerRadius = 25
        MessageText.text = messageData.text
        
        if messageData.attachments.isEmpty{
            Attachment.isHidden = true
        }else{
            if let url = URL(string: messageData.attachments[0]){
                if let data = try? Data(contentsOf: url) {
                    self.Attachment.image = UIImage(data: data)
                }
            }
        }
        
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
        
        //addTopAndBottomBorders()
        
        MessageContent.layer.borderWidth = 1.5
        MessageContent.layer.borderColor = UIColor.gray.cgColor

        MessageContent.layer.cornerRadius = 10
        MessageContent.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func reverseCell(){
        MessageText.transform = CGAffineTransform(scaleX: -1, y: 1)
        MessageText.textAlignment = .right
        MessageDate.transform = CGAffineTransform(scaleX: -1, y: 1)
        MessageDate.textAlignment = .right
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
    
    override func layoutSubviews() {
        super.layoutSubviews()

        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        Attachment.isHidden = false
    }
    
    func addTopAndBottomBorders() {
        let thickness: CGFloat = 2.0
        let topBorder = CALayer()
        let bottomBorder = CALayer()
        let leftBorder = CALayer()
        let rightBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.MessageContent.frame.size.width, height: thickness)
        topBorder.backgroundColor = UIColor.red.cgColor
        bottomBorder.frame = CGRect(x:0, y: self.MessageContent.frame.size.height - thickness, width: self.MessageContent.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.red.cgColor
        MessageContent.layer.addSublayer(topBorder)
        MessageContent.layer.addSublayer(bottomBorder)
    }
}
