//
//  Item.swift
//  TableViewWithPaginationUsingCombineSwiftUI
//
//  Created by Rushikesh Deshpande on 25/04/24.
//


import Foundation

struct Item: Identifiable, Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
    var heavyTaskResult: Int?
    var heavyTaskTimeTaken: TimeInterval?
}

