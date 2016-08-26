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

enum TimeBorder: String
{
    case Begin = "00:00:00"
    case End   = "23:59:59"
}

enum ReportCurrentPeriod: String
{
    case Day     = "Day"
    case Week    = "Week"
    case Month   = "Month"
}

enum DocumentPresentationMode
{
    case DocumentEditMode
    case DocumentNewMode
}

enum PopUpElementPresentationMode
{
    case ElementEditMode
    case ElementNewMode
}

enum DocumentType
{  
    case DocumentExpenditureType
}

enum PopUpElementType
{
    case ElementArticleType
    case ElementAccountType
    case ElementAccountListType
}

struct Constants  //TODO: RENAME THIS!
{
    static let expenditureName = "Expenditure"
    static let incomeName      = "Income"
}

func prettyStringFrom(doubleValue: Double) -> String {
    
    let resultString = String(format: "%.2f", doubleValue)
    
    return resultString    
}

func prettyStringFrom(dateValue: NSDate) -> String {
    
    let formatter = NSDateFormatter()
    
    formatter.dateFormat = "d MMMM hh:mm"
    
    return formatter.stringFromDate(dateValue)
}

//Calculates begin and end of chosen period
func currentPeriodBorder(period: ReportCurrentPeriod) -> (periodStart: NSDate, periodEnd: NSDate) {
    
    let calendar = NSCalendar.currentCalendar()
    
    var periodStart: NSDate? = nil
    var periodEnd:   NSDate? = nil
    
    var interval: NSTimeInterval = 0
    
    var unitPeriod: NSCalendarUnit?
    
    switch period
    {
    case .Day:
        unitPeriod = NSCalendarUnit.Day
        
    case .Week:
        unitPeriod = NSCalendarUnit.WeekOfMonth
        
    case .Month:
        unitPeriod = NSCalendarUnit.Month
    }
    
    calendar.rangeOfUnit(unitPeriod!, startDate: &periodStart, interval: &interval, forDate: NSDate())
    
    periodEnd = periodStart!.dateByAddingTimeInterval(interval - 1)
    
    return (periodStart!, periodEnd!)
}






