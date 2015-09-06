//
//  CustomHeaderCell.swift
//  Yelp
//
//  Created by Bao Pham on 9/6/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class CustomHeaderCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerLabel.preferredMaxLayoutWidth = headerLabel.bounds.width
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
