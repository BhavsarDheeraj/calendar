//
//  ViewController.swift
//  Calendar
//
//  Created by DHEERAJ BHAVSAR on 11/06/18.
//  Copyright © 2018 Dheeraj Bhavsar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Outlet to Calendar Collection View
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var MonthLabel: UILabel!
    
    let Months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    let DaysOfMonth = ["Monday","Thuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    var NumberOfEmptyBox = Int()
    
    var NextNumberOfEmptyBox = Int()
    
    var PreviousNumberOfEmptyBox = 0
    
    var Direction = 0
    
    var PositionIndex = 0
    
    var LeapYearCounter = 2
    
    var dayCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = Months[month]
        MonthLabel.text = "\(currentMonth) \(year)"
        if weekday == 0 {
            weekday = 7
        }
        GetStartDateDayPosition()
    }
    
    //Calculates the number of "empty" boxes at the start of every month
    
    func GetStartDateDayPosition() {
        switch Direction{
        case 0:
            NumberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter>0 {
                NumberOfEmptyBox = NumberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if NumberOfEmptyBox == 0 {
                    NumberOfEmptyBox = 7
                }
            }
            if NumberOfEmptyBox == 7 {
                NumberOfEmptyBox = 0
            }
            PositionIndex = NumberOfEmptyBox
        case 1...:
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
            PositionIndex = NextNumberOfEmptyBox
            
        case -1:
            PreviousNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex)%7)
            if PreviousNumberOfEmptyBox == 7 {
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    //--------------------------------------------------(Next and back buttons)-------------------------------------------------------------
    @IBAction func Next(_ sender: Any) {
        nextButtonPressed()
    }
    
    func nextButtonPressed() {
        switch currentMonth {
        case "December":
            Direction = 1
            
            month = 0
            year += 1
            
            if LeapYearCounter  < 5 {
                LeapYearCounter += 1
            }
            
            if LeapYearCounter == 4 {
                DaysInMonths[1] = 29
            }
            
            if LeapYearCounter == 5{
                LeapYearCounter = 1
                DaysInMonths[1] = 28
            }
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            
            Calendar.reloadData()
        default:
            Direction = 1
            
            GetStartDateDayPosition()
            
            month += 1
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            
            Calendar.reloadData()
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        backButtonPressed()
    }
    
    func backButtonPressed() {
        switch currentMonth {
        case "January":
            Direction = -1
            
            month = 11
            year -= 1
            
            if LeapYearCounter > 0{
                LeapYearCounter -= 1
            }
            if LeapYearCounter == 0{
                DaysInMonths[1] = 29
                LeapYearCounter = 4
            }else{
                DaysInMonths[1] = 28
            }
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
            
        default:
            Direction = -1
            
            month -= 1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    
    //----------------------------------(CollectionView)------------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction{
        case 0:
            return DaysInMonths[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        
//        cell.dateLabel.textColor = UIColor.black
        
        if cell.isHidden{
            cell.isHidden = false
        }
        
        var tempDate = ""
        
        switch Direction {      //the first cells that needs to be hidden (if needed) will be negative or zero so we can hide them
        case 0:
            tempDate = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        case 1:
            tempDate = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
        case -1:
            tempDate = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        //Request the moon and Other data here:
        
        
        
        cell.dateLabel.text = tempDate
        
        if Int(cell.dateLabel.text!)! < 1{ //here we hide the negative numbers or zero
            cell.isHidden = true
        }
        
//        switch indexPath.row { //weekend days color
//        case 5,6,12,13,19,20,26,27,33,34:
//            if Int(cell.dateLabel.text!)! > 0 {
//                cell.dateLabel.textColor = UIColor.lightGray
//            }
//        default:
//            break
//        }
        
        if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - NumberOfEmptyBox == day{
            //Current day implementation
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCollectionViewCell
        print("\(cell.dateLabel.text ?? "null") \(Months[month]) \(year)")
    }
    
    
    @IBAction func nextYearPressed(_ sender: UIButton) {
        var i = 0
        while i < 12 {
            nextButtonPressed()
            i += 1
        }
    }
    
    @IBAction func prevYearButtonPressed(_ sender: UIButton) {
        var i = 0
        while i < 12 {
            backButtonPressed()
            i += 1
        }
    }
    
    func myFunc() {
        
        
        
    }
    
    
}

