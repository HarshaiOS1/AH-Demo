//
//  FetchArtifactsUseCaseProtocol.swift
//  AH-Demo
//
//  Created by Harsha on 23/01/2025.
//

import Foundation

/// Protocol defining the contract for the `FetchArtifactsUseCase`.
protocol FetchArtifactsUseCaseProtocol {
    /// Executes the use case to fetch artifacts for a specific century and page.
    ///
    /// - Parameters:
    ///   - century: The century for which artifacts are to be fetched.
    ///   - page: The page number for pagination.
    /// - Throws: An error if the operation fails (e.g., invalid input or repository error).
    /// - Returns: A list of `ArtObject` objects corresponding to the requested century and page.
    func execute(century: Int, page: Int) async throws -> [ArtObject]
}
