//
//  Category.swift
//  RaoVatApp
//
//  Created by lynnguyen on 11/01/2024.
//

import Foundation

struct CategoryPost: Decodable {
    let kq: Int
    let cateList: [Category]
}

struct Category: Decodable {
    let _id: String
    let image: String
    let name: String
}


struct Category2 {
    let gia: String
    let name: String

}
