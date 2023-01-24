//
//  ArticleEntity+CoreDataProperties.swift
//  NewsApp
//
//  Created by BJIT on 26/10/1401 AP.
//
//

import Foundation
import CoreData


extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var category: String?
    @NSManaged public var desc: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

extension ArticleEntity : Identifiable {

}
