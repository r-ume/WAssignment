//
//  DetailViewController.swift
//  WAssignment
//
//  Created by 梅木綾佑 on 2017/03/05.
//  Copyright © 2017年 梅木綾佑. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    var respositoryName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = respositoryName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
