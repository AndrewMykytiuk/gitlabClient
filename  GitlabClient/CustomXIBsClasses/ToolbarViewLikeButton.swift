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
    
    @IBOutlet private weak var likeButton: MergeRequestLikeButton!
    
    weak var delegate: LikeButtonToolbarViewDelegate?
    
    func setUpLikeButtonDelegate() {
        likeButton.delegate = self
    }
    
    func showUpButtonImage(with state: Bool) {
        state ? likeButton?.showUpButtonImage(with: .approve) : likeButton?.showUpButtonImage(with: .disapprove)
    }
    
}

extension ToolbarViewLikeButton: LikeButtonDelegate {
    
    func buttonPressed(_ button: MergeRequestLikeButton) {
        likeButton?.hideButton()
        delegate?.likeButtonPressed()
    }
    
}
