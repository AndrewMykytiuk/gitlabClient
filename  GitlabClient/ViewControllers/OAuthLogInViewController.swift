//
//  SecondViewController.swift
//  RealProject
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit
import WebKit

protocol OAuthLogInViewControllerDelegate: class {
    func viewControllerDidFinishLogin(oAuthViewController: OAuthLogInViewController)
    func viewControllerDidFinishWithError(oAuthViewController: OAuthLogInViewController)
}

class OAuthLogInViewController: BaseViewController {
    
    weak var delegate: OAuthLogInViewControllerDelegate?
    private let webView = WKWebView()
    private let activityIndicator = UIActivityIndicatorView()
    private var loginManager: LoginService!
    
    func configure(with loginService: LoginService) {
        self.loginManager = loginService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        self.view.addSubview(webView)
        self.view.addSubview(activityIndicator)
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .gray
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
       setupWebView()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setup(with: self.view)
    }
    
    private func setupWebView() {
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        switch AuthHelper.createURL(for: .authorize) {
        case .success(let url):
            loginManager.checkReachability { [weak self] (result) in
                guard let welf = self else { return }
                if result {
                    welf.webView.load(URLRequest(url: url))
                } else {
                    let alert = AlertHelper.createErrorAlert(message: FatalError.reachabilityError.rawValue) { (action) in
                        welf.delegate?.viewControllerDidFinishWithError(oAuthViewController: welf)
                    }
                    welf.present(alert, animated: true)
                }
            }
        case .error(let error):
            let alert = AlertHelper.createErrorAlert(message: error.localizedDescription) { (action) in
                self.delegate?.viewControllerDidFinishWithError(oAuthViewController: self)
            }
            self.present(alert, animated: true)
        }
    }
    
    private func setup(with view: UIView) {
        
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        webView.frame = view.frame
        activityIndicator.frame = view.frame
    }
    
    private func wkNavigationDelegateAction(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let tempURL = navigationAction.request.url else {  decisionHandler(.cancel); return }
        
        if tempURL.relativePath == AuthHelper.URLKind.redirect.rawValue {
            
            let tempString = tempURL.absoluteString
            
            switch AuthHelper.getAccessCode(from: tempString){
            case .success(let code):
                receivingToken(with: code)
            case .error(let error):
                let alert = AlertHelper.createErrorAlert(message: error.localizedDescription) { (action) in
                    self.delegate?.viewControllerDidFinishWithError(oAuthViewController: self)
                }
                self.present(alert, animated: true)
                decisionHandler(.cancel)
            }
        }
        
        decisionHandler(.allow)
    }
    
    private func receivingToken(with code: String) {
        self.activityIndicator.startAnimating()
        loginManager?.login(with: code, completion: { [weak self] (result) in
            guard let welf = self else { return }
            DispatchQueue.main.async {
                welf.activityIndicator.stopAnimating()
            }
            switch result {
            case .success:
                welf.delegate?.viewControllerDidFinishLogin(oAuthViewController: welf)
            case .error(let error):
                let alert = AlertHelper.createErrorAlert(message: error.localizedDescription) { (action) in
                    welf.delegate?.viewControllerDidFinishWithError(oAuthViewController: welf)
                }
                welf.present(alert, animated: true)
            }
        })
    }
}

extension OAuthLogInViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        self.wkNavigationDelegateAction(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if CodeError.requestTimeout.range.contains(error._code) {
        let alert = AlertHelper.createErrorAlert(message: error.localizedDescription) { (action) in
            self.delegate?.viewControllerDidFinishWithError(oAuthViewController: self)
        }
        self.present(alert, animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let alert = AlertHelper.createErrorAlert(message: error.localizedDescription, handler: nil)
        self.present(alert, animated: true)
    }
    
}
