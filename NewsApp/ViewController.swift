import UIKit
import CoreData
class ViewController: UIViewController {
    var selectedCategoryIndex : IndexPath = IndexPath(item: 0, section: 0)
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var searchBarText: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var model = ArticleModel()
    var articles = [ArticleEntity]()
    var category = Category.categories[0]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for image and text in search bar
        let imageIcon = UIImageView()
        imageIcon.image = UIImage(named: "search")
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "search")!.size.width/15, height: UIImage(named: "search")!.size.height/15)
        imageIcon.frame = CGRect(x: 0, y: 0, width: UIImage(named: "search")!.size.width/15, height: UIImage(named: "search")!.size.height/15)
        searchBarText.leftView = contentView
        searchBarText.leftViewMode = .always
        searchBarText.clearButtonMode = .whileEditing
        // Set viewController as delegate and dataSource for tableView
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        //collection view delegate and datasource
        collectionView.delegate = self
        collectionView.dataSource = self
        // Get articles from article model
        model.delegate = self
        //deleteAllArticle()
        let result = CoreDataHandler.shared.getAllItemsAllSection()
        if(result.count == 0){
            for i in 0..<8 {
                model.getArticles(category: "\(Category.categories[i])")
            }
        }
        else{
            articles = result
            tableView.reloadData()
        }
        //for search
        searchBarText.addTarget(self, action: #selector(searchArticles), for: .editingChanged)
        
    }
    //objective c function for pull to refresh in tableview
    @objc func refresh(send: UIRefreshControl){
        deleteAllArticle()
        for i in 0..<8 {
            model.getArticles(category: "\(Category.categories[i])")
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    //objective c function for search
    @objc func searchArticles() {
        let test = searchBarText.text!
        print(test)
        if(test == ""){
            let result = CoreDataHandler.shared.getAllItemsAllSection()
            articles = result
            tableView.reloadData()
        }
        else{
            let result = CoreDataHandler.shared.getAllItemsBySearch(search: test)
            articles = result!
            tableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the index path of the row the user clicked on
        let indexPath = tableView.indexPathForSelectedRow
        guard indexPath != nil else {
            return
        }
        
        // Get the article the user selected
        let articleChosen = articles[indexPath!.row]
        
        // Get a reference to the detailViewController
        let detailVC = segue.destination as! DetailViewController
        
        // Pass the article to the detail view controller
        if let url = articleChosen.url {
            detailVC.articleURL = url
        }
        
    }
}

// MARK: - Article Model Delegate Methods
extension ViewController: ArticleModelProtocol {
    func articlesRetrieved(_ articles: [ArticleEntity]) {
        self.articles = articles
        
        // Refresh table view to show new data
        tableView.reloadData()
        
    }
    
}


// MARK: - UITableView Delegate Methods
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Handle user interaction
        // Go to detail view
        performSegue(withIdentifier: "goToDetailView", sender: self)
    }
    
    func bookmarkNews(index: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let Bookmarkentity = NSEntityDescription.entity(forEntityName: "BookMarks", in : context)
        let Bookmarkrecord = NSManagedObject(entity: Bookmarkentity!, insertInto: context)
        Bookmarkrecord.setValue(articles[index.row].category, forKey: "category")
        Bookmarkrecord.setValue(articles[index.row].title, forKey: "title")
        Bookmarkrecord.setValue(articles[index.row].url, forKey: "url")
        Bookmarkrecord.setValue(articles[index.row].author, forKey: "author")
        Bookmarkrecord.setValue(articles[index.row].desc, forKey: "desc")
        Bookmarkrecord.setValue(articles[index.row].publishedAt, forKey: "publishedAt")
        Bookmarkrecord.setValue(articles[index.row].urlToImage, forKey: "urlToImage")
        do {
            try context.save()
        } catch
            let error as NSError {
            print("Could not save. \(error),\(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "") { [weak self] (action, view, completionHandler) in
            self?.bookmarkNews(index: indexPath)
            completionHandler(true)
        }
        action.image = UIImage(systemName: "bookmark")
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

//TableView DataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(articles.count)
        return articles.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        // Get the article
        let articleToDisplay = articles[indexPath.row]
        cell.displayArticle(articleToDisplay)
        return cell
        
    }
    
}
//collectionview datasource
extension ViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView", for: indexPath) as! CustomCollectionViewCell
        collectionCell.collectionCellText.text = Category.categories[indexPath.row]
        
        if (selectedCategoryIndex == indexPath){
            collectionCell.collectionCellText.backgroundColor = .systemGreen
        }
        return collectionCell
        
    }
}
//collectionview delegate
extension ViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        cell?.collectionCellText.backgroundColor = .systemGreen
        selectedCategoryIndex = indexPath
        print(indexPath)
        if("\(Category.categories[indexPath.row])" == "All"){
            
            articles = CoreDataHandler.shared.getAllItemsAllSection()
            tableView.reloadData()
        }
        else {
            
            articles = CoreDataHandler.shared.getAllItems(category: "\(Category.categories[indexPath.row])")
            tableView.reloadData()
        }
        collectionView.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        cell?.collectionCellText.backgroundColor = .white
    }
    
    
}
//delete articles method
extension ViewController{
    func deleteAllArticle(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
        
    }
}






