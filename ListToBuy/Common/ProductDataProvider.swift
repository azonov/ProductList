//
//  ProductDataProvider.swift
//  ListToBuy
//
//  Created by Andrey Zonov on 11/27/18.
//  Copyright © 2018 Andrey Zonov. All rights reserved.
//

import CoreData

class ProductDataProvider {
    
    private let coreDataStack: NSPersistentContainer
    
    init(coreDataStack: NSPersistentContainer) {
        self.coreDataStack = coreDataStack
    }
    
    func saveProducts(data: Data) {
        coreDataStack.performBackgroundTask { context in
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context] = context
            
            do {
                try context.fetch(Product.sortedRequest).forEach(context.delete)
                
                _ = try decoder.decode([String: [Product]].self, from: data)
                
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
