//
//  Product+CoreDataClass.swift
//  ListToBuy
//
//  Created by Andrey Zonov on 11/27/18.
//  Copyright © 2018 Andrey Zonov. All rights reserved.
//
//

import Foundation
import CoreData

enum CodableError: Error {
    case failedToDecode
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

@objc(Product)
public class Product: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case amount
    }
    
    static var sortedRequest: NSFetchRequest<Product> {
        let request = NSFetchRequest<Product>(entityName: entity().name!)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(name), ascending: false)]
        return request
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(amount, forKey: .amount)
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let entityName = Product.entity().name,
            let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else
        {
            throw CodableError.failedToDecode
        }
        
        self.init(entity: entity, insertInto: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        amount = Int16(try values.decode(Int.self, forKey: .amount))
    }
}
