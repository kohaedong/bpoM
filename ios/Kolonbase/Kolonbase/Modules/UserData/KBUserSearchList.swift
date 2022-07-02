//
//  KBUserSearchList.swift
//  Kolonbase
//
//  Created by mk on 2020/11/17.
//

import Foundation


// Search List
let SEARCH_LIST = "search_list"
extension KBUserData {
	
	public func listSearchItems() -> [String]? {
		
		// 검색 리스트 가져오기
		if let list = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: SEARCH_LIST) {
			
			searchedList = list as? [String]
			//print(searchedList)
		}
		
		return searchedList
	}
	
	public func addSearchItem(string: String) -> [String]? {
		
		// 검색 리스트에 검색어 추가하기
		if searchedList == nil {
			
			searchedList = [String]()
		}
		
		searchedList?.append(string)
		UserDefaults(suiteName: userDataSuiteName)?.set(searchedList, forKey: SEARCH_LIST)
		
		// Encrypt
//		if let string = searchedList?.joined(separator: "|") {
//
//			print(string)
//
//			let seal = KB.crypto.encryptAES(string)
//			print(seal.debugDescription)
//
//			UserDefaults(suiteName: userDataSuiteName)?.set(seal, forKey: SEARCH_LIST)
//		}
		
		return searchedList
	}
	
	public func deleteSearchList(index: Int) -> [String]? {
		
		// 검색 리스트에서 검색어 삭제하기
		searchedList?.remove(at: index)
		
		UserDefaults(suiteName: userDataSuiteName)?.set(searchedList, forKey: SEARCH_LIST)
		
		return searchedList
	}
	
	public func deleteAllSearchList() -> [String]? {
		
		// 검색 리스트에서 모든 검색어 삭제하기
		searchedList?.removeAll()
		
		UserDefaults(suiteName: userDataSuiteName)?.set(searchedList, forKey: SEARCH_LIST)
		
		return searchedList
		
	}
}
