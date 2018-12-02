//
//  ProductDetailsViewController.swift
//  ListToBuy
//
//  Created by Andrey Zonov on 21/11/2018.
//  Copyright © 2018 Andrey Zonov. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = product.name
    }
}
