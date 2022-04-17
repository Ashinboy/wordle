//
//  resultViewController.swift
//  wordle
//
//  Created by Ashin Wang on 2022/4/15.
//

import UIKit
import WebKit


class resultViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var backForwardList: WKBackForwardList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 33/255, green: 50/255, blue: 93/255, alpha: 1)
        updateUI()
        
    }
    
    
    func updateUI(){
        if let url = URL(string: "https://www.thenorthface.com/mens.html"){
            let request = URLRequest(url: url)
            webView.load(request)
            
        }
        
        
    }
    
}
