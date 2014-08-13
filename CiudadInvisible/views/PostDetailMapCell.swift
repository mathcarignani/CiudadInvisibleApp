//
//  PostDetailMapCell.swift
//  CiudadInvisible
//
//  Created by Mathias on 19/07/14.
//  Copyright (c) 2014 CiudadInvisible. All rights reserved.
//

import UIKit
import MapKit

class PostDetailMapCell: UITableViewCell {

    @IBOutlet var mapa: MKMapView!

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
}
