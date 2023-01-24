//
//  CoreDataHandler.swift
//  NewsApp
//
//  Created by BJIT on 23/10/1401 AP.
//

import Foundation
import UIKit
import CoreData


class CoreDataHandler{
    static let shared = CoreDataHandler()
    private init(){}
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models = [ArticleEntity]()
    //core data part
    //getting items by fetching from category
    func getAllItems(category: String) -> [ArticleEntity]  {
        do{
            let fetchRequest = NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
            let predicate = NSPredicate(format: "category == %@", category)
            fetchRequest.predicate = predicate
            models = try context.fetch(fetchRequest)
        } catch{
            print(error)
        }
        return models
        
    }
    
    //Creating Items and saving on core data
    func createItem(author: String, title: String, description: String, url: String, urlToImage: String, publishedAt: String, category: String){
        let newItem = ArticleEntity(context: context)
        newItem.author = author
        newItem.title = title
        newItem.desc = description
        newItem.url = url
        newItem.urlToImage = urlToImage
        newItem.publishedAt = publishedAt
        newItem.category = category
        do{
            try context.save()
            
        } catch{
            print(error)
        }
        
    }
    //fetch all data from coredata
    func getAllItemsAllSection() -> [ArticleEntity]  {
        do{
            let fetchRequest = NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
            
            models = try context.fetch(fetchRequest)
            
            
        } catch{
            print(error)
        }
        return models
        
    }
    //search for main view page
    func getAllItemsBySearch(search: String) -> [ArticleEntity]?  {
        do{
            let fetchRequest = NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
            let predicate = NSPredicate(format: "title CONTAINS [c] %@", search)
            fetchRequest.predicate = predicate
            
            models = try context.fetch(fetchRequest)
            return models
        } catch{
            print(error)
        }
        return nil
    }
}





