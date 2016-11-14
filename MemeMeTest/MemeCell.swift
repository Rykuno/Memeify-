//
//  MemeCell.swift
//  MemeMeTest
//
//  Created by Donny Blaine on 11/15/16.
//  Copyright © 2016 RyStudios. All rights reserved.
//

import UIKit

class MemeCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(memeImage: UIImage){
        self.imageView.image = memeImage
    }
}
