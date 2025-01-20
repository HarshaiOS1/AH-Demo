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
    
    lazy private var sampleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello AH!"
        label.textColor = .red
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        self.setUpConstraints()
    }
    
    /// `updateUI` function updates inital static ui components of the viewcontroller
    func updateUI() {
        self.title = "RijksMuseum"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.sampleLabel)
        
    }
    
    /// `setUpConstraints` function updates constrainsts of the ui components in the viewcontroller programatically
    func setUpConstraints() {
        let sampleLabelConstraints = [
            self.sampleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.sampleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(sampleLabelConstraints)
    }
    
}
