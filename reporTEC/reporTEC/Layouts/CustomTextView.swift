//
//  CustomTextView.swift
//  reporTEC
//
//  Created by María Paula Anastas on 10/25/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextView: UITextView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

}
