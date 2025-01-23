//
//  OverviewViewModelProtocol.swift
//  AH-Demo
//
//  Created by Harsha on 20/01/2025.
//

import Foundation

/// A protocol defining the contract for a ViewModel that manages the UI state and data for the Overview screen.
protocol OverviewViewModelProtocol {
    /// The centralized data source for artifacts, grouped by century.
    ///
    /// - Key: The century (e.g., 16 for the 16th century).
    /// - Value: An array of `ArtObject` representing the artifacts for that century.
    var dataSource: [Int: [ArtObject]] { get }
    
    /// Fetches artifacts for a specific century and page.
    ///
    /// This method communicates with the Domain Layer (e.g., Use Cases) to fetch artifact data.
    /// The fetched data is typically appended to the existing `dataSource`.
    ///
    /// - Parameters:
    ///   - century: The century for which artifacts are to be fetched.
    ///   - page: The page number for pagination.
    /// - Throws: An error if the operation fails (e.g., invalid input or data fetch failure).
    func fetchArtifacts(for century: Int, page: Int) async throws
    
    /// Determines the next page to fetch for a specific century.
    ///
    /// This method uses the current state of pagination to calculate the next page number.
    ///
    /// - Parameter century: The century for which the next page is to be calculated.
    /// - Returns: The next page number to fetch.
    func nextPage(for century: Int) -> Int
}
