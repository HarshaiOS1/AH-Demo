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
    private var isFetching = false
    
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
        Task {
            await fetchInitialData()
        }
    }
    
    /// `setupUI` function updates inital static ui components of the viewcontroller
    func setupUI() {
        title = "RijksMuseum"
        self.view.backgroundColor = UIColor.white
    }
    
    private func fetchInitialData() async {
        for century in 15...20 {
            await fetchArtifacts(for: century, page: 1)
        }
    }
    
    private func fetchArtifacts(for century: Int, page: Int) async {
        do {
            try await viewModel.fetchArtifacts(for: century, page: page)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            ErrorHandler.showAlert(viewController: self, message: "\(error.localizedDescription)")
        }
    }
    
    /// `setupCollectionView` function updates inital setupCollectionView for the viewcontroller
    private func setupCollectionView() {
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            CenturyHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CenturyHeader.reuseIdentifier
        )
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// `createCompositionalLayout` function used to create `UICollectionViewCompositionalLayout` which
    /// provides an option to combine items and create adoptive & flexible views
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            // Item size
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.1), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group size (horizontal scroll with 2 columns)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            
            // Section with horizontal scrolling
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            // Header size
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(50))
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

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension OverviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.dataSource.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource[section + 15]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.largeContentTitle = viewModel.dataSource[indexPath.section + 15]?[indexPath.row].title
        cell.backgroundColor = .lightGray
        return cell
    }
    
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
        header.configure(with: "\(15 + indexPath.section)th Century")
        return header
    }
}

