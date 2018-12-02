//
//  ProductListViewController.swift
//  ListToBuy
//
//  Created by Andrey Zonov on 21/11/2018.
//  Copyright © 2018 Andrey Zonov. All rights reserved.
//

import UIKit

class ProductListViewController: UITableViewController {
    
    let model = ProductListModel()
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Мои покупки"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.retreiveProducts { [weak self] products in
            self?.products = products
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell",
                                                 for: indexPath)
        if let productCell = cell as? ProductCell {
            let product = products[indexPath.row]
            productCell.productNameLabel.text = product.name
            productCell.productsAmountLabel.text = "\(product.amount)"
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let productDetailsViewController = segue.destination as? ProductDetailsViewController,
            let row = tableView.indexPathForSelectedRow?.row {
            productDetailsViewController.product = products[row]
        }
    }
}
