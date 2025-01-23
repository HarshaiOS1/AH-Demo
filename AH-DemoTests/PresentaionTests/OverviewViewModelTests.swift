//
//  OverviewViewModelTests.swift
//  AH-Demo
//
//  Created by Harsha on 22/01/2025.
//

import XCTest
@testable import AH_Demo

/// `OverviewViewModelTests` is a test suite for verifying the functionality of `OverviewViewModel`.
///
/// This class includes tests for:
/// - Successful fetching of artifacts.
/// - Handling errors when fetching artifacts fails.
/// It uses a mock API service and repository for controlled testing.

import XCTest
@testable import AH_Demo

/// `OverviewViewModelTests` is a test suite for verifying the functionality of `OverviewViewModel`.
///
/// This class includes tests for:
/// - Successful fetching of artifacts.
/// - Handling errors when fetching artifacts fails.
/// It uses a mock API service and repository for controlled testing.
class OverviewViewModelTests: XCTestCase {
    /// The `OverviewViewModel` under test.
    var viewModel: OverviewViewModel!
    
    /// The mock API service used to simulate network requests.
    var mockAPIService: MockRijksAPIService!
    
    /// The mock repository used to simulate data interactions.
    var mockRepository: MockRijksRepository!
    
    /// The use case for fetching artifacts.
    var fetchArtifactsUseCase: FetchArtifactsUseCase!
    
    /// Set up test resources before each test.
    ///
    /// This method initializes the mock API service, repository, and the `OverviewViewModel`.
    override func setUp() {
        super.setUp()
        mockAPIService = MockRijksAPIService()
        mockRepository = MockRijksRepository(apiService: mockAPIService)
        fetchArtifactsUseCase = FetchArtifactsUseCase(repository: mockRepository)
        viewModel = OverviewViewModel(fetchArtifactsUseCase: fetchArtifactsUseCase)
    }
    
    /// Tear down test resources after each test.
    ///
    /// This method deallocates the mock API service, repository, and the `OverviewViewModel`.
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        mockRepository = nil
        fetchArtifactsUseCase = nil
        super.tearDown()
    }
    
    /// Test the `fetchArtifacts` method of `OverviewViewModel` for a successful API response.
    ///
    /// This test ensures:
    /// - The `dataSource` is updated with the fetched artifacts.
    /// - The correct number and details of artifacts are present in the `dataSource`.
    func testFetchArtifactsSuccess() async {
        // Arrange: Prepare a mock artifact and set it in the mock API service
        let mockArtifact = ArtObject(links: Links(linksSelf: "self", web: "web"), id: "1", objectNumber: "123", title: "Mock Artifact", hasImage: true, principalOrFirstMaker: "Ananymous", longTitle: "Mock artifact long title", showImage: true, permitDownload: true, webImage: Image(guid: "guid", offsetPercentageX: 0, offsetPercentageY: 0, width: 100, height: 100, url: "https://example.com/image.jpg"), headerImage: Image(guid: "guid", offsetPercentageX: 0, offsetPercentageY: 0, width: 100, height: 100, url: "https://example.com/header.jpg"), productionPlaces: []);
        mockAPIService.mockArtifacts = [mockArtifact]
        
        // Act: Fetch artifacts for the 17th century
        do {
            try await viewModel.fetchArtifacts(for: 17, page: 1)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
        
        // Assert: Verify that the data source has the correct artifacts
        XCTAssertEqual(viewModel.dataSource[17]?.count, 1)
        XCTAssertEqual(viewModel.dataSource[17]?.first?.title, "Mock Artifact")
    }
    
    /// Test the `fetchArtifacts` method of `OverviewViewModel` for an API failure.
    ///
    /// This test ensures:
    /// - Errors are correctly handled, and the `dataSource` remains unaffected.
    func testFetchArtifactsFailure() async {
        // Arrange: Configure the mock API service to return an error
        mockAPIService.shouldReturnError = true
        
        // Act: Attempt to fetch artifacts for the 17th century
        do {
            try await viewModel.fetchArtifacts(for: 17, page: 1)
            XCTFail("Expected error but got success")
        } catch {
            // Assert: Verify that the data source is not updated
            XCTAssertNil(viewModel.dataSource[17])
        }
    }
}
