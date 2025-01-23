//
//  ArtifactDetailViewModelTests.swift
//  AH-DemoTests
//
//  Created by Harsha on 23/01/2025.
//

import XCTest
@testable import AH_Demo

/// `ArtifactDetailViewModelTests` is a test suite for verifying the functionality of `ArtifactDetailViewModel`.
///
/// This class includes tests for:
/// - Successful fetching of the artifact description.
/// - Handling errors when fetching the artifact description fails.
/// It uses a mock use case for controlled testing.
class ArtifactDetailViewModelTests: XCTestCase {
    /// The `ArtifactDetailViewModel` under test.
    var viewModel: ArtifactDetailViewModel!
    
    /// The mock use case for fetching artifact details.
    var mockFetchArtifactDetailsUseCase: MockFetchArtifactDetailsUseCase!
    
    /// A mock artifact used for testing.
    var mockArtifact: ArtObject!
    
    /// Set up test resources before each test.
    ///
    /// This method initializes the mock use case, artifact, and the `ArtifactDetailViewModel`.
    override func setUp() {
        super.setUp()
        mockArtifact = ArtObject(links: Links(linksSelf: "https://example.com/self", web: "https://example.com/web"), id: "1",objectNumber: "123", title: "Mock Artifact", hasImage: true, principalOrFirstMaker: "Anonymous", longTitle: "Mock Artifact Long Title", showImage: true, permitDownload: true, webImage: Image(guid: "guid", offsetPercentageX: 0, offsetPercentageY: 0, width: 100, height: 100, url: "https://example.com/image.jpg"), headerImage: Image(guid: "guid", offsetPercentageX: 0, offsetPercentageY: 0, width: 100, height: 100, url: "https://example.com/header.jpg"), description: nil, productionPlaces: [])
        mockFetchArtifactDetailsUseCase = MockFetchArtifactDetailsUseCase()
        viewModel = ArtifactDetailViewModel(artifact: mockArtifact, fetchArtifactDetailsUseCase: mockFetchArtifactDetailsUseCase)
    }
    
    /// Tear down test resources after each test.
    ///
    /// This method deallocates the mock use case, artifact, and the `ArtifactDetailViewModel`.
    override func tearDown() {
        viewModel = nil
        mockFetchArtifactDetailsUseCase = nil
        mockArtifact = nil
        super.tearDown()
    }
    
    /// Test that the `ArtifactDetailViewModel` initializes correctly with the provided artifact.
    ///
    /// This test ensures:
    /// - The artifact data is correctly assigned to the `viewModel`.
    func testViewModelInitialization() {
        XCTAssertEqual(viewModel.artifact.title, "Mock Artifact")
        XCTAssertEqual(viewModel.artifact.longTitle, "Mock Artifact Long Title")
    }
    
    /// Test the `fetchDescription` method of `ArtifactDetailViewModel` for a successful description fetch.
    ///
    /// This test ensures:
    /// - The description is updated with the fetched description.
    /// - The `isLoading` property is toggled correctly.
    func testFetchDescriptionSuccess() async {
        // Arrange: Set the mock description
        mockFetchArtifactDetailsUseCase.mockDescription = "Mock Artifact Description"
        
        // Act: Fetch the description
        await viewModel.fetchDescription()
        
        // Assert: Verify that the description is updated correctly
        XCTAssertEqual(viewModel.description, "Mock Artifact Description")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    /// Test the `fetchDescription` method of `ArtifactDetailViewModel` for a failed description fetch.
    ///
    /// This test ensures:
    /// - The description is set to "Description not available." on failure.
    /// - The `isLoading` property is toggled correctly.
    func testFetchDescriptionFailure() async {
        // Arrange: Configure the mock use case to return an error
        mockFetchArtifactDetailsUseCase.shouldReturnError = true
        
        // Act: Fetch the description
        await viewModel.fetchDescription()
        
        // Assert: Verify that the description falls back to the default error message
        XCTAssertEqual(viewModel.description, "Description not available.")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    /// Test that the `isLoading` property is toggled correctly during the `fetchDescription` process.
    ///
    /// This test ensures:
    /// - `isLoading` is `true` when fetching begins.
    /// - `isLoading` is `false` when fetching completes.
    func testFetchDescriptionLoadingState() async {
        // Arrange
        XCTAssertFalse(viewModel.isLoading)
        
        // Act: Fetch the description
        Task {
            await viewModel.fetchDescription()
        }
        
        // Assert: Verify that `isLoading` is toggled correctly
        XCTAssertTrue(viewModel.isLoading)
        await Task.yield() // Allow async task to complete
        XCTAssertFalse(viewModel.isLoading)
    }
}
