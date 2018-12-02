//
//  ProductListModel.swift
//  ListToBuy
//
//  Created by Andrey Zonov on 21/11/2018.
//  Copyright © 2018 Andrey Zonov. All rights reserved.
//

import Foundation

struct ProductList: Codable {
    let products: [Product]
}

struct Product: Codable {
    let name: String
    let amount: Int
}

class ProductListModel {
    
    private let session = URLSession.shared
    
    func retreiveProducts(completion: @escaping ([Product]) -> ()) {
        guard let url = URL(string: "https://api.jsonbin.io/b/5bf4f5cc746e9b593ec0bb98") else {
            return completion([])
        }
        
        let request = URLRequest(url: url)
        let store = UserDefaults.standard
        let key = "ProductListCache"
        if let data = store.value(forKey: key) as? Data,
            let productList = try? JSONDecoder().decode(ProductList.self,
                                                        from: data) {
            completion(productList.products)
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                error == nil,
                httpResponse.statusCode == 200
            {
                let productList = try? JSONDecoder().decode(ProductList.self,
                                                            from: data)
                if productList != nil,
                    let data = try? JSONEncoder().encode(productList) {
                  store.setValue(data, forKey: key)
                }
                DispatchQueue.main.async {
                    completion(productList?.products ?? [])
                }
            } else {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        
        task.resume()
    }
}
