//
//  TappableScrollView.swift
//  WaitFor
//
//  Created by Maksim Bulat on 01.03.2020.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import Foundation
import UIKit

class TappableScrollView: UIScrollView {

    weak var tappableScrollViewDelegate: TappableScrollViewDelegate?

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tappableScrollViewDelegate?.didReceiveTap(touches: touches)
    }
}
