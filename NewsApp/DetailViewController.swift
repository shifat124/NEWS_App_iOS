

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    var articleURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
       // Set self to be the webView's delegate
        webView.navigationDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        
        // Check that there is a url
        if articleURL != nil {
            
            // Create the URL object
            if let url = URL(string: articleURL!) {
                
                // Create the URLRequest
                let request = URLRequest(url: url)
                
                // Start spinner
                loadingSpinner.alpha = 1
                loadingSpinner.startAnimating()
                
                // Load it into the webview
                webView.alpha = 0
                webView.load(request)
            }
        }
        
    }

}

extension DetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // Stop the spinner and hide it
        
        loadingSpinner.stopAnimating()
        loadingSpinner.alpha = 0
        
        // Show the webView
        webView.alpha = 1
        
    }
    
}
