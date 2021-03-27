//
//  AQICollectionViewCell.swift
//  FIT5120_MyAllerGone
//
//  Created by Qfh on 27/3/21.
//

import UIKit

class AQICollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var AQIImage: UIImageView!
    @IBOutlet weak var AQILabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        AQIImage.layer.cornerRadius = 10.0
        //weatherImage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        AQIImage.layer.masksToBounds = true
    }
}
