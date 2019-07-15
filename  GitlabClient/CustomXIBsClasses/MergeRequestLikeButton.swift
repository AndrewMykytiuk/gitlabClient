//
//  MergeRequestLikeButton.swift
//  GitlabClient
//
//  Created by User on 04/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

protocol LikeButtonDelegate: class {
    func buttonPressed(_ button: MergeRequestLikeButton)
}

class MergeRequestLikeButton: UIButton {
    
    enum likeButtonImages: String {
        case approve = "icons8-thumbs-up-50.png"
        case disapprove = "icons8-thumbs-down-50.png"
    }
    
    weak var delegate: LikeButtonDelegate?
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func likeButtonAction(_ sender: MergeRequestLikeButton) {
        delegate?.buttonPressed(self)
    }
    
    func hideButton() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseIn],
                           animations: {
                            self.setBackgroundImage(nil, for: .normal)
                            
            }, completion: { _ in
                self.showSpinning()
            })
        }
    }
    
    func showUpButtonImage(with path: likeButtonImages) {
        let image = UIImage(named: path.rawValue)
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                            self.setBackgroundImage(image, for: .normal)
            }, completion: nil)
        }
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
    }
    
}
