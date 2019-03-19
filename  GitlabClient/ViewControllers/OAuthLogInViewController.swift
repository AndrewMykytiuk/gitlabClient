//
//  SecondViewController.swift
//  RealProject
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit
import WebKit

protocol OAuthDidFinishLoginDelegate {
    func didFinishDownloading(with token: String)
}

class OAuthLogInViewController: BaseViewController {
    
    var delegate: OAuthDidFinishLoginDelegate?
    private let webView = WKWebView()
    private let activityIndicator = UIActivityIndicatorView()
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        self.view.addSubview(webView)
        self.view.addSubview(activityIndicator)
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .gray
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        switch AuthHelper.createURL(for: .authorize) {
        case .success(let url):
            webView.load(URLRequest(url: url))
        case .error(let error):
            let alert = AuthHelper.createAlert(message: error.localizedDescription)
            self.present(alert, animated: true)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpUI(with: self.view)
    }
    
    private func setUpUI(with view: UIView) {
        view.addConstraints([
            NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0),
            ])
        
        activityIndicator.centerXAnchor.constraint(
            equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(
            equalTo: view.centerYAnchor).isActive = true
        
        webView.frame = view.frame
        activityIndicator.frame = view.frame
    }
}

extension OAuthLogInViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let tempURL = navigationAction.request.url else {  decisionHandler(.cancel); return }
        
        if tempURL.relativePath == AuthHelper.URLKind.redirect.rawValue {
            
            let tempString = tempURL.absoluteString
            
            activityIndicator.startAnimating()
            switch AuthHelper.getAccessCode(from: tempString){
            case .success(let code):
                let loginManager = LoginNetworkService()
                loginManager.getToken(with: code) { (result) in
                    switch result {
                    case .success(let token):
                        if token.count > 0 {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                Router.rootVC?.dismiss(animated: true, completion: nil)
                            }
                        }
                    case .error(let error):
                        self.activityIndicator.stopAnimating()
                        let alert = AuthHelper.createAlert(message: error.localizedDescription)
                        self.present(alert, animated: true)
                        decisionHandler(.cancel)
                        
                    }
                }
            case .error(let error):
                activityIndicator.stopAnimating()
                let alert = AuthHelper.createAlert(message: error.localizedDescription)
                self.present(alert, animated: true)
                decisionHandler(.cancel)
            }
        }
        
        decisionHandler(.allow)
        
    }
    
}
