//
//  NetworkError.swift
//  AH-Demo
//
//  Created by Harsha on 20/01/2025.
//

import Foundation

// Network Error Enum
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case unknown
}
