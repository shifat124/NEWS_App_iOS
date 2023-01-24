

import Foundation

protocol ArticleModelProtocol {
    func articlesRetrieved(_ articles: [ArticleEntity])
    
}

class ArticleModel {
    
    
    var delegate: ArticleModelProtocol?
    
    func getArticles(category: String) {
        // Requ for Api creating string url
        let stringURL = "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&apiKey=e779788149b74268ae7d3edde3b448e7"
        //  URL object
        let url =  URL(string: stringURL)
        // Check URL
        guard url != nil else {
            print("URL does not created successfully")
            return
        }
        
        // Get URL session
        let session = URLSession.shared
        
        // Data Task creation
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error == nil && data != nil {
                // Parse the returned JSON into article instances
                let decoder = JSONDecoder()
                do {
                    let articleService = try decoder.decode(ArticleService.self, from: data!)
                    if let articleserviceArray = articleService.articles{
                        for i in 0..<(articleserviceArray.count){
                            CoreDataHandler.shared.createItem(author: articleserviceArray[i].author ?? "nil",
                                                              title: articleserviceArray[i].title ?? "nil",
                                                              description: articleserviceArray[i].description ?? "nil",
                                                              url: articleserviceArray[i].url ?? "nil",
                                                              urlToImage: articleserviceArray[i].urlToImage ?? "nil",
                                                              publishedAt: articleserviceArray[i].publishedAt ?? "nil",category: category)
                            
                        }
                        
                    }
                    else{
                        print("Data is not going in core data")
                    }
                    
                    
                    if let articles = articleService.articles {
                        // Pass it back to the viewController in a main thread
                        DispatchQueue.main.async {
                            print(type(of: articles))
                            let stored = CoreDataHandler.shared.getAllItems(category: category)
                            self.delegate?.articlesRetrieved(stored)
                        }
                    }
                    
                }catch {
                    print("Could not decode the json data")
                }
            }
            else{
                print("Creating Data Task Error!!")
            }
            
        }
        
        // Start the data task again
        dataTask.resume()
    }
}
