//
//  Protocols.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum CollectionViewToFetch: String
{
    case Articles = "ArticleCollectionView"
    case Groups   = "ArticleGroupsCollectionView"
}

enum ReportCurrentPeriod: String
{
    case Day     = "Day"
    case Week    = "Week"
    case Month   = "Month"
}

enum DocumentPresentationMode
{
    case documentEditMode
    case documentNewMode
}

enum ElementPresentationMode: Int
{
    case elementEditMode
    case elementNewMode
}

enum DocumentType
{  
    case documentExpenditureType
}

enum PopUpElementType
{
    case elementArticleType
    case elementAccountType
    case elementAccountListType
    case elementArticleGroupType
}

struct Constants  //TODO: RENAME THIS!
{
    static let expenditureName = "Expenditure"
    static let incomeName      = "Income"
}

func prettyStringFrom(_ doubleValue: Double) -> String {
    
    let resultString = String(format: "%.2f", doubleValue)
    
    return resultString    
}

func prettyStringFrom(_ dateValue: Date) -> String {
    
    let formatter = DateFormatter()
    
    formatter.dateFormat = "d MMMM hh:mm"
    
    return formatter.string(from: dateValue)
}

//Calculates begin and end of chosen period
func currentPeriodBorder(_ period: ReportCurrentPeriod) -> (periodStart: NSDate, periodEnd: NSDate) {
    
    let calendar = NSCalendar.current
    
    var periodStart: NSDate? = nil
    var periodEnd:   NSDate? = nil
    
    var interval: TimeInterval = 0
    
    var unitPeriod: NSCalendar.Unit?
    
    switch period
    {
    case .Day:
        unitPeriod = NSCalendar.Unit.day
        
    case .Week:
        unitPeriod = NSCalendar.Unit.weekOfMonth
        
    case .Month:
        unitPeriod = NSCalendar.Unit.month
    }
    
    (calendar as NSCalendar).range(of: unitPeriod!, start: &periodStart, interval: &interval, for: Date())
    
    periodEnd = periodStart!.addingTimeInterval(interval - 1)
    
    return (periodStart!, periodEnd!)
}

//Instantiates fetch controller for controlling a collection view, or a table view with certain entity
func instantiateFetchControllerWithRequest(entity name: String, predicate: NSPredicate?, forDelegate delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<NSFetchRequestResult> {
    
    let managedContext = DataManager.sharedInstance().context
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
    
    request.sortDescriptors = []
    
    if let predicate = predicate
    {
        request.predicate = predicate
    }
    
    let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    
    controller.delegate = delegate
        
    do
    {
        try controller.performFetch()
    }
    catch
    {
        print(error)
    }
    
    return controller
}




