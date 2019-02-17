//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by makramia on 21/11/2018.
//  Copyright © 2018 makramia. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    var memedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        memeImageView.image = memedImage
    }
    

}
