//
//  Models.swift
//  Pair Randomizer
//
//  Created by Gavin Craft on 5/21/21.
//

import Foundation
struct Man: Codable, Equatable{
    let name: String
}
struct Pair: Codable, Equatable{
    var people: [Man]
}
