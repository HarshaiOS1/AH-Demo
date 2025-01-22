//
//  OverviewViewModel.swift
//  AH-Demo
//
//  Created by Harsha on 20/01/2025.
//

import Foundation
/// A view model for managing and presenting RijksAPI Data for overview.
///
/// The `OverviewViewModel` class is responsible
/// 1. For fetching `Atifacts` from an external service (RijksAPI),
/// 3. It handles network connectivity, offline data loading, and error reporting.
/// 4. It conforms to the `OverviewViewModelProtocol` protocol, so implementing `fetchArtifacts` is enforced

class OverviewViewModel: OverviewViewModelProtocol {
    private let repository: RijksRepositoryProtocol
    private(set) var dataSource: [Int: [ArtObject]] = [:]
    
    init(repository: RijksRepositoryProtocol) {
        self.repository = repository
    }
    /// Fetch Artifacts
    ///
    /// This function Fetches artifacts and interacts with `RijksRepositoryProtocol` to make the api call, throws error
    /// in case of any errors
    /// - Parameters:
    ///   - century:The Int value indicating the century the artifacts should be fetched from.
    ///   - page: The Int value used for pagination of the api request.
    /// - Returns: Nil
    func fetchArtifacts(for century: Int, page: Int) async throws {
        do {
            let artifacts = try await repository.fetchArtifacts(for: century, page: page)
            if dataSource[century] == nil {
                dataSource[century] = []
            }
            dataSource[century]?.append(contentsOf: artifacts)
        } catch {
            throw error
        }
    }
}
