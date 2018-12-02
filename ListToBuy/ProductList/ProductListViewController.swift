//
//  ProductListViewController.swift
//  ListToBuy
//
//  Created by Andrey Zonov on 21/11/2018.
//  Copyright © 2018 Andrey Zonov. All rights reserved.
//

import UIKit
import CoreData

class ProductListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var model: ProductListModel?
    var frc: NSFetchedResultsController<Product>?
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Мои покупки"
        model = ProductListModel() { result in
            switch result {
            case .succeed(let model):
                self.createFRCIn(context: model.context)
                model.refreshProducts()
                
            case .failed:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let frc = frc,
            let productDetailsViewController = segue.destination as? ProductDetailsViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            productDetailsViewController.product = frc.object(at: indexPath)
        }
    }
    
    // Object creation
    func createFRCIn(context: NSManagedObjectContext) {
        let frc =  NSFetchedResultsController(fetchRequest: Product.sortedRequest,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        self.frc = frc
    }
    
    //MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        let section = frc?.sections?[section]
        return section?.numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell",
                                                 for: indexPath)
        if let frc = frc,
            let productCell = cell as? ProductCell {
            let product = frc.object(at: indexPath)
            productCell.productNameLabel.text = product.name
            productCell.productsAmountLabel.text = "\(product.amount)"
        }
        
        return cell
    }

    
    //MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
