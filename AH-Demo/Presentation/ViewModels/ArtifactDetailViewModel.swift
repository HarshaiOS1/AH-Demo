//
//  ArtifactDetailViewModel.swift
//  AH-Demo
//
//  Created by Harsha on 23/01/2025.
//

import Foundation

class ArtifactDetailViewModel: ArtifactDetailViewModelProtocol {
    private let fetchArtifactDetailsUseCase: FetchArtifactDetailsUseCaseProtocol
    private(set) var artifact: ArtObject
    private(set) var description: String?
    private(set) var isLoading: Bool = false
    
    init(artifact: ArtObject, fetchArtifactDetailsUseCase: FetchArtifactDetailsUseCaseProtocol) {
        self.artifact = artifact
        self.fetchArtifactDetailsUseCase = fetchArtifactDetailsUseCase
    }
    
    func fetchDescription() async {
        isLoading = true
        guard let selfLink = artifact.links.linksSelf else {
            description = "Description not available."
            return
        }
        do {
            description = try await fetchArtifactDetailsUseCase.execute(selfLink: selfLink)
        } catch {
            description = "Description not available."
        }
        isLoading = false
    }
}
