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
    
    @IBOutlet weak var likeButton: MergeRequestLikeButton!
    
    weak var delegate: LikeButtonDelegate?
    
    @IBAction func likeButtonAction(_ sender: MergeRequestLikeButton) {
        delegate?.likeButtonClicked()
        showLoading()
    }
    
    
    
    private var activityIndicator: UIActivityIndicatorView! {
        didSet {
            
        }
    }
    
    func showLoading() {
        
        showSpinning()
    }
    
    func changeImageAnimated(image: UIImage?) {
        guard let imageView = self.imageView, let currentImage = imageView.image, let newImage = image else {
            return
        }
        let crossFade: CABasicAnimation = CABasicAnimation(keyPath: "contents")
        crossFade.duration = 0.3
        crossFade.fromValue = currentImage.cgImage
        crossFade.toValue = newImage.cgImage
        crossFade.isRemovedOnCompletion = false
        crossFade.fillMode = CAMediaTimingFillMode.forwards
        imageView.layer.add(crossFade, forKey: "animateContents")
    }
    
    func hideLoading(with pressedButton: Bool) {
        DispatchQueue.main.async(execute: {
            self.activityIndicator.stopAnimating()
            
        })
    }
    
    func hideButton() {
        self.likeButton.isHidden = true
    }
    
    private func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .blue
    }
    
    private func showSpinning() {
        createActivityIndicator() //Каждый раз??? ТЫ ШОТО НАПУТАЛ
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        //self.changeImageAnimated(image:#imageLiteral(resourceName: "icons8-chevron-down-50"))
        self.likeButton.isHidden = true
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
