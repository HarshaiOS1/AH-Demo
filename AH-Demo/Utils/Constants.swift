//
//  Constants.swift
//  AH-Demo
//
//  Created by Harsha on 20/01/2025.
//

import Foundation

/// A struct that holds constant values used throughout the application.

struct Constants {
    /// The base URL for the Google Books API.
    static let baseUrl = "https://www.rijksmuseum.nl/"
    /// Api key to acces Rijksmuseum api's
    static let apiKey = "0fiuZFh4"
    /// The timeout duration for network requests, in seconds.
    static let timeout = 50.0
}

/// A struct that defines service endpoint paths for various network requests.
struct Services {
    /// The path for fetching Artifacts  from the Rijksmuseum API. The `%@` placeholder is replaced with the period of artifacts and for pagination .
    static let getArtifacts = "/api/en/collection?key=\(Constants.apiKey)&p=%@&f.dating.period=%@&ps=10"
}
