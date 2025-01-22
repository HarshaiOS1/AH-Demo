//
//  ArtifactsModel.swift
//  AH-Demo
//
//  Created by Harsha on 20/01/2025.
//

import Foundation

// MARK: - ArtifactsModel
struct ArtifactsModel: Codable {
    let artObjects: [ArtObject]
}

// MARK: - ArtObject
struct ArtObject: Codable {
    let links: Links
    let id, objectNumber, title: String?
    let hasImage: Bool
    let principalOrFirstMaker: String?
    let longTitle: String?
    let showImage, permitDownload: Bool
    let webImage, headerImage: Image?
    let productionPlaces: [String]
}

// MARK: - Image
struct Image: Codable {
    let guid: String?
    let offsetPercentageX, offsetPercentageY, width, height: Int?
    let url: String?
}

// MARK: - Links
struct Links: Codable {
    let linksSelf, web: String?
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case web
    }
}
