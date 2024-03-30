//
//  City.swift
//  RaoVatApp
//
//  Created by lynnguyen on 12/01/2024.
//

import Foundation

struct CityPost: Decodable {
    let kq: Int
    let list: [City]
}

struct City: Decodable {
    let _id: String
    let name: String
}

