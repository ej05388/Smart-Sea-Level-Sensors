//
//  LearningTableViewCell.swift
//  GTSeaLevelAPP
//
//  Created by Johnson Amalanathan on 4/7/20.
//  Copyright © 2020 Georgia Tech. All rights reserved.
//

import UIKit

protocol FavoriteDelegate: class {
    func didTapHeart(in cell: FavoritesTableViewCell)
}

class FavoritesTableViewCell: UITableViewCell {

    // In favorites tab, each cell has the label of the sensor's name and the signal color
    @IBOutlet var favoriteLabel: UILabel!
    @IBOutlet weak var favoriteSignal: UIView!
    
    var delegate: FavoriteDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    // If the user clicks on the heart function which saves their favorite sensors
    @IBAction func heartTapped(_ sender: Any) {
        delegate.didTapHeart(in: self)
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
