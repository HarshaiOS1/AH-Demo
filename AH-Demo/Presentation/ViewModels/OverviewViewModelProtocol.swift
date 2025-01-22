//
//  OverviewViewModelProtocol.swift
//  AH-Demo
//
//  Created by Harsha on 20/01/2025.
//

import Foundation

protocol OverviewViewModelProtocol {
    var dataSource: [Int: [ArtObject]] { get }
    func fetchArtifacts(for century: Int, page: Int) async throws
}
