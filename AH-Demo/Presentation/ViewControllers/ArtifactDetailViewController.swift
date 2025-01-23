//
//  ArtifactDetailViewController.swift
//  AH-Demo
//
//  Created by Harsha on 23/01/2025.
//

import UIKit

/// `ArtifactDetailViewController` displays detailed information about a selected artifact.
///

class ArtifactDetailViewController: UIViewController {
    private let viewModel: ArtifactDetailViewModelProtocol
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let longTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    /// This propert is used to load the image `AsyncImageLoader`
    private let imageLoader = AsyncImageLoader()
    
    init(viewModel: ArtifactDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
        fetchDescription()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(longTitleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            
            longTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            longTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            longTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: longTitleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: longTitleLabel.bottomAnchor, constant: 16)
        ])
    }
    
    private func configureData() {
        title = viewModel.artifact.title
        longTitleLabel.text = viewModel.artifact.longTitle
        
        if let imageUrl = URL(string: viewModel.artifact.webImage?.url ?? "") {
            loadImage(from: imageUrl)
        }
    }
    
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
