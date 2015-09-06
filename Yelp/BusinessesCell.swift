//
//  BusinessesCell.swift
//  Yelp
//
//  Created by Bao Pham on 9/5/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesCell: UITableViewCell {

    //UIImageView object
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    //UILabel object group
    @IBOutlet weak var bussinessNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var business: Business! {
        didSet{
            bussinessNameLabel.text = business.name
            distanceLabel.text = business.distance
            reviewCountLabel.text = String(business.reviewCount)
            categoryLabel.text = business.categories
            addressLabel.text = business.address
            thumbImageView.setImageWithURL(business.imageURL)
            ratingImageView.setImageWithURL(business.ratingImageURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 7
        thumbImageView.clipsToBounds = true
        bussinessNameLabel.preferredMaxLayoutWidth = bussinessNameLabel.frame.size.width
        addressLabel.preferredMaxLayoutWidth = addressLabel.frame.size.width
        categoryLabel.preferredMaxLayoutWidth = categoryLabel.frame.size.width
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bussinessNameLabel.preferredMaxLayoutWidth = bussinessNameLabel.frame.size.width
        addressLabel.preferredMaxLayoutWidth = addressLabel.frame.size.width
        categoryLabel.preferredMaxLayoutWidth = categoryLabel.frame.size.width

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
