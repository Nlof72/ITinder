//
//  CustomTableView.swift
//  ITinder
//
//  Created by Nikita on 30.04.2022.
//

import Foundation
import UIKit

class TagLabelsView: UIView {
    
    var tagNames: [TopicData] = [] {
        didSet {
            addTagLabels()
        }
    }
    
    var selectedTags: [TopicData] = []
    
    let tagHeight:CGFloat = 30
    let tagPadding: CGFloat = 16
    let tagSpacingX: CGFloat = 8
    let tagSpacingY: CGFloat = 8

    var intrinsicHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() -> Void {
    }

    func addTagLabels() -> Void {
        
        // if we already have tag labels (or buttons, etc)
        //  remove any excess (e.g. we had 10 tags, new set is only 7)
        while self.subviews.count > tagNames.count {
            self.subviews[0].removeFromSuperview()
        }
        
        // if we don't have enough labels, create and add as needed
        while self.subviews.count < tagNames.count {

            // create a new label
            let newLabel = UIButton(type: .system, primaryAction: UIAction(title: "Button Title", handler: { action in
                let button = action.sender as! UIButton
                if let title = button.title(for: .normal) {
                    if(self.selectedTags.contains(where: {$0.title == title})){
                        button.backgroundColor = .cyan
                        let tag = self.tagNames.first(where: {$0.title == title})
                        if let data = tag {
                            self.selectedTags.removeAll(where: {$0.title == data.title})
                        }
                    }else{
                        button.backgroundColor = .red
                        let tag = self.tagNames.first(where: {$0.title == title})
                        if let data = tag {
                            self.selectedTags.append(data)
                        }
                    }

                    print("Button tapped!")
                }
            }))
            
            //newLabel.addTarget(newLabel.self, action: #selector(click), for: .touchUpInside)
            // set its properties (title, colors, corners, etc)
            //newLabel.textAlignment = .center
            newLabel.backgroundColor = UIColor.cyan
            newLabel.layer.masksToBounds = true
            newLabel.layer.cornerRadius = 8
            newLabel.layer.borderColor = UIColor.red.cgColor
            newLabel.layer.borderWidth = 1

            addSubview(newLabel)
            
        }

        // now loop through labels and set text and size
        for (str, v) in zip(tagNames, self.subviews) {
            guard let label = v as? UIButton else {
                fatalError("non-UILabel subview found!")
            }
            label.setTitle(str.title, for: .normal)
            label.frame.size.width = label.intrinsicContentSize.width + tagPadding
            label.frame.size.height = tagHeight
        }

    }
    
    @objc func click(sender: UIButton){
        sender.backgroundColor = UIColor.red
    }
    
    func displayTagLabels() {
        
        var currentOriginX: CGFloat = 0
        var currentOriginY: CGFloat = 0

        // for each label in the array
        self.subviews.forEach { v in
            
            guard let label = v as? UIButton else {
                fatalError("non-UILabel subview found!")
            }

            // if current X + label width will be greater than container view width
            //  "move to next row"
            if currentOriginX + label.frame.width > bounds.width {
                currentOriginX = 0
                currentOriginY += tagHeight + tagSpacingY
            }
            
            // set the btn frame origin
            label.frame.origin.x = currentOriginX
            label.frame.origin.y = currentOriginY
            
            // increment current X by btn width + spacing
            currentOriginX += label.frame.width + tagSpacingX
            
        }
        
        // update intrinsic height
        intrinsicHeight = currentOriginY + tagHeight
        invalidateIntrinsicContentSize()
        
    }

    // allow this view to set its own intrinsic height
    override var intrinsicContentSize: CGSize {
        var sz = super.intrinsicContentSize
        sz.height = intrinsicHeight
        return sz
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        displayTagLabels()
    }
    
    func getSelectedTopicsID() -> [String] {
        var Id:[String] = []
        for topic in selectedTags {
            Id.append(topic.id)
        }
        return Id
    }
    
}
