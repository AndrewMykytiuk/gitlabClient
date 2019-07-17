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
    private let likeButtonWidthConstant: CGFloat = 50
    
    weak var delegate: ToolbarViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        placeLikeButton()
    }
    
    class func instanceFromNib() -> ToolbarView {
        return UINib(nibName: "ToolbarViewForLikeButton", bundle: Bundle.main).instantiate(withOwner: self.init(), options: nil).first as! ToolbarView
    }
    
     private func placeLikeButton() {
        let button = MergeRequestLikeButton.instanceFromNib()
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
    
    func showUpButtonImage(isTapped state: Bool) {
        likeButton?.showUpButtonImage(isTapped: state)
    }
}

extension ToolbarView: LikeButtonDelegate {
    
    func buttonPressed(_ button: MergeRequestLikeButton) {
        likeButton?.hideButton()
        delegate?.likeButtonPressed()
    }
    
}
