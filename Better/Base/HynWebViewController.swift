//
//  HynWebViewController.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/19.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var url:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackBtn()
        
        let urlHtml = URL.init(string: url!)
        let request = URLRequest.init(url: urlHtml!)
        webView.loadRequest(request)
    }
    
    deinit {
       print("\(self) deinit")
    }
    
}

extension HynWebViewController {
    
    static func getWebVC() -> HynWebViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: HynWebViewController.className()) as! HynWebViewController
    }
    
}

typealias HynWebViewDelegate = HynWebViewController
extension HynWebViewDelegate:UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewStartLoad")
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("webViewLoadError")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewFinishLoad")
    }
}
