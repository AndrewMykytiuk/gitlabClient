//
//  MergeRequestMergeButton.swift
//  GitlabClient
//
//  Created by Andrew Mykytuik on 21/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

protocol MergeButtonDelegate: class {
    func buttonPressed(_ button: MergeRequestMergeButton)
}

class MergeRequestMergeButton: UIView {
    
    enum State {
        
        case merge
        case merging
        case merged
        case conflict
        
        var value: (UIColor, String) {
            switch self {
            case .merge:
                return (UIColor.colorWithRGB(red: 38, green: 169, blue: 88, alpha: 1.0), "Merge")
            case .merging:
                return (UIColor.colorWithRGB(red: 38, green: 169, blue: 88, alpha: 1.0), "Merging")
            case .merged:
                return (UIColor.colorWithRGB(red: 41, green: 43, blue: 96, alpha: 1.0), "Merged")
            case .conflict:
                return (UIColor.colorWithRGB(red: 250, green: 197, blue: 205, alpha: 1.0), "Conflict")
            }
        }
    }
    
    var pseudoState: Bool = false
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var textLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textLabelTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var textLabelLeadingLowPriorityConstraint: NSLayoutConstraint!
    
    weak var delegate: MergeButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(mergeButtonPressed(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    @IBAction func mergeButtonPressed(_ sender: UITapGestureRecognizer) {
        delegate?.buttonPressed(self)
        //showActivityIndicator(with: pseudoState)
        showUpButtonImage()
    }
    
    class func instanceFromNib() -> MergeRequestMergeButton {
        return UINib(nibName: "MergeRequestMergeButton", bundle: Bundle.main).instantiate(withOwner: self.init(), options: nil).first as! MergeRequestMergeButton
    }
    
    func updateState(to state: State) {
        
    }
    
    private func showActivityIndicator(with isPressed:Bool) {
        
//        if self.pseudoState {
//            self.activityIndicator.alpha = 0
//
//        }
        
//        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping:
//            1, initialSpringVelocity: 0.0, options: [], animations: {
////                self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width + 40, height: self.bounds.size.height)
//                self.widthAnchor.constraint(equalToConstant: 180).isActive = true
//                self.backgroundColor =
//                    UIColor.green
//                self.activityIndicator.startAnimating()
//                self.textLabel.text = "Merging"
//                //button.frame.size.width = 180
//                self.layoutIfNeeded()
//        }, completion: nil)
        
//        self.transform = CGAffineTransform.identity
//        UIView.animate(withDuration: 0.66, delay: 0.0,
//                       usingSpringWithDamping: 0.7,
//                       initialSpringVelocity: 0.7,
//                       options: [],
//                       animations: {
//                        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.0)
//        }, completion: nil)
  //---     //self.widthAnchor.constraint(equalToConstant: self.frame.size.width + 30.0).isActive = true //self.frame.width + 40
        //button.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        
        
        
//        if self.pseudoState {
//            UIView.transition(with: self.activityIndicator, duration: 0.2,
//                              options: [.curveEaseOut, .transitionFlipFromBottom],
//                              animations: {
//                                self.activityIndicator.alpha = 0
//
//            }, completion: { [weak self] _ in
//                guard let welf = self else { return }
//                UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping:
//                    0.2, initialSpringVelocity: 0.0, options: [], animations: {
//                welf.textLabel.text = "Merge"
//                welf.textLabelLeadingConstraint.constant -= welf.activityIndicator.frame.size.width
//                })
//                welf.layoutIfNeeded()
//            })
//        }
        
//        UIView.animate(withDuration: 0.7, delay: 0, options: [], animations: {
        
        UIView.animate(withDuration: 2.7, delay: 0, options: [.curveEaseIn, .showHideTransitionViews], animations: {
        
//        UIView.animate(withDuration: 1.5, delay: 0.1, usingSpringWithDamping:
//            0, initialSpringVelocity: 6.0, options: [], animations: {
        
//                self.widthAnchor.constraint(equalToConstant: self.frame.size.width + 60.0).isActive = true
                //self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width + 40, height: self.bounds.size.height)
                
                //self.textLabel.text = "Merging"
                //self.textLabelLeadingConstraint.constant += self.activityIndicator.frame.size.width
                
                
                if self.pseudoState {
                    self.textLabel.sizeToFit()
                    
                    UIView.transition(with: self.activityIndicator, duration: 0.2,
                                      options: [.curveEaseOut],
                                      animations: {
                                        self.activityIndicator.alpha = 0

                    }, completion: nil)
                    
                    self.textLabel.text = "Merge"
                    self.textLabelLeadingConstraint.constant -= self.activityIndicator.frame.size.width
                    self.superview?.layoutIfNeeded()
                    
                    //self.textLabelLeadingConstraint.constant -= self.activityIndicator.frame.size.width
                    
                } else {
                    self.showSpinning()
//                    UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveLinear], animations: {
//                        self.activityIndicator.alpha = 1
//                    }, completion: nil)
//                    let width = self.textLabel.preferredMaxLayoutWidth
//                    self.textLabel.intrinsicContentSize.width
                    
//                    self.textLabel.sizeThatFits(CGSize(width: width, height: self.textLabel.frame.height))
                    //self.textLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1)
                    self.textLabelLeadingConstraint.constant += self.activityIndicator.frame.size.width
                    
                    UIView.transition(with: self.activityIndicator, duration: 0.2,
                                      options: [.curveEaseOut],
                                      animations: {
                                        self.textLabel.text = "Merging"
                                        self.activityIndicator.alpha = 1
                                        
                    }, completion: nil)
                    
                }
                
             self.superview?.layoutIfNeeded()
                
        }, completion: { [weak self] _ in
            guard let welf = self else { return }
            UIView.transition(with: welf.textLabel,
                              duration: 8,
                              options: [.transitionCrossDissolve, .curveEaseInOut],
                              animations: { [weak self] in
                                guard let welf = self else { return }
                        
                                welf.textLabel.text = welf.pseudoState ? "Merging" : "Merge"
                                welf.textLabel.sizeToFit()
                                welf.superview?.layoutIfNeeded()
                }, completion: nil)
            })
        
        self.pseudoState = !pseudoState
    }
    
    private func showUpButtonImage() {
        
        UIView.animateKeyframes(withDuration: 2.0, delay: 0, options: [.calculationModeCubic], animations: {
           
            UIView.addKeyframe(withRelativeStartTime: 0.9,
                               relativeDuration: 1.5,
                               animations: {
                                self.showSpinning()
                                self.textLabelLeadingConstraint.constant += self.activityIndicator.frame.size.width
                                //self.textLabel.text! += "   "
                                //self.superview?.layoutIfNeeded()
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration:2.0,
                               animations: {
                                self.textLabel.alpha = 0
                self.textLabel.text = self.pseudoState ? "Merge" : "Merging"
                                self.textLabel.alpha = 1
                                self.superview?.layoutIfNeeded()
                
            })
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 2.0,
                               animations: {
                       self.activityIndicator.alpha = 1
                                self.superview?.layoutIfNeeded()
            })
            
            
            
            
        }, completion:{ _ in
            print("I'm done!")
        })
        
        self.pseudoState = !pseudoState
        
//        let midX = self.trailingAnchor.accessibilityFrame.midX
//        //let midX = self.widthAnchor.accessibilityFrame.maxX
//        let midY = self.center.y
//
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.duration = 3.6
//        animation.repeatCount = 1
//        //animation.autoreverses = true
//        animation.fromValue = self.layer.position.x
//        animation.toValue = CGPoint(x: self.layer.position.x + 40, y: midY)
//        animation.speed = 1
//        layer.add(animation, forKey: "position")
        
//        UIView.animate(withDuration: 3, delay: 0, options: [.autoreverse], animations: {
//            self.textLabelLeadingConstraint.constant += self.activityIndicator.frame.size.width
//            self.textLabelLeadingConstraint.isActive = false
//
//            self.widthAnchor.constraint(equalToConstant: 120).isActive = true
//
//            self.textLabelCenterX.constant += self.activityIndicator.frame.size.width
//
//            self.textLabel.center.x += 30
//            self.textLabel.text = ":::::::::::"
//            self.textLabelLeadingConstraint.isActive = true
//            NSLayoutConstraint.activate([self.textLabelLeadingConstraint])
//            self.updateConstraintsIfNeeded()
//            self.layoutIfNeeded()
//        }, completion: nil)
        
        //self.transform = CGAffineTransform.identity

        let transform = CGAffineTransform(a: 10, b: 10, c: 10, d: 10, tx: 0, ty: 0)
        
        //self.textLabelLeadingConstraint.constant += self.activityIndicator.frame.size.width
        
        //self.textLabelLeadingConstraint.constant = self.textLabelLeadingLowPriorityConstraint.constant + self.frame.size.width
        
//        UIView.animate(withDuration: 3.7, delay: 0, options: [.curveEaseIn, .showHideTransitionViews], animations: {
        
//        UIView.transition(with: self, duration: 3.7, options: [.curveEaseOut, .showHideTransitionViews], animations: {
        
            //self.widthAnchor.constraint(equalToConstant: 120).isActive = true
           // self.textLabel.text = "Merging"
            
            //self.textLabelLeadingLowPriorityConstraint.priority = UILayoutPriority(rawValue: 1000)
            
            //self.textLabel.widthAnchor.constraint(equalToConstant: self.textLabel.frame.size.width + 40)
            
            //self.textLabelTrailingConstraint.constant += self.activityIndicator.frame.size.width
            //self.textLabelLeadingConstraint.constant += self.activityIndicator.frame.size.width
            //self.layer.anchorPoint = CGPoint(x: 0.02, y: 0.5)
            
            //self.textLabel.layer.anchorPoint = CGPoint(x: 0.02, y: 0.5)
            
            //self.layoutIfNeeded()
            //self.transform = CGAffineTransform(scaleX: 1.1, y: 1.0)
            //self.transform = transform
            //self.transform = CGAffineTransform(translationX: -10, y: 0)
            
             //self.layoutIfNeeded()
            //self.textLabel.layoutIfNeeded()
            
//            self.textLabelLeadingConstraint.accessibilityActivationPoint.applying( self.transform)
//            self.textLabelLeadingConstraint.accessibilityActivationPoint.x = self.textLabelLeadingLowPriorityConstraint.constant + self.frame.size.width
//            self.textLabelTrailingConstraint.accessibilityActivationPoint.x = self.textLabelLeadingLowPriorityConstraint.constant + self.frame.size.width
            //self.setNeedsLayout()
            
            //self.superview?.layoutIfNeeded()

        //}, completion: nil)
        
//        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseIn, .transitionFlipFromLeft], animations: {

//                self.textLabelLeadingConstraint.constant += self.activityIndicator.frame.size.width
//        },
//                       completion: nil)
//            { _ in
//                        UIView.animate(withDuration: 0.5) {
//                            self.transform = CGAffineTransform.identity
//                        }
//        }

        
    }
    
    private func showSpinning() {
        activityIndicator.startAnimating()
    }
    
}
