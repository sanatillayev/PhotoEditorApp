//
//  User.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation

struct User: Codable {

    init(
        id: String?,
        email: String?,
        name: String?,
        picture: String?
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.picture = picture
    }

    let id: String?
    let email: String?
    let name: String?
    let picture: String?
}

extension User {
    
    static let initial = User(
        id: nil,
        email: "",
        name: nil,
        picture: nil
    )
}
