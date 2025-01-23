//
//  FetchArtifactDetailsUseCaseProtocol.swift
//  AH-Demo
//
//  Created by Harsha on 23/01/2025.
//

import Foundation

protocol FetchArtifactDetailsUseCaseProtocol {
    func execute(selfLink: String) async throws -> String
}
