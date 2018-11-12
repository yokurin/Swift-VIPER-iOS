//
//  DetailViewController.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit
import WebKit


protocol DetailViewInputs: AnyObject {
    func setNavigationBar(title: String)
    func requestWebView(with request: URLRequest)
    func indicatorView(isHidden: Bool)
}

protocol DetailViewOutputs: AnyObject {
    func viewDidLoad()
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
}


final class DetailViewController: UIViewController {

    internal var presenter: DetailViewOutputs?

    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}


extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.isHidden = true
        presenter?.webView(webView, didFinish: navigation)
    }
}

extension DetailViewController: DetailViewInputs {
    func setNavigationBar(title: String) {
        navigationItem.title = title
    }

    func requestWebView(with request: URLRequest) {
        indicatorView.isHidden = false
        webView.load(request)
    }

    func indicatorView(isHidden: Bool) {
        indicatorView.isHidden = isHidden
    }

}

extension DetailViewController: Viewable {}
