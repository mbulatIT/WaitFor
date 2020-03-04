//
//  UILabelWithInset.swift
//  WaitFor
//
//  Created by Maksim Bulat on 23.02.2020.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

@IBDesignable
class LabelWithInset: UILabel {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
              self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 1 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable
    public var leadingInset: CGFloat = 5
    
    @IBInspectable
    public var masksToBounds: Bool = false {
        didSet {
            self.layer.masksToBounds = self.masksToBounds
        }
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: leadingInset, bottom: 0, right: 5)
        super.drawText(in: rect.inset(by: insets))
    }
}
