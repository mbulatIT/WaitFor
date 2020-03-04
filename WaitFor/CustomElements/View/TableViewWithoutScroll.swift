//
//  TableViewWithoutScroll.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/19/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit
class TableViewWithoutScroll: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
