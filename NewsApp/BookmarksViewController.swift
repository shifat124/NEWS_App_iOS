//
//  BookmarksViewController.swift
//  NewsApp
//
//  Created by BJIT on 28/10/1401 AP.
//

import UIKit
import CoreData
import SDWebImage
class BookmarksViewController: UIViewController {
    @IBOutlet weak var bookSearchBarText: UITextField!
    @IBOutlet weak var bookTableView: UITableView!
    var bookmarks = [BookMarks]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageIcon = UIImageView()
        imageIcon.image = UIImage(named: "search")
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "search")!.size.width/15, height: UIImage(named: "search")!.size.height/15)
        imageIcon.frame = CGRect(x: 0, y: 0, width: UIImage(named: "search")!.size.width/15, height: UIImage(named: "search")!.size.height/15)
        bookSearchBarText.leftView = contentView
        bookSearchBarText.leftViewMode = .always
        bookSearchBarText.clearButtonMode = .whileEditing
        bookTableView.delegate = self
        bookTableView.dataSource = self
        bookmarks = getAllBookmarks()!
        bookTableView.reloadData()
        //search for bookmark page
        bookSearchBarText.addTarget(self, action: #selector(searchBookmarkedArticles), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bookmarks = getAllBookmarks()!
        bookTableView.reloadData()
    }
    
    @objc func searchBookmarkedArticles() {
        let test = bookSearchBarText.text!
        print(test)
        if(test == ""){
            let result = getAllBookmarks()
            bookmarks = result!
            bookTableView.reloadData()
        }
        else{
            let result = getAllMarkedItemsBySearch(search: test)
            bookmarks = result!
            bookTableView.reloadData()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the index path of the row the user clicked on
        let indexPath = bookTableView.indexPathForSelectedRow
        guard indexPath != nil else {
            return
        }
        
        // Get the article the user selected
        let articleChosen = bookmarks[indexPath!.row]
        
        // Get a reference to the detailViewController
        let detailVC = segue.destination as! DetailViewController
        
        // Pass the article to the detail view controller
        if let url = articleChosen.url {
            detailVC.articleURL = url
        }
        
    }
    func getAllBookmarks() -> [BookMarks]?  {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            let fetchRequest = NSFetchRequest<BookMarks>(entityName: "BookMarks")
            let bookmarkAll = try context.fetch(fetchRequest)
            return bookmarkAll
        }catch{
            print("cant fetch from core")
        }
        return nil
    }
    func getAllMarkedItemsBySearch(search: String) -> [BookMarks]?  {
        do{
            let fetchRequest = NSFetchRequest<BookMarks>(entityName: "BookMarks")
            let predicate = NSPredicate(format: "title CONTAINS [c] %@", search)
            fetchRequest.predicate = predicate
            
            bookmarks = try context.fetch(fetchRequest)
            return bookmarks
        } catch{
            print(error)
        }
        return nil
    }
    
    func removeBookmarkNews(index: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let BookmarkContext = appDelegate.persistentContainer.viewContext
        NSEntityDescription.entity(forEntityName: "Bookmarks", in : BookmarkContext)
        let objectToDelete = bookmarks[index.row]
        BookmarkContext.delete(objectToDelete)
        do {
            try BookmarkContext.save()
            self.bookmarks = getAllBookmarks()!
            bookTableView.reloadData()
        } catch
            let error as NSError {
            print("Could not delete. \(error),\(error.userInfo)")
        }
        
    }
}
extension BookmarksViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "bookToWebView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "") { [weak self] (action, view, completionHandler) in
            self?.removeBookmarkNews(index: indexPath)
            completionHandler(true)
        }
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! bookmarkCell
        
        let image = bookmarks[indexPath.row].urlToImage
        if let image = image {
            cell.bookImage.sd_setImage(with: URL(string: image))
        }
        cell.bookLabel.text = bookmarks[indexPath.row].title
        return cell
    }
}
