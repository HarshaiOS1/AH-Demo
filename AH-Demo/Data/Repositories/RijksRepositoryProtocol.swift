//
//  RijksRepositoryProtocol.swift
//  AH-Demo
//
//  Created by Harsha on 21/01/2025.
//

import Foundation

protocol RijksRepositoryProtocol {
    func fetchArtifacts(for century: Int, page: Int) async throws -> [ArtObject]
}
