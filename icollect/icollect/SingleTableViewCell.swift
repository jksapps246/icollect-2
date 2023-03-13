//
//  SingleTableViewCell.swift
//  icollect
//
//  Created by user231414 on 3/6/23.
//

import UIKit

class SingleTableViewCell: UITableViewCell {

    @IBOutlet weak var SingleImageView: UIImageView!
    
    @IBOutlet weak var SingleNameLabel: UILabel!
    
    @IBOutlet weak var SingleDescLabel: UILabel!
    
    @IBOutlet weak var SingleIdLabel: UILabel!
    
    func update(with collection: singleCollection) {
        SingleImageView.image = UIImage(data: collection.image)
        SingleNameLabel.text = collection.name
        SingleDescLabel.text = collection.description
        SingleIdLabel.text = String(collection.id)
    }

}
