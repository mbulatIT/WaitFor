//
//  BaseView.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/19/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    open func setup() {}
    
    func clipViewToBounds(view: UIView) {
         let views: [String: Any] = ["view": view]
         let metrics = ["topMargin": 0, "leftMargin": 0, "rightMargin": 0, "bottomMargin": 0]

         // Setup left & right margins
         let horizontalConstraints = NSLayoutConstraint.constraints(
             withVisualFormat: "H:|-leftMargin-[view]-rightMargin-|",
             metrics: metrics,
             views: views
         )

         // Setup top & bottom margins
         let verticalConstraints = NSLayoutConstraint.constraints(
             withVisualFormat: "V:|-topMargin-[view]-bottomMargin-|",
             metrics: metrics,
             views: views
         )

         NSLayoutConstraint.activate(verticalConstraints)
         NSLayoutConstraint.activate(horizontalConstraints)
     }
}
