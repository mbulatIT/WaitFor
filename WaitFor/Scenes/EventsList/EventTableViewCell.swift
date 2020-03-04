//
//  EventTableViewCell.swift
//  WaitFor
//
//  Created by Maksim Bulat on 03.03.2020.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    static let reusableIdentifier = "EventTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
