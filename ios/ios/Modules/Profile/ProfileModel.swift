//
//  ProfileModel.swift
//  iso
//
//  Created by Xenona on 19/02/2025.
//

import Foundation

let sexes = ["Male", "Female"]

struct Profile{
    var email: String
    var username: String
    var dateOfBirth: Date
    var country: String
    var sex: String
    var description: String
    var registeredAt: Date
    var favorites: [String]
}
