//
//  ViewController.swift
//  Layer3Tv
//
//  Created by dinesh danda on 12/20/17.
//  Copyright © 2017 dinesh danda. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    let container: UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Loading local html page on webview */
        let url = Bundle.main.url(forResource: "Layer3tv", withExtension: "html")
        let request = URLRequest(url: url!)
        webView.delegate = self
        webView.loadRequest(request)
        /* Adding observer to recieve the data sent from web view */
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.listenedToNotification(notification:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
    }
    
    /* Called when posted notification */
    @objc func listenedToNotification(notification: NSNotification) {
        if let inputText = notification.userInfo?["inputString"] as? String {
            print("Printed in notification == \(inputText)")
            
            /*Calling success method in webview */
            
            webView.stringByEvaluatingJavaScript(from: "successMethod()")
        }
    }
    
    func showActivityIndicatory(uiView: UIView) {
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- WebView delegate Methods
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        
        let completeUrlString = request.url?.absoluteString
        /* checking if the url contails submit string or not. */
        if (completeUrlString?.contains("submit"))! {
            /* separating complete url string and the input text in webview */
            if let separatingcomponents = completeUrlString?.components(separatedBy: "inputString=") {
                /* Last object will give the input text int the field. Validating the text */
                if  let inputString = separatingcomponents.last, inputString.count > 0 {
                    /* Creating a temporory dictionary with the text entered in input filed to send it to notificaiton as user info */
                    let imageDataDict:[String: String] = ["inputString": inputString]
                    /* Posting nofication */
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
                }
                else{
                    /* Calling error handling method inside webview when there is not text */
                    webView.stringByEvaluatingJavaScript(from: "errorMethod()")
                }
            }
            
        }
        else{
            showActivityIndicatory(uiView: self.view)
        }
        return true
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
        container.removeFromSuperview()
        
    }
    
}

