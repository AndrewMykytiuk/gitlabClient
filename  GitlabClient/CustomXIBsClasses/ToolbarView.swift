//
//  ToolbarView.swift
//  GitlabClient
//
//  Created by User on 04/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

protocol ToolbarViewDelegate: class {
    func likeButtonPressed()
}

class ToolbarView: UIView {
    
    private var likeButton: MergeRequestLikeButton?
    private let likeButtonForMergeRequest = "LikeButtonForMergeRequest"
    private let likeButtonWidthConstant: CGFloat = 50
    
    weak var delegate: ToolbarViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       setupLikeButtonFromXib()
    }
    
     private func setupLikeButtonFromXib() {
        likeButton = MergeRequestLikeButton()
        guard let button = Bundle.main.loadNibNamed(self.likeButtonForMergeRequest, owner: likeButton, options: nil)?.first as? MergeRequestLikeButton else { return }
        likeButton = button
        button.delegate = self
        self.addSubview(button)
        setupButtonConstraints(with: button)
    }
    
    private func setupButtonConstraints(with likeButton: MergeRequestLikeButton?) {
        guard let button = likeButton else { return }
        button.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = button
            .topAnchor.constraint(equalTo: self.topAnchor)
        let bottomConstraint = button
            .bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let trailingConstraint = button
            .trailingAnchor.constraint(equalTo: self.trailingAnchor)
        self.addConstraint(topConstraint)
        self.addConstraint(bottomConstraint)
        self.addConstraint(trailingConstraint)
    }
    
    func showUpButtonImage(with name: Constants.LikeButtonImageNames) {
        likeButton?.showUpButtonImage(with: name)
    }
}

extension ToolbarView: LikeButtonDelegate {
    
    func buttonPressed(_ button: MergeRequestLikeButton) {
        likeButton?.hideButton()
        delegate?.likeButtonPressed()
    }
    
}
