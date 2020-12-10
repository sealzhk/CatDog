//
//  ViewController.swift
//  CatDogs
//
//  Created by Alua Zhakieva on 10/13/20.
//  Copyright © 2020 Alua Zhakieva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ViewController: UIViewController {
        
    @IBOutlet weak var homeGif1: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        homeGif1.loadGif(name: "catdog")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
}

