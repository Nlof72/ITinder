//
//  Gradient.swift
//  ITinder
//
//  Created by Nikita on 26.04.2022.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {
 @IBInspectable var firstColor: UIColor = UIColor.clear {
   didSet {
       updateView()
    }
 }
 @IBInspectable var secondColor: UIColor = UIColor.clear {
    didSet {
        updateView()
    }
 }
    
 override class var layerClass: AnyClass {
    get {
        return CAGradientLayer.self
    }
 }
func updateView() {
    let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
    }
}

public extension Data {
    var fileExtension: String {
        var values = [UInt8](repeating:0, count:1)
        self.copyBytes(to: &values, count: 1)

        let ext: String
        switch (values[0]) {
        case 0xFF:
            ext = ".jpg"
        case 0x89:
            ext = ".png"
        case 0x47:
            ext = ".gif"
        case 0x49, 0x4D :
            ext = ".tiff"
        default:
            ext = ".png"
        }
        return ext
    }
}

