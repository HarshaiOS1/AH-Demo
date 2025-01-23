class OverviewViewModel: OverviewViewModelProtocol {
    private let repository: RijksRepositoryProtocol
    /// data for the respecitve century of artifacts
    private(set) var dataSource: [Int: [ArtObject]] = [:]
    /// Tracks the current page for each century
    private var currentPages: [Int: Int] = [:]
    
    init(repository: RijksRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Fetch Artifacts
    ///
    /// Fetches artifacts for a specific century and page. Handles appending artifacts to the data source.
    /// - Parameters:
    ///   - century: The century from which artifacts are to be fetched.
    ///   - page: The page number for pagination.
    /// - Throws: Error if the repository call fails.
    func fetchArtifacts(for century: Int, page: Int) async throws {
        do {
            let artifacts = try await repository.fetchArtifacts(for: century, page: page)
            if dataSource[century] == nil {
                dataSource[century] = []
            }
            dataSource[century]?.append(contentsOf: artifacts)
            currentPages[century] = page
        } catch {
            throw error
        }
    }
    
    /// Get the next page for a century
    ///
    /// - Parameter century: The century for which to get the next page.
    /// - Returns: The next page number.
    func nextPage(for century: Int) -> Int {
        return (currentPages[century] ?? 0) + 1
    }
}
