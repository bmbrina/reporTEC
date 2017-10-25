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

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.cornerRadius = 5
    }
}
