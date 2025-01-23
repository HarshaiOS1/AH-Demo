//
//  FetchArtifactDetailsUseCase.swift
//  AH-Demo
//
//  Created by Harsha on 23/01/2025.
//

import Foundation

/// `FetchArtifactDetailsUseCase` is responsible for fetching the details of a specific artifact.
/// - Conforms to: `FetchArtifactDetailsUseCaseProtocol`
class FetchArtifactDetailsUseCase: FetchArtifactDetailsUseCaseProtocol {
    private let repository: RijksRepositoryProtocol
    
    /// Initializes the use case with a repository.
    ///
    /// - Parameter repository: An implementation of `RijksRepositoryProtocol` for fetching artifact details.
    init(repository: RijksRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Executes the use case to fetch artifact details.
    ///
    /// - Parameter selfLink: The `selfLink` url of the artifact.
    /// - Throws: An error if the `selfLink` url  is invalid or if the repository fails to fetch data.
    /// - Returns: A string containing the artifact's description.
    func execute(selfLink: String) async throws -> String {
        guard !selfLink.isEmpty else {
            throw NSError(domain: "Invalid link", code: 400, userInfo: nil)
        }
        let link = selfLink.replacingOccurrences(of: "http", with: "https")
        return try await repository.fetchArtifactDetails(from: link)
    }
}
