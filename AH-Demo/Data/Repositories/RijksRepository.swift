//
//  RijksRepository.swift
//  AH-Demo
//
//  Created by Harsha on 21/01/2025.
//

import Foundation

/// `RijksRepository` is responsible for handling artifact-related data interactions.
/// - Conforms to: `RijksRepositoryProtocol`
class RijksRepository: RijksRepositoryProtocol {
    /// The API service used for fetching artifact data.
    private let apiService: RijksAPIServiceProtocol
    
    /// Initializes the repository with an API service.
    ///
    /// - Parameter apiService: An implementation of `RijksAPIServiceProtocol` for fetching artifact data.
    init(apiService: RijksAPIServiceProtocol) {
        self.apiService = apiService
    }
    
    /// Fetches artifacts for a specific century and page.
    ///
    /// - Parameters:
    ///   - century: The century for which artifacts are being fetched.
    ///   - page: The page number for pagination.
    /// - Throws: An error if the data fetch operation fails.
    /// - Returns: An array of `ArtObject` representing the fetched artifacts.
    func fetchArtifacts(for century: Int, page: Int) async throws -> [ArtObject] {
        return try await apiService.fetchArtifacts(for: century, page: page)
    }
    
    /// Fetches artifact details using the `selfLink` link.
    ///
    /// - Parameter selfLink: The url  link of the artifact.
    /// - Throws: An error if the data fetch operation fails.
    /// - Returns: A string containing the artifact's description.
    func fetchArtifactDetails(from selfLink: String) async throws -> String {
        return try await apiService.fetchArtifactDetails(from: selfLink)
    }
}
