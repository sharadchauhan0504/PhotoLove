//
//  RandomPhotosAPIOutput.swift
//  PhotoLove
//
//  Created by Sharad on 29/09/20.
//

import Foundation

// MARK: - RandomPhotosAPIOutputElement
struct RandomPhotosAPIOutputElement: Codable {
    let id: String
    let width, height: Int?
    let color, altDescription: String?
    let urls: Urls
    let user: User

    enum CodingKeys: String, CodingKey {
        case id, width, height, color
        case altDescription = "alt_description"
        case urls, user
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}

// MARK: - User
struct User: Codable {
    let id: String
    let username, name, twitterUsername: String?
    let portfolioURL: String?
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case id
        case username, name
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio
    }
}

typealias RandomPhotosAPIOutput = [RandomPhotosAPIOutputElement]
