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
    
    class func instanceFromNib() -> MergeRequestLikeButton {
        return UINib(nibName: "LikeButtonForMergeRequest", bundle: Bundle.main).instantiate(withOwner: self.init(), options: nil).first as! MergeRequestLikeButton
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
    
    func showUpButtonImage(isTapped state: Bool) {
        
        let name = state ? Constants.LikeButtonImageNames.approve : Constants.LikeButtonImageNames.disapprove
        
        let image = UIImage(named: name.rawValue)
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
