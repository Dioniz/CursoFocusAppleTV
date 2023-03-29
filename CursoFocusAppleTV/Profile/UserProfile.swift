//
//  UserProfile.swift
//  CursoFocusAppleTV
//
//  Created by Fran Dioniz on 28/3/23.
//

struct UserProfileList {
    var maxNumProfiles : Int?
    var currentProfile: Int?
    var items: [UserProfile]?
}

struct UserProfile {
    var id : String?
    var name: String?
    var imageID: Int?
    var typeID: Int?
    var state: Int?
}
