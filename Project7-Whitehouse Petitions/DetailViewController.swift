//
//  DetailViewController.swift
//  Project7-Whitehouse Petitions
//
//  Created by Zeeshan Waheed on 11/02/2024.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
//  we took data from view controller
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      saying that if data exists then display else return
        guard let detailItem = detailItem else { return }
        
//      assigning HTML data to a variable then later using it
//      also using string interpolation for the detailitems variable such that we're able to display results
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%;
                       font-weight: bold;} </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """
        
//      saying basically ive made my own HTML string load that
        webView.loadHTMLString(html, baseURL: nil)
    }



}
