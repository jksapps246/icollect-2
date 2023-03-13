//
//  CollectionTableViewCell.swift
//  icollect
//
//  Created by user231414 on 3/5/23.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {


    @IBOutlet weak var CollectionImageView: UIImageView!
    
    @IBOutlet weak var CollectionNameLabel: UILabel!
    
    @IBOutlet weak var CollectionDescLabel: UILabel!
    
    @IBOutlet weak var CollectionIdLabel: UILabel!
    
    func update(with collection: Collection) {
        CollectionImageView.image = UIImage(data: collection.image)
        CollectionNameLabel.text = collection.name
        CollectionDescLabel.text = collection.description
        CollectionIdLabel.text = String(collection.id)
    }
}
