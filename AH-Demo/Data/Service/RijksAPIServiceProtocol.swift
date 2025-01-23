//
//  RijksAPIServiceProtocol.swift
//  AH-Demo
//
//  Created by Harsha on 20/01/2025.
//

import Foundation
/// A protocol defining the contract for a service that interacts with the Rijksmuseum API.

protocol RijksAPIServiceProtocol {
    /// Fetches artifacts for a specific century and page from the Rijksmuseum API.
    ///
    /// This method performs a network request to retrieve artifacts for the given century
    /// and page number. It parses the API response and maps it to domain models.
    ///
    /// - Parameters:
    ///   - century: The century for which artifacts are being fetched.
    ///   - page: The page number for pagination.
    /// - Throws: An error if the network request or response parsing fails.
    /// - Returns: An array of `ArtObject` representing the fetched artifacts.
    func fetchArtifacts(for century: Int, page: Int) async throws -> [ArtObject]
}
