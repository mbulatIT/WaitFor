//
//  ProgressBarView.swift
//  WaitFor
//
//  Created by Maksim Bulat on 17.02.2020.
//  Copyright © 2020 Maksim Bulat. All rights reserved.
//

import UIKit

class ProgressBarView: BaseView {
    
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet weak var progressLabel: UILabel!
    private var strokes = [UIView]()
    var strokesCount: Int = 30 {
        didSet {
            updateBar()
        }
    }
    
    private var progress = 0.0
    
    override func setup() {
        UINib(nibName: "ProgressBarView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        clipViewToBounds(view: view)
        updateBar()
    }
    
    func setProgress(_ value: Double) {
        let progressOldValue = progress
        if value > 1 {
            progress = 1
        } else if value < 0 {
            progress = 0
        } else {
            progress = value
        }
        DispatchQueue.main.async {
            self.progressLabel.text = "\((value * 100).rounded(toPlaces: 6)) %"
        }
        if Int(progressOldValue * Double(strokesCount)) != Int(progress * Double(strokesCount)) {
            DispatchQueue.main.async {
                self.updateBar()                
            }
        }
    }

    func updateBar() {
        strokes.forEach({stackView.removeArrangedSubview($0)})
        stackView.spacing = self.frame.width / 2 / CGFloat(strokesCount)
        for iterator in 0...strokesCount {
            let view = UIView()
            view.backgroundColor = Double(iterator) < Double(strokesCount) * progress ? .white : .clear
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 3
            view.layer.masksToBounds = true
            stackView.addArrangedSubview(view)
            strokes.append(view)
        }
    }
}
