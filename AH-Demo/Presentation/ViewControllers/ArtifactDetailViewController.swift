//
//  ArtifactDetailViewController.swift
//  AH-Demo
//
//  Created by Harsha on 23/01/2025.
//

import UIKit

/// `ArtifactDetailViewController` displays detailed information about a selected artifact.
///
/// - Shows the artifact's image.
/// - Displays the artifact's long title.
/// - Fetches and displays the artifact's description asynchronously.
///
class ArtifactDetailViewController: UIViewController {
    /// The ViewModel managing the state and business logic for the artifact detail screen.
    private let viewModel: ArtifactDetailViewModelProtocol
    
    /// An image view that displays the artifact's image.
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 1
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    /// A label that displays the artifact's long title.
    private let longTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    /// A label that displays the artifact's description, fetched asynchronously.
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    /// A scrollView that displays the artifact's description in scrollable way.
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layer.cornerRadius = 4
        return scrollView
    }()
    
    /// An activity indicator displayed while the artifact description is being fetched.
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    /// An `AsyncImageLoader` instance used to load the artifact image asynchronously.
    private let imageLoader = AsyncImageLoader()
    
    init(viewModel: ArtifactDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Lifecycle method called after the view is loaded.
    ///
    /// This method sets up the UI, configures the initial data, and starts fetching the artifact's description.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchDescription()
        configureData()
    }
    
    ///  `setupUI` functionadds subviews to the view hierarchy and applies Auto Layout constraints to position the UI elements.
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(longTitleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(descriptionLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            // Image View Constraints
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            
            // Long Title Label Constraints
            longTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            longTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            longTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Scroll View Constraints
            scrollView.topAnchor.constraint(equalTo: longTitleLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            // Description Label Constraints (Inside Scroll View)
            descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Activity Indicator Constraints
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: longTitleLabel.bottomAnchor, constant: 16)
        ])
    }
    
    /// `configureData` function sets the title and long title of the artifact, and loads the artifact image asynchronously.
    private func configureData() {
        title = viewModel.artifact.title
        longTitleLabel.text = viewModel.artifact.longTitle
        
        if let imageUrl = URL(string: viewModel.artifact.webImage?.url ?? "") {
            loadImage(from: imageUrl)
        }
    }
    
    /// `loadImage`uses the `AsyncImageLoader` to fetch the image from the given URL.
    /// If the image fetch fails, a default placeholder image is displayed.
    ///
    /// - Parameter url: The URL of the artifact's image.
    private func loadImage(from url: URL) {
        Task {
            do {
                let image = try await imageLoader.loadImage(from: url)
                imageView.image = image
            } catch {
                imageView.image = UIImage(systemName: "photo")
            }
        }
    }
    
    /// `fetchDescription` Fetches the artifact's description asynchronously using the ViewModel,
    /// shows an activity indicator while fetching the description and updates the `descriptionLabel` once the fetch is complete.
    private func fetchDescription() {
        activityIndicator.startAnimating()
        Task {
            await viewModel.fetchDescription()
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.descriptionLabel.text = self.viewModel.description
            }
        }
    }
}
