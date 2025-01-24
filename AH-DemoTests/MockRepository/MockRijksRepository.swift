//
//  MockRijksRepository.swift
//  AH-DemoTests
//
//  Created by Harsha on 22/01/2025.
//

import Foundation
@testable import AH_Demo
/// A mock implementation of the `RijksRepositoryProtocol` used for testing.
///
/// This mock repository interacts with a mock API service to simulate data fetching
/// for test scenarios. It serves as an intermediary between the view model and the API service.
class MockRijksRepository: RijksRepositoryProtocol {
    /// The mock API service used by the repository.
    private let apiService: RijksAPIServiceProtocol
    
    /// Initializes the mock repository with a given API service.
    ///
    /// - Parameter apiService: A mock implementation of `RijksAPIServiceProtocol`.
    init(apiService: RijksAPIServiceProtocol) {
        self.apiService = apiService
    }
    /// Simulates fetching artifacts for a given century and page.
    ///
    /// - Parameters:
    ///   - century: The century for which artifacts are being fetched.
    ///   - page: The page number for pagination.
    /// - Throws: An error if the API service fails to fetch data.
    /// - Returns: A list of mock artifacts from the API service.
    func fetchArtifacts(for century: Int, page: Int) async throws -> [ArtObject] {
        return try await apiService.fetchArtifacts(for: century, page: page)
    }
    /// Simulates fetching artifact details using the `selfLink` link.
    ///
    /// - Parameter selfLink: The url  link of the artifact.
    /// - Throws: An error if the data fetch operation fails.
    /// - Returns: A string containing the artifact's description.
    func fetchArtifactDetails(from selfLink: String) async throws -> String {
        return try await apiService.fetchArtifactDetails(from: selfLink)
    }
}
