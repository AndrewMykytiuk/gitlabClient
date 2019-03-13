//
//  SecondViewController.swift
//  RealProject
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: BaseViewController, WKNavigationDelegate {
   
    //weak var router: Router?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView()
        
        
        webView.navigationDelegate = self

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        
        let url = URL(string: "https://gitlab.dataart.com/users/sign_in")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        self.view = webView
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let app = UIApplication.shared
        let url = navigationAction.request.url
        let defaultUrl = URL(string: "https://www.dataart.ua")!
        let myScheme = "http://RealProject.com/oauth/redirect?code=1234567890&state=123456"
        
        if url?.scheme == myScheme && app.canOpenURL(url ?? defaultUrl) {
            app.canOpenURL(url ?? defaultUrl)
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
        
//        UIApplication *app = [UIApplication sharedApplication];
//        NSURL *url = navigationAction.request.URL;
//        NSString *myScheme = @"...";
//        if ([url.scheme isEqualToString:myScheme] &&
//            [app canOpenURL:url]) {
//            [app openURL:url];
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
//        decisionHandler(WKNavigationActionPolicyAllow);
        
    }
   
}
