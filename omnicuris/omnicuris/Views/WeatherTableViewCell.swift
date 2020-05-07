//
//  WeatherTableViewCell.swift
//  omnicuris
//
//  Created by Vinay Raj K on 06/05/20.
//  Copyright © 2020 Vinay Raj K. All rights reserved.
//

import UIKit

public class WeatherTableViewCell: UITableViewCell {

    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureCell(details: City) {
        let type = details.weather?.main
        weatherLabel.text = type
        descriptionLabel.text = details.weather?.descr
        latitudeLabel.text = "lat: "+"\(details.weather?.latitude ?? 0)"
        longitudeLabel.text = "lon: "+"\(details.weather?.longitude ?? 0)"
        weatherImageView.image = getImageforString(string: type ?? "")
    }
    
    fileprivate func getImageforString(string: String) -> UIImage {
        var imgstr = ""
        switch string.lowercased() {
        case "clouds":
            imgstr = "cloudy"
        case "drizzle":
            imgstr = "drizzle"
        case "clear":
            imgstr = "sunny"
        default:
            imgstr = "default"
        }
        let image = UIImage(named: imgstr)!
        image.withTintColor(.systemBackground)
        return image
    }

}
