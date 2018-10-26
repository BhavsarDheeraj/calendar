//
//  CalendarVars.swift
//  Calendar
//
//  Created by DHEERAJ BHAVSAR on 14/06/18.
//  Copyright © 2018 Dheeraj Bhavsar. All rights reserved.
//

import Foundation


let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day , from: date)
var weekday = calendar.component(.weekday, from: date) - 1
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)
