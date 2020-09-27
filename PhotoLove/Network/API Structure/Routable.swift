//
//  Routable.swift
//  PhotoLove
//
//  Created by Sharad on 27/09/20.
//

import Foundation

protocol Routable {
    var url: URL { get }
    var method: HTTPMethod { get }
    var endPoint: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var request: URLRequest { get }
}
