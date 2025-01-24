//
//  MockRijksAPIService.swift
//  AH-DemoTests
//
//  Created by Harsha on 22/01/2025.
//

import Foundation
@testable import AH_Demo
/// A mock implementation of the `RijksAPIServiceProtocol` used for testing.
///
/// This mock service simulates fetching artifacts from an API. It allows you to configure
/// test scenarios such as successful responses or error responses.
class MockRijksAPIService: RijksAPIServiceProtocol {
    /// A flag indicating whether the service should return an error.
    var shouldReturnError = false
    
    /// A collection of mock artifacts to be returned by the service.
    var mockArtifacts: [ArtObject] = []

    /// Simulates fetching artifacts for a given century and page.
    ///
    /// - Parameters:
    ///   - century: The century for which artifacts are being fetched.
    ///   - page: The page number for pagination.
    /// - Throws: `URLError` if `shouldReturnError` is set to `true`.
    /// - Returns: A list of mock artifacts.
    func fetchArtifacts(for century: Int, page: Int) async throws -> [ArtObject] {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return mockArtifacts
    }
    
    func fetchArtifactDetails(from selfLink: String) async throws -> String {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return "dummy description for artifact"
    }
}
