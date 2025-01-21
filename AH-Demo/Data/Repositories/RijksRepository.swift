//
//  RijksRepository.swift
//  AH-Demo
//
//  Created by Harsha on 21/01/2025.
//

import Foundation

class RijksRepository: RijksRepositoryProtocol {
    private let apiService: RijksAPIServiceProtocol
    
    init(apiService: RijksAPIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchArtifacts(for century: Int, page: Int) async throws -> [ArtObject] {
        return try await apiService.fetchArtifacts(for: century, page: page)
    }
}
