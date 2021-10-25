//
//  CellTableViewCell.swift
//  GTSeaLevelAPP
//
//  Created by Johnson Amalanathan on 1/22/20.
//  Copyright © 2020 Georgia Tech. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    // In data tab, for UIViewTable's cells. This connects its signal color and the label of the cell
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var signal: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
