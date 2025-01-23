//
//  FetchArtifactDetailsUseCase.swift
//  AH-Demo
//
//  Created by Harsha on 23/01/2025.
//

import Foundation

class FetchArtifactDetailsUseCase: FetchArtifactDetailsUseCaseProtocol {
    private let repository: RijksRepositoryProtocol
    
    init(repository: RijksRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(selfLink: String) async throws -> String {
        guard !selfLink.isEmpty else {
            throw NSError(domain: "Invalid link", code: 400, userInfo: nil)
        }
        let link = selfLink.replacingOccurrences(of: "http", with: "https")
        return try await repository.fetchArtifactDetails(from: link)
    }
}
