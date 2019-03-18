//
//  SecondViewController.swift
//  RealProject
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit
import WebKit

class OAuthLogInViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        switch AuthHelper.createURL(for: .authorize) {
        case .success(let url):
            webView.load(URLRequest(url: url))
            self.view.addSubview(webView)
        case .error(let error):
            break
        }
        
    }
}

extension OAuthLogInViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let tempURL = navigationAction.request.url else {  decisionHandler(.cancel); return }

        if tempURL.relativePath == AuthHelper.URLKind.redirect.rawValue {
            
            let tempString = tempURL.absoluteString
            
            switch AuthHelper.getAccessCode(from: tempString){
            case .success(let code):
                let loginManager = LoginNetworkService()
                loginManager.getToken(with: code) { (result) in
                    switch result {
                    case .success(let token):
                        if token.count > 0 {  }
                    case .error(_):
                        decisionHandler(.cancel)
                    }
                }
            default:
                decisionHandler(.cancel)
            }
        }
        
        decisionHandler(.allow)
        
    }
    
}
