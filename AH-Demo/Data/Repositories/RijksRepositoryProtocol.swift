//
//  RijksRepositoryProtocol.swift
//  AH-Demo
//
//  Created by Harsha on 21/01/2025.
//

import Foundation

/// A protocol defining the contract for a repository that handles fetching artifact data.

protocol RijksRepositoryProtocol {
    /// Fetches artifacts for a specific century and page.
    ///
    /// This method retrieves artifact data based on the given century and page number.
    /// The data may come from a remote API, local cache, or database, depending on the implementation.
    ///
    /// - Parameters:
    ///   - century: The century for which artifacts are being fetched.
    ///   - page: The page number for pagination.
    /// - Throws: An error if the data fetch operation fails.
    /// - Returns: An array of `ArtObject` representing the fetched artifacts.
    func fetchArtifacts(for century: Int, page: Int) async throws -> [ArtObject]
    
    func fetchArtifactDetails(from selfLink: String) async throws -> String
}
