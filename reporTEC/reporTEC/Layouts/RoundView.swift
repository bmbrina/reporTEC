//
//  RoundView.swift
//  reporTEC
//
//  Created by María Paula Anastas on 10/25/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit

@IBDesignable
class RoundView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }

}
