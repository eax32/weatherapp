//
//  CityTableViewCell.swift
//  weatherapp
//
//  Created by Kirill Bobkov on 30.10.17.
//  Copyright © 2017 NordrocksInc. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell, CityDataOwningProtocol {
    @IBOutlet var name: UILabel!
    @IBOutlet var temp: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bindModel(model: CityDataModel) {
        model.bind(CityDataModel.UIOwner(owner: self))
    }
    
    func cityDataUpdated(_ data: CityData) {
        //  Update field
        name.text = data.title
        temp.text = data.temp_s
    }
}
