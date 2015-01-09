//
//  EventListCell.swift
//  joind.in
//
//  Created by Rich Sage on 06/01/2015.
//  Copyright (c) 2015 joind.in. All rights reserved.
//

import UIKit

class EventListCell: UITableViewCell {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
