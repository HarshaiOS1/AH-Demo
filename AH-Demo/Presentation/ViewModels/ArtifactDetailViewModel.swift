//
//  ArtifactDetailViewModel.swift
//  AH-Demo
//
//  Created by Harsha on 23/01/2025.
//

import Foundation

/// `ArtifactDetailViewModel` manages the UI state and business logic for the artifact detail screen.
/// - Stores the artifact to display.
/// - Fetches the artifact description using the `FetchArtifactDetailsUseCase`.
///
class ArtifactDetailViewModel: ArtifactDetailViewModelProtocol {
    private let fetchArtifactDetailsUseCase: FetchArtifactDetailsUseCaseProtocol
    /// data for the artifact
    private(set) var artifact: ArtObject
    /// description of the  artifact
    private(set) var description: String?
    /// Bool indicating if the data is still being fetched
    private(set) var isLoading: Bool = false
    
    /// Initializes the ViewModel with an artifact and a use case.
    ///
    /// - Parameters:
    ///   - artifact: The `ArtObject` representing the artifact to display.
    ///   - fetchArtifactDetailsUseCase: The use case for fetching artifact details.
    init(artifact: ArtObject, fetchArtifactDetailsUseCase: FetchArtifactDetailsUseCaseProtocol) {
        self.artifact = artifact
        self.fetchArtifactDetailsUseCase = fetchArtifactDetailsUseCase
    }
    
    /// Fetches the artifact description using the use case.
    ///
    /// Updates the `description` property and toggles `isLoading` state during the process.
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

