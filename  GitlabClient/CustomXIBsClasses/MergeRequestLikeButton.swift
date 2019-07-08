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
    func changeCurrentImage()
}

class MergeRequestLikeButton: UIButton {
    
    enum likeButtonImages: String {
        case approve = "icons8-chevron-up-filled-50.png"
        case disapprove = "icons8-chevron-down-50.png"
    }
    
    weak var delegate: LikeButtonDelegate?
    
    @IBAction func likeButtonAction(_ sender: MergeRequestLikeButton) {
        delegate?.likeButtonClicked()
    }
    
    private var activityIndicator: UIActivityIndicatorView!
    
    func setUpActivityIndicator(with indicator: UIActivityIndicatorView) {
        self.activityIndicator = indicator
    }
    
    private func hideLoading() {
        DispatchQueue.main.async(execute: {
            self.activityIndicator.stopAnimating()
            
        })
    }
    
    func hideButton() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: {
                        self.imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
                        
        }, completion: { _ in
            self.showSpinning()
        })
    }
    
    func buttonAppear(with path: likeButtonImages) {
        hideLoading()
        let image = UIImage.init(named: path.rawValue)
        self.setBackgroundImage(image, for: .normal)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.imageView?.layer.transform = CATransform3DIdentity
        }, completion: nil)
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
