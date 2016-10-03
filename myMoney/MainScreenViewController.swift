//
//  MainScreenViewController.swift
//  myMoney
//
//  Created by Мануэль on 02.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData
import Charts

class MainScreenViewController: UIViewController
{
    var managedContext: NSManagedObjectContext!
    
    var accounts: [Account] {
        
       let result = DataManager.sharedInstance().fetchData(forEntity: "Account", withSortKey: "currency", predicates: nil) as! [Account]
        
        return result
    }
    
    @IBOutlet weak var moneyTotalTextLabel:    UILabel!
    @IBOutlet weak var incomeTextLabel:        UILabel!
    @IBOutlet weak var expensesTextLabel:      UILabel!
    @IBOutlet weak var incomeCountLabel:       UILabel!
    @IBOutlet weak var moneyTotalCountLabel:   UILabel!
    @IBOutlet weak var expensesCountLabel:     UILabel!
    @IBOutlet weak var tableView:              UITableView!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var chartView:              PieChartView!

    
    let articleCatalog     = AllCatalogs.sharedInstance().catalogArticle
    let catalogExpenditure = AllCatalogs.sharedInstance().catalogExpenditure
    
    @IBAction func addNewIncome(_ sender: UIButton) {
        addIncome()
    }
    
    @IBAction func addNewExpense(_ sender: UIButton) {
        addCheck()
    }
    
    @IBAction func reportPerodChanged(_ sender: UISegmentedControl) {
        changeReportPeriod()
        savePeriod()        
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navController = segue.destination as! UINavigationController
        
        let controller = navController.viewControllers.first as! CheckViewController
        
        controller.managedContext = managedContext
       
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let accountCellNib = UINib(nibName: "AccountTableViewCell", bundle: nil)
        
        tableView.register(accountCellNib, forCellReuseIdentifier: "AccountCell")        
        
        loadPeriod()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
        
        updateTotalMoneyInfo()
        
        changeReportPeriod()
    }
    
    func addCheck() {
       
        performSegue(withIdentifier: "AddNewExpense", sender: nil)       
    }
    
    func addIncome() {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "Income") as! IncomeViewController
        
        controller.managedContext = managedContext
        
        present(controller, animated: true, completion: nil)
        
    }
    
    func changeReportPeriod() {
        
        let commonIncomeText  = "Income This"
        let commonExpenseText = "Expense This"
        
        var period: ReportCurrentPeriod? = nil
        
        switch periodSegmentedControl.selectedSegmentIndex
        {
        case 0:
            incomeTextLabel.text   = "\(commonIncomeText ) \(ReportCurrentPeriod.Day.rawValue)"
            expensesTextLabel.text = "\(commonExpenseText) \(ReportCurrentPeriod.Day.rawValue)"
            
            period = ReportCurrentPeriod.Day
            
        case 1:
            incomeTextLabel.text   = "\(commonIncomeText ) \(ReportCurrentPeriod.Week.rawValue)"
            expensesTextLabel.text = "\(commonExpenseText) \(ReportCurrentPeriod.Week.rawValue)"
            
            period = ReportCurrentPeriod.Week
            
        case 2:
            incomeTextLabel.text   = "\(commonIncomeText ) \(ReportCurrentPeriod.Month.rawValue)"
            expensesTextLabel.text = "\(commonExpenseText) \(ReportCurrentPeriod.Month.rawValue)"
            
            period = ReportCurrentPeriod.Month
            
        default:
            break
        }
        
        guard period != nil else { return }
        
        let incomeTotal  = calculateMoneyFlowForCurrentPeriod(period!, flowKind: .adding)
        let expenseTotal = calculateMoneyFlowForCurrentPeriod(period!, flowKind: .substracting)
        
        incomeCountLabel.text   = "\(prettyStringFrom(incomeTotal))"
        expensesCountLabel.text = "\(prettyStringFrom(expenseTotal))"
    }
    
    //Saving index of Period Segmented control
    func savePeriod() {
        
        let defaults = UserDefaults.standard
        
        defaults.set(periodSegmentedControl.selectedSegmentIndex, forKey: "Period")
    }
    
    //Loads index of Period Segmented control
    func loadPeriod() {
        
        let defaults = UserDefaults.standard
        
        let index = defaults.integer(forKey: "Period")
        
        periodSegmentedControl.selectedSegmentIndex = index
    }
    
    //Counting total money for label view
    func updateTotalMoneyInfo() {
        
        var totalMoney: Double = 0
        
        for account in accounts
        {
            totalMoney += account.accountBalance()
        }
        
        moneyTotalCountLabel.text = prettyStringFrom(totalMoney)
    }    
    
    //Calculates income and expense for chosen period
    func calculateMoneyFlowForCurrentPeriod(_ period: ReportCurrentPeriod, flowKind: RegistratorKind) -> Double {
        
        var predicates = [NSPredicate]()
        
        let predicateAdd       = NSPredicate(format: "kind=%d",  RegistratorKind.adding.rawValue)
        let predicateSubstract = NSPredicate(format: "kind=%d",  RegistratorKind.substracting.rawValue)
        
        flowKind == .adding ? predicates.append(predicateAdd) : predicates.append(predicateSubstract)
        
        switch period
        {
        case .Day:
            let thisDay = currentPeriodBorder(.Day)
            
            predicates.append(contentsOf:formArrayOfPredicatesFor(thisDay))
            
        case .Week:
            let thisWeek = currentPeriodBorder(.Week)
            
            predicates.append(contentsOf: formArrayOfPredicatesFor(thisWeek))
            
        case .Month:
            
            let thisMonth = currentPeriodBorder(.Month)
            
            predicates.append(contentsOf: formArrayOfPredicatesFor(thisMonth))
        }
        
        let result = DataManager.sharedInstance().fetchData(forEntity: "RegisterLine", withSortKey: nil, predicates: predicates) as! [RegisterLine] // 3) We will fetch registered in documents for our needs
        
        var total: Double = 0
        
        for regLine in result
        {
            total += regLine.resource.doubleValue
        }
        
        return total
    }
    
    func formArrayOfPredicatesFor(_ currentPeriod: (periodStart: NSDate, periodEnd: NSDate)) -> [NSPredicate] {
        
        let predicate  = NSPredicate(format: "date>=%@", currentPeriod.periodStart) // 1) if date of the documents is more than current day's begin time
        let predicate2 = NSPredicate(format: "date<=%@", currentPeriod.periodEnd)   // 2) and if date of the documents is less than current day's end time
        
        return [predicate, predicate2]
    }
}

// MARK: >> EXT - UITableViewDelegate
extension MainScreenViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let account = accounts[(indexPath as NSIndexPath).row]
        
        account.makeMain()
        
        tableView.reloadData()
        
        try! managedContext.save()
    }
}

// MARK: >> EXT - UITableViewDataSource
extension MainScreenViewController: UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return accounts.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let account = accounts[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell") as! AccountTableViewCell
        
        cell.accessoryType            = account.main ? .checkmark : .none
        cell.accountNameLabel.text    = account.name
        cell.accountBalanceLabel.text = prettyStringFrom(account.accountBalance())
        
        return cell
    }
    
}


