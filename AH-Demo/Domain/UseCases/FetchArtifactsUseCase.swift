//
//  FetchArtifactsUseCase.swift
//  AH-Demo
//
//  Created by Harsha on 20/01/2025.
//

import Foundation

/// `FetchArtifactsUseCase` is responsible for fetching artifacts for a specific century and page.
///
/// This use case orchestrates the fetching of artifacts by validating the input,
/// applying business rules, and interacting with the repository to fetch data from the data layer.
///
/// - Conforms to: `FetchArtifactsUseCaseProtocol`
class FetchArtifactsUseCase: FetchArtifactsUseCaseProtocol {
    
    /// The repository used for fetching artifact data.
    private let repository: RijksRepositoryProtocol
    
    init(repository: RijksRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Executes the use case to fetch artifacts for a specific century and page.
    ///
    /// This method validates the input parameters, fetches artifacts from the repository,
    /// and returns them to the caller.
    ///
    /// - Parameters:
    ///   - century: The century for which artifacts are to be fetched. Must be between 16 and 20.
    ///   - page: The page number for pagination.
    /// - Throws: An error if the century is invalid or if fetching from the repository fails.
    /// - Returns: A list of `ArtObject` objects corresponding to the requested century and page.
    func execute(century: Int, page: Int) async throws -> [ArtObject] {
        // Validate the input parameters
        guard century >= 16, century <= 20 else {
            throw NSError(domain: "Invalid century", code: 400, userInfo: nil)
        }
        // Fetch artifacts from the repository
        return try await repository.fetchArtifacts(for: century, page: page)
    }
}
