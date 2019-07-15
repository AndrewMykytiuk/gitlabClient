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

class MergeRequestLikeButton: UIView {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    weak var delegate: LikeButtonDelegate?
    
    @IBAction func likeButtonAction(_ sender: MergeRequestLikeButton) {
        delegate?.buttonPressed(self)
    }
    
    func hideButton() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseIn],
                           animations: {
                            self.imageView.image = nil
                            
            }, completion: { [weak self] _ in
                guard let welf = self else { return }
                welf.showSpinning()
            })
        }
    }
    
    func showUpButtonImage(with path: Constants.LikeButtonImageNames) {
        let image = UIImage(named: path.rawValue)
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                            self.imageView.image = image
            }, completion: nil)
        }
    }
    
    private func showSpinning() {
        activityIndicator.startAnimating()
    }
    
}
