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
    
    let baseURL = "https://gitlab.dataart.com/"
    let clientID = "client_id=84318559ea36e249bd51365dca13ba9f937aa09442e67dc1c31c25a376adcafa"
    let clientSecret = "client_secret=3808bf00f1e124ef8e4046e74d0c4eef83d88823aa6a2f7465c9647cace23794"
    let redirectURL = "redirect_uri=https://gitlabclient.com/oauth/redirect"
    let responseType = "response_type=code"
    let grantType = "grant_type=authorization_code"
    let state = "state=1234567"
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let authorizeURLString = "\(baseURL)oauth/authorize"
        
        let url = URL(string: "\(authorizeURLString)?\(clientID)&\(redirectURL)&\(responseType)&\(state)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        self.view = webView
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        let myScheme = "/oauth/redirect"
        
        if url?.relativePath == myScheme {
            
            var code = ""

            guard let tempURL = url else { return }
            let tempString = tempURL.absoluteString

            let helper = Helper()
            
            switch helper.getAccessCode(from: tempString) {
            case .success(let success):
                code = success
            case .error(let error):
                print(error)
            }

            let tokenURLString = "\(baseURL)oauth/token"

            let accessUrl = URL(string: "\(tokenURLString)?\(clientID)&\(clientSecret)&code=\(code)&\(grantType)&\(redirectURL)")!

            let session = URLSession.shared

            var request = URLRequest(url: accessUrl)
            request.httpMethod = "POST" //set http method as POST

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

                guard error == nil else {
                    return
                }

                guard let data = data else {
                    return
                }

                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)

                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
        
        decisionHandler(.allow)
        
    }
    
}

