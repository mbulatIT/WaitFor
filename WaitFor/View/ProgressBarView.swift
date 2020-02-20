//
//  ProgressBarView.swift
//  WaitFor
//
//  Created by Maksim Bulat on 17.02.2020.
//  Copyright © 2020 Maksim Bulat. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    private var strokes = [UIView]()
    var strokesCount: Int = 10 {
        didSet {
            updateBar()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        updateBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()
        updateBar()
    }

    func updateBar() {
        strokes.forEach({$0.removeFromSuperview()})
        let strokeWidth = self.frame.width / 1.5 / CGFloat(strokesCount)
        stackView.spacing = self.frame.width / 2 / CGFloat(strokesCount)
        let size = CGSize(width: strokeWidth, height: self.frame.height)
        for _ in 0...strokesCount {
            let view = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
            view.backgroundColor = .white
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            stackView.addArrangedSubview(view)
        }
    }
}
