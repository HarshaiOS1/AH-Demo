//
//  CenturyHeader.swift
//  AH-Demo
//
//  Created by Harsha on 21/01/2025.
//

import UIKit

/// `CenturyHeader` is the header in the collection view to display for which century the artifcats belong to
class CenturyHeader: UICollectionReusableView {
    static let reuseIdentifier = "CenturyHeader"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This function used to update the text for header
    ///
    /// - Parameter text:`String` Header title.
    func configure(with text: String) {
        label.text = text
    }
}
