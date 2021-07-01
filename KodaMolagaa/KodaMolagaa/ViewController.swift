//
//  ViewController.swift
//  KodaMolagaa
//
//  Created by Kiruthi S on 24/06/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    let reachability = try! Reachability()
    var activityIndicator: UIActivityIndicatorView!
    var webView: WKWebView = {
        let prefernces = WKWebpagePreferences()
        prefernces.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefernces
        let webView = WKWebView(frame: .zero,configuration: configuration)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: CGRect.zero)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.addSubview(webView)

        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large

        view.addSubview(activityIndicator)

        webView.load(URLRequest(url: URL(string: "https://kodamolagaa.com/")!))
    }
    
    func showActivityIndicator(show: Bool) {
            if show {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
        print("website loaded")
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
        print("website started loading")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
        print("website load failed")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
  /* override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            DispatchQueue.main.async {
            self.reachability.whenUnreachable = { _ in
                print("Not reachable")
                if let networkVC = self.storyboard?.instantiateViewController(identifier: "NetworkErrorViewController") as? NetworkErrorViewController{
                    self.present(networkVC, animated: true, completion: nil)
                }
            }
            }

            do {
                try self.reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    deinit {
        reachability.stopNotifier()
    }*/
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability

        switch reachability.connection {
        case .wifi:
            print("Wifi Connection")
        case .cellular:
            print("Cellular Connection")
        case .unavailable:
            print("No Connection")
            if let networkVC = self.storyboard?.instantiateViewController(identifier: "NetworkErrorViewController") as? NetworkErrorViewController{
                self.present(networkVC, animated: true, completion: nil)
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }*/
}

