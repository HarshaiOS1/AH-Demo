//
//  ArtifactsAPIService.swift
//  AH-Demo
//
//  Created by Harsha on 20/01/2025.
//

import Foundation

class RijksAPIService: RijksAPIServiceProtocol {
    private let baseUrl = Constants.baseUrl
    private let apiKey = Constants.apiKey
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Fetch Artifacts
    ///
    /// This function Fetches artifacts and interacts with `RijksAPIServiceProtocol` to make the api call using URL request and handles responses either valid data or error
    /// - Parameters:
    ///   - century:The Int value indicating the century the artifacts should be fetched from.
    ///   - page: The Int value used for pagination of the api request.
    /// - Returns: `[ArtObject]` array of artifact objects fetched is returned or error is thrown
    func fetchArtifacts(for century: Int, page: Int) async throws -> [ArtObject] {
        let endpoint = String(format: Services.getArtifacts, "\(page)", "\(century)")
        guard let url = URL(string: baseUrl + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = Constants.timeout
        
        let (data, response) = try await session.data(for: request)
        
        /// Check HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        /// Decode the response
        do {
            let decodedResponse = try JSONDecoder().decode(ArtifactsModel.self, from: data)
            return decodedResponse.artObjects
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func fetchArtifactDetails(from selfLink: String) async throws -> String {
        guard let url = URL(string: selfLink + "?key=\(Constants.apiKey)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = Constants.timeout
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        /// Decode the response
        do {
            let detailResponse = try JSONDecoder().decode(ArtifactDetailModel.self, from: data)
            return detailResponse.artObject.description ?? "No description for the artifact"
        } catch {
            throw NetworkError.decodingError
        }
    }
}
