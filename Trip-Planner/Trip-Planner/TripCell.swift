//
//  TripCell.swift
//  Trip-Planner
//
//  Created by Elmer Astudillo on 10/17/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import PMSuperButton

class TripCell: UITableViewCell {

    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet var completedButton: PMSuperButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
