//
//  ArtificatsCell.swift
//  AH-Demo
//
//  Created by Harsha on 20/01/2025.
//

import UIKit

/// The `ArtifactsCell` is an UICollectionViewCell that is used to load the  artifacts image and its title.
class ArtifactsCell: UICollectionViewCell {
    static let reuseIdentifier = "ArtifactsCell"
    
    private let artifactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.backgroundColor = .red
        return label
    }()
    
    /// This propert is used to load the image `AsyncImageLoader`
    private let imageLoader = AsyncImageLoader()
    /// This propert is used to hold the current cell's image url
    private var currentImageUrl: URL?
    
    /// This method to intialise the cell with other ui comoponent
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(artifactImageView)
        contentView.addSubview(titleLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// `setupConstraints` function is used to activate the constraints for image and title label of the cell
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image View Constraints (70% of the cell height)
            artifactImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            artifactImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            artifactImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            artifactImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            // Title Label Constraints (25% of the cell height)
            titleLabel.topAnchor.constraint(equalTo: artifactImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25),
            
            // Ensure bottom of the titleLabel does not exceed the contentView
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    /// configure cell
    ///
    /// This function receives artifacts as per respective indexpaht and updates the cell.
    /// - Parameters:
    ///   - artifact:is type of`ArtObject` to be loaded to cell.
    /// - Returns: Nil
    func configure(with artifact: ArtObject) {
        titleLabel.text = artifact.title
        guard let imageUrl = URL(string: artifact.webImage?.url ?? "") else {
            artifactImageView.image = nil
            return
        }
        currentImageUrl = imageUrl
        Task {
            do {
                let image = try await imageLoader.loadImage(from: imageUrl)
                if self.currentImageUrl == imageUrl {
                    artifactImageView.image = image
                }
            } catch {
                print("Failed to load image: \(error)")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artifactImageView.image = nil
        currentImageUrl = nil
    }
}
