//
//  ToolbarViewLikeButton.swift
//  GitlabClient
//
//  Created by User on 04/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

protocol LikeButtonToolbarViewDelegate: class {
    func likeButtonPressed()
}

class ToolbarViewLikeButton: UIView {
    
    private var likeButton: MergeRequestLikeButton?
    
    weak var delegate: LikeButtonToolbarViewDelegate?
    
    func setLikeButton() {
        likeButton = MergeRequestLikeButton()
        guard let button = Bundle.main.loadNibNamed("LikeButtonForMergeRequest", owner: likeButton, options: nil)?.first as? MergeRequestLikeButton else { return }
        likeButton = button
        button.delegate = self
        let activityIndicator = createActivityIndicator()
        likeButton?.setUpActivityIndicator(with: activityIndicator)
        button.frame = CGRect(x: self.bounds.width - 50, y: 0, width: 50, height: 50)
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(button)
    }
    
    func buttonClick() {
        likeButton?.hideButton()
    }
    
    func buttonAppear(with state: Bool) {
        state ? likeButton?.buttonAppear(with: .approve) : likeButton?.buttonAppear(with: .disapprove)
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .blue
        return activityIndicator
    }
    
}

extension ToolbarViewLikeButton: LikeButtonDelegate {
    
    func likeButtonClicked() {
        delegate?.likeButtonPressed()
        self.buttonClick()
    }
    
    func changeCurrentImage() {
        
    }
    
}
