

import UIKit
import WebKit

class ArticleCell: UITableViewCell {
    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var articleImageView: UIImageView!
    var articleToDisplay: ArticleEntity?
    func displayArticle(_ article: ArticleEntity) {
        // Clean up dequeued cell before displaying
        articleImageView.image = nil
        articleImageView.alpha = 0
        headlineLabel.text = nil
        headlineLabel.alpha = 0
        // Keep a reference to the article
        articleToDisplay = article
        // Set the headline
        headlineLabel.text = articleToDisplay!.title
        // Animate the label into view
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.headlineLabel.alpha = 1
        }, completion: nil)
        
        // Download and display the image
        if let urlString = article.urlToImage {
            
            // Check the CacheManager dictionary before downloading image data
            if let imageData = CacheManager.retrieveData(urlString) {
                
                // We already have image data, set the image view and return
                articleImageView.image = UIImage(data: imageData)
                
                // Animate the image into view
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                    self.articleImageView.alpha = 1
                }, completion: nil)
                
                return
            }
            
            // Create URL
            let url = URL(string: urlString)
            
            // Check that URL isn't nil
            guard url != nil else {
                print("Could not get URL for article image")
                return
            }
            
            // Get session
            let session = URLSession.shared
            
            // Create data task
            let dataTask = session.dataTask(with: url!) { data, response, error in
                
                guard data != nil && error == nil else {
                    
                    return
                }
                
                // Save the data into the cache
                CacheManager.saveData(urlString, data!)
                
                // Check if the url string that the data task downloaded, matches the article this cell is set to display RIGHT NOW
                if self.articleToDisplay?.urlToImage == urlString {
                    
                    // Display image in main thread
                    DispatchQueue.main.async {
                        self.articleImageView.image = UIImage(data: data!)
                        
                        // Animate the label into view
                        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                            self.articleImageView.alpha = 1
                        }, completion: nil)
                        
                    }
                    
                }
            }
            
            // Start data task
            dataTask.resume()
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
