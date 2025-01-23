//
//  ViewController.swift
//  AH-Demo
//
//  Created by Harsha on 19/01/2025.
//

import UIKit

/// `OverviewViewController` is the main view of the application that displays a list of items, It manages the presentation of books, handles network connectivity
///- Usage:
///   Use `OverviewViewController` as the entry point for Rijksmuseum's  item list.
class OverviewViewController: UIViewController {
    private var viewModel: OverviewViewModelProtocol!
    private var collectionView: UICollectionView!
    private var fetchingSection = -1
    
    /// Activity Indicator to show loading state during data fetching
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: OverviewViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupActivityIndicator()
        Task {
            await fetchInitialData()
        }
    }
    
    /// `setupUI` function updates inital static ui components of the viewcontroller
    func setupUI() {
        title = "RijksMuseum"
        self.view.backgroundColor = UIColor.white
    }
    
    /// `setupActivityIndicator` function sets up the activity indicator in the view
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    /// `setupCollectionView` function updates inital setupCollectionView for the viewcontroller
    private func setupCollectionView() {
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ArtifactsCell.self, forCellWithReuseIdentifier: ArtifactsCell.reuseIdentifier)
        collectionView.register(
            CenturyHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CenturyHeader.reuseIdentifier
        )
        view.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = true
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    ///`fetchInitialData` function i used to call the api to fetch data for multiple period of time(currently from 16th-20th century )
    private func fetchInitialData() async {
        // Show the loader before starting the fetch
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        await withTaskGroup(of: Void.self) { taskGroup in
            for century in 16...20 {
                taskGroup.addTask {
                    await self.fetchArtifacts(for: century, page: 1)
                }
            }
        }
        // Hide the loader once the fetch is complete
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    /// Fetch Artifacts
    ///
    /// This function Fetches artifacts uses OverviewViewModel  to make the api call,
    /// and loads in collection of successfull data retrival, otherwisecatches any error and shows alert for the same.
    /// - Parameters:
    ///   - century:The Int value indicating the century the artifacts should be fetched from.
    ///   - page: The Int value used for pagination of the api request.
    /// - Returns: Nil
    private func fetchArtifacts(for century: Int, page: Int) async {
        defer {
            DispatchQueue.main.async {
                self.fetchingSection = -1
            }
        }
        do {
            try await viewModel.fetchArtifacts(for: century, page: page)
            DispatchQueue.main.async {
                if (self.fetchingSection > -1) {
                    self.collectionView.reloadData()
                    //                    self.collectionView.reloadSections(IndexSet(integer: century - 16))
                } else {
                    self.collectionView.reloadData()
                }
            }
        } catch {
            DispatchQueue.main.async {
                ErrorHandler.showAlert(viewController: self, message: "\(error.localizedDescription)")
            }
        }
    }
    
    /// `createCompositionalLayout` function used to create `UICollectionViewCompositionalLayout` which
    /// provides an option to combine items and create adoptive & flexible views
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            // Item size: Half of the group's width
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group size: Full width of the section, 2 items per group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalWidth(0.6) // Height proportional to width
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            
            // Section with horizontal scrolling
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 5)
            section.interGroupSpacing = 10
            
            // Header size
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
}

/// Extension for `OverviewViewController` conforming to `UICollectionViewDataSource` and `UICollectionViewDelegate`.
///
/// This extension handles the data source and delegate methods of the `UICollectionView`,
/// enabling the display of sections, items, and headers, as well as managing pagination and interactions.
extension OverviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// Returns the number of sections in the collection view.
    ///
    /// - Parameter collectionView: The `UICollectionView` requesting the information.
    /// - Returns: The number of sections, corresponding to the number of keys in the `dataSource`.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.dataSource.keys.count
    }
    
    /// Returns the number of items in a specific section of the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The `UICollectionView` requesting the information.
    ///   - section: The index of the section.
    /// - Returns: The number of items in the specified section, or `0` if the section is empty or not present in the `dataSource`.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource[section + 16]?.count ?? 0
    }
    
    /// Configures and returns the cell for a specific item in the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The `UICollectionView` requesting the cell.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A configured `ArtifactsCell` displaying the artifact information.
    ///          If the cell cannot be dequeued as an `ArtifactsCell`, returns empty collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtifactsCell.reuseIdentifier, for: indexPath) as? ArtifactsCell else {
            return UICollectionViewCell.init()
        }
        if let artifact = viewModel.dataSource[indexPath.section + 16]?[indexPath.item] {
            cell.configure(with: artifact)
        }
        return cell
    }
    
    /// Configures and returns the supplementary view (e.g., header) for a specific section of the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The `UICollectionView` requesting the supplementary view.
    ///   - kind: The kind of supplementary view being requested (header in this case).
    ///   - indexPath: The index path specifying the location of the supplementary view.
    /// - Returns: A configured `CenturyHeader` displaying the century for the section, or an empty reusable view if the kind does not match a header.
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CenturyHeader.reuseIdentifier,
                for: indexPath
              ) as? CenturyHeader else {
            return UICollectionReusableView()
        }
        header.configure(with: "\(16 + indexPath.section)th Century")
        return header
    }
    
    /// Handles the display of a cell and triggers pagination if the user scrolls near the end of a section.
    ///
    /// - Parameters:
    ///   - collectionView: The `UICollectionView` containing the cell.
    ///   - cell: The `UICollectionViewCell` being displayed.
    ///   - indexPath: The index path of the cell being displayed.
    ///
    /// This function:
    /// - Checks the section of the cell being displayed.
    /// - Triggers pagination for that section if the user scrolls within 4 items of the end.
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let section = indexPath.section
        if fetchingSection != section {
            if section >= 0 {
                guard let itemsInSection = viewModel.dataSource[section + 16]?.count else { return }
                if (itemsInSection - indexPath.row) < 4 {
                    fetchingSection = section
                    let century = section + 16
                    let nextPage = viewModel.nextPage(for: century)
                    Task {
                        await fetchArtifacts(for: century, page: nextPage)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
