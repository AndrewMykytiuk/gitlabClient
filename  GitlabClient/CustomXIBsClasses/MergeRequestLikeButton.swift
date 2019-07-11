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
    func likeButtonClicked()
}

class MergeRequestLikeButton: UIButton {
    
    enum likeButtonImages: String {
        case approve = "icons8-thumbs-up-50.png"
        case disapprove = "icons8-thumbs-down-50.png"
    }
    
    weak var delegate: LikeButtonDelegate?
    
    @IBAction func likeButtonAction(_ sender: MergeRequestLikeButton) {
        delegate?.likeButtonClicked()
    }
    
    private var activityIndicator: UIActivityIndicatorView!
    
    func setUpActivityIndicator(with indicator: UIActivityIndicatorView) {
        self.activityIndicator = indicator
    }
    
    func hideButton() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseIn],
                           animations: {
                            self.setBackgroundImage(nil, for: .normal)
                            
            }, completion: { _ in
                self.showSpinning() //Retain?
            })
        }
    }
    
    func buttonAppear(with path: likeButtonImages) {
        let image = UIImage.init(named: path.rawValue)
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
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
}
