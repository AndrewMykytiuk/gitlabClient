//
//  SecondViewController.swift
//  RealProject
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit
import WebKit

class OAuthLogInViewController: BaseViewController, WKNavigationDelegate {
   
    //weak var router: Router?
    
    let webView = WKWebView()
    let helper = Helper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let url = helper.createURL(for: .authorize)
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        self.view = webView
    }
    
    //MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        
        if url?.relativePath == Helper.URLKind.redirect.rawValue {
            
            guard let tempURL = url else { return }
            let tempString = tempURL.absoluteString

            switch helper.getAccessCode(from: tempString){
            case .success(let code):
                let loginManager = LoginNetworkService()
                loginManager.getToken(with: code) { (result) in
                    switch result {
                    case .success(let token):
                        print(token)
                    case .error(let error):
                        break
                        
                    }
                }
            default:
                break
            }

//            let tokenURLString = "\(baseURL)oauth/token"
//
//            let accessUrl = URL(string: "\(tokenURLString)?\(clientID)&\(clientSecret)&code=\(code)&\(grantType)&\(redirectURL)")!

        }
        
        decisionHandler(.allow)
        
    }
    
}

