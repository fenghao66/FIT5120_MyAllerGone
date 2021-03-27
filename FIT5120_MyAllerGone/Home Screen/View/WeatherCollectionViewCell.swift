//
//  WeatherCollectionViewCell.swift
//  FIT5120_MyAllerGone
//
//  Created by Qfh on 27/3/21.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        weatherImage.layer.cornerRadius = 10.0
        //weatherImage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        weatherImage.layer.masksToBounds = true
    }
}
