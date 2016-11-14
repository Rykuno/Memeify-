//
//  DetailVC.swift
//  MemeMeTest
//
//  Created by Donny Blaine on 11/15/16.
//  Copyright © 2016 RyStudios. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var memedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.imageView.image = memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
