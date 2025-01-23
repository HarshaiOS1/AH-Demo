//
//  DetailViewModelProtocol.swift
//  AH-Demo
//
//  Created by Harsha on 23/01/2025.
//

import Foundation

protocol ArtifactDetailViewModelProtocol {
    var artifact: ArtObject { get }
    var description: String? { get }
    var isLoading: Bool { get }
    func fetchDescription() async
}
