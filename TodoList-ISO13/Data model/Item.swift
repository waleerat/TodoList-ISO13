//
//  Item.swift
//  TodoList-ISO13
//
//  Created by Waleerat Gottlieb on 2020-09-24.
//

import Foundation

class Item: Encodable {  // can encode to json
    var title: String = ""
    var done: Bool = false
}
