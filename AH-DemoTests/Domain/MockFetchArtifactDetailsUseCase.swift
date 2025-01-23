//
//  MockFetchArtifactDetailsUseCase.swift
//  AH-DemoTests
//
//  Created by Harsha on 23/01/2025.
//

import Foundation
@testable import AH_Demo

class MockFetchArtifactDetailsUseCase: FetchArtifactDetailsUseCaseProtocol {
    var shouldReturnError = false
    var mockDescription = "Mock Artifact Description"
    
    func execute(selfLink: String) async throws -> String {
        if shouldReturnError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return mockDescription
    }
}
