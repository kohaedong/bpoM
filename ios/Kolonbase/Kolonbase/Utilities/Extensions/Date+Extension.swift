//
//  Date+Extension.swift
//  Kolonbase
//
//  Created by mk on 2020/11/03.
//

import Foundation

public extension Date {
	
	func startOfWeek(using calendar: Calendar = .gregorian) -> Date {
		
		// 한 주의 시작: 일요일
		var date = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
		
		// 이틀 전
		//var date = calendar.date(byAdding: .day, value: -2, to: self)!
		
		// + 9 Hous: UTC to Local
		date.addTimeInterval(32400)
		
		return date
	}
	
	func wednesdayOfWeek(using calendar: Calendar = .gregorian) -> Date {
		
		var date = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
		date.addTimeInterval(32400)		// + 9 Hous: UTC to Local
		date.addTimeInterval(259200)	// + 3 Days: Sun --> Wed
		
		return date
	}
	

	func formattedString(format: String) -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ko_KR")
		dateFormatter.dateFormat = format
		
		return dateFormatter.string(from: self)
	}
	
	func dayOfWeekString() -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ko_KR")
		dateFormatter.dateFormat = "e"
		
		var dayOfWeek = ""
		
		if let dayIndex = Int(dateFormatter.string(from: self)) {
			
			switch dayIndex {
				case 1: dayOfWeek = "일"
				case 2: dayOfWeek = "월"
				case 3: dayOfWeek = "화"
				case 4: dayOfWeek = "수"
				case 5: dayOfWeek = "목"
				case 6: dayOfWeek = "금"
				case 7: dayOfWeek = "토"
				default: dayOfWeek = "\(dayIndex)"
			}
		}
		
		return dayOfWeek
	}
	
	// MARK: - 날짜 연산자
	static func - (lhs: Date, rhs: Date) -> TimeInterval {
		
		return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
	}
}
