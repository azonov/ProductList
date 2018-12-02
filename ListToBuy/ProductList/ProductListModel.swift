//
//  ProductListModel.swift
//  ListToBuy
//
//  Created by Andrey Zonov on 21/11/2018.
//  Copyright © 2018 Andrey Zonov. All rights reserved.
//

import Foundation
import CoreData

enum Result<Value> {
    case succeed(Value)
    case failed(Error)
}

class ProductListModel {
    
    private enum Constants {
        static let urlString =  "https://api.jsonbin.io/b/5bf4f5cc746e9b593ec0bb98"
        static let modelName = "ListToBuy"
    }
    
    // Public Properties
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    // Private Properties
    private let session = URLSession.shared
    private var productsProvider: ProductDataProvider?
    private let container = NSPersistentContainer(name: Constants.modelName)
    
    init(completion: @escaping (Result<ProductListModel>) -> ()) {
        container.loadPersistentStores { store, error in
            guard let error = error else {
                self.productsProvider = ProductDataProvider(coreDataStack: self.container)
                let context = self.container.viewContext
                context.automaticallyMergesChangesFromParent = true
                completion(Result.succeed(self))
                return
            }
            completion(Result.failed(error))
        }
    }
    
    func refreshProducts() {
        guard let url = URL(string: Constants.urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            if
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                error == nil,
                httpResponse.statusCode == 200
            {
                self.productsProvider?.saveProducts(data: data)
            } else {
                // TODO: Handle error or wrong response cases
            }
        }
        
        task.resume()
    }
}
