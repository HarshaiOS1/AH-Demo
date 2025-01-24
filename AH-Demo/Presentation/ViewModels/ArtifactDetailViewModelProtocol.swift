//
//  DetailViewModelProtocol.swift
//  AH-Demo
//
//  Created by Harsha on 23/01/2025.
//

import Foundation
/// A protocol defining the contract for the `ArtifactDetailViewModel`.
protocol ArtifactDetailViewModelProtocol {
    /// The artifact to be displayed on the detail screen.
    ///
    /// This property represents the data about the artifact details
    var artifact: ArtObject { get }
    
    /// The description of the artifact.
    ///
    /// This property is updated after the `fetchDescription` method is called.
    /// If the description is unavailable or the fetch fails, this property may return `nil`.
    var description: String? { get }
    
    /// A Boolean indicating whether the artifact description is currently being fetched.
    ///
    /// This property is `true` while the `fetchDescription` method is executing
    /// and `false` once the operation completes (successfully or with an error).
    var isLoading: Bool { get }
    
    /// Fetches the artifact description asynchronously.
    ///
    /// This method retrieves the description of the artifact using an associated use case.
    /// It updates the `description` and `isLoading` properties based on the operation's outcome.
    ///
    /// - Note: This method should be called from a coroutine or `Task` to avoid blocking the main thread.
    /// - Returns: `Void`. Updates the `description` property upon completion.
    func fetchDescription() async
}
