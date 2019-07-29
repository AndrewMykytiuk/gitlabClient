//
//  ToolbarView.swift
//  GitlabClient
//
//  Created by User on 04/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

protocol ToolbarViewDelegate: class {
    func likeButtonPressed()
}

class ToolbarView: UIView {
    
    private var likeButton: MergeRequestLikeButton?
    private var mergeButton: MergeRequestMergeButton?
    
    weak var delegate: ToolbarViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        placeLikeButton()
        placeMergeButton()
    }
    
    class func instanceFromNib() -> ToolbarView {
        return UINib(nibName: "MergeRequestToolbarView", bundle: Bundle.main).instantiate(withOwner: self.init(), options: nil).first as! ToolbarView
    }
    
    private func placeLikeButton() {
        let button = MergeRequestLikeButton.instanceFromNib()
        likeButton = button
        button.delegate = self
        self.addSubview(button)
        setupLikeButtonConstraints(with: button)
    }
    
    private func setupLikeButtonConstraints(with likeButton: MergeRequestLikeButton?) {
        guard let button = likeButton else { return }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func placeMergeButton() {
        let button = MergeRequestMergeButton.instanceFromNib()
        mergeButton = button
        button.delegate = self
        self.addSubview(button)
        setupMergeButtonConstraints(with: button)
    }
    
    private func setupMergeButtonConstraints(with mergeButton: MergeRequestMergeButton?) {
        guard let button = mergeButton else { return }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 5).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
//        self.topAnchor.constraint(equalTo: button.topAnchor, constant: 5).isActive = true
//        self.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true
//        self.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5).isActive = true
        
//        button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        //button.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    func updateLikeButtonState(to state: MergeRequestLikeButton.State) {
        likeButton?.updateState(to: state)
    }
    
}

extension ToolbarView: LikeButtonDelegate {
    
    func buttonPressed(_ button: MergeRequestLikeButton) {
        delegate?.likeButtonPressed()
    }
    
}

extension ToolbarView: MergeButtonDelegate {
    func buttonPressed(_ button: MergeRequestMergeButton) {
        
    }
    
    
}
