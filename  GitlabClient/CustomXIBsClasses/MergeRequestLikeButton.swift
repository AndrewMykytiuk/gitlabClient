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
    
    enum State {
        case likeTapped
        case dislikeTapped
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    weak var delegate: LikeButtonDelegate?
    
    @IBAction func likeButtonPressed(_ sender: MergeRequestLikeButton) {
        delegate?.buttonPressed(self)
    }
    
    class func instanceFromNib() -> MergeRequestLikeButton {
        return UINib(nibName: "MergeRequestLikeButton", bundle: Bundle.main).instantiate(withOwner: self.init(), options: nil).first as! MergeRequestLikeButton
    }
    
    func showActivityIndicator() {
        
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
    
    func showUpButtonImage(isTapped state: State) {
        
        var name: Constants.LikeButtonImageNames
        
        switch state {
        case .likeTapped:
            name = Constants.LikeButtonImageNames.approve
        case .dislikeTapped:
            name = Constants.LikeButtonImageNames.disapprove
        }
        
        let image = UIImage(named: name.rawValue)
        self.activityIndicator.stopAnimating()
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.imageView.image = image
        }, completion: nil)
        
    }
    
    private func showSpinning() {
        activityIndicator.startAnimating()
    }
    
}
