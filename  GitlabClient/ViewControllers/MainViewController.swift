//
//  MainViewController.swift
//  GitlabClient
//
//  Created by User on 18/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    
    private var profileService: ProfileService!
    
    func configure(with profileService: ProfileService) {
        self.profileService = profileService
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else {
            fatalError("The dequeued cell is not an instance of ProfileTableViewCell.")
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let attributes = [NSAttributedString.Key.font:UIFont(name: "Symbol", size: 17)]
//        let string: String?
//        string = ""
//
//        guard let text = string, text.count > 0 else  {
//            return 0
//        }
//
//        let rect = NSString(string: text).boundingRect(
//            with: CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude),
//            options: [.usesLineFragmentOrigin, .usesFontLeading],
//            attributes: attributes as [NSAttributedString.Key : Any], context: nil)
//
//        let height = 8 + rect.height + 8
//
//        return height
//    }
    
    
}

