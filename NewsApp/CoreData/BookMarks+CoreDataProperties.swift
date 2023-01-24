//
//  BookMarks+CoreDataProperties.swift
//  NewsApp
//
//  Created by BJIT on 26/10/1401 AP.
//
//

import Foundation
import CoreData


extension BookMarks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookMarks> {
        return NSFetchRequest<BookMarks>(entityName: "BookMarks")
    }

    @NSManaged public var author: String?
    @NSManaged public var category: String?
    @NSManaged public var desc: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

extension BookMarks : Identifiable {

}
