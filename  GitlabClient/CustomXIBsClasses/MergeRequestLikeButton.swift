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
        case liked //default value for button image
        case disliked
        case loading //no images - just activity indicator
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
    
    func updateState(to state: State) {
        switch state {
        case .liked:
            showUpButtonImage(for: state)
        case .disliked:
            showUpButtonImage(for: state)
        case .loading:
            showActivityIndicator()
        }
    }
    
    private func showActivityIndicator() {
        
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
    
    private func showUpButtonImage(for state: State) {
        
        var name: Constants.LikeButtonImageNames = .approve
        
        switch state {
        case .liked:
            name = .approve
        case .disliked:
            name = .disapprove
        default:
            break
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
