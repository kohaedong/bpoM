//
//  MemberSearchViewController.swift
//  Kolonbase
//
//  Created by mk on 2020/11/06.
//

import UIKit

public protocol MemberSearchViewControllerDelegate {
	
	func selectedEntranceApprover(user: EntranceApproverItem)
}

public class MemberSearchViewController: UIViewController {
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var searchTableView: UITableView!
	
	
	public var delegate: MemberSearchViewControllerDelegate?
	
	public var selectedCheckButton: UIButton?
	
	public enum InquiryMode { case member_search; case entrance_approver; case oisuggession_approver; }
	public var inquiryMode = InquiryMode.member_search
	
	public enum ViewStatus { case search; case result; }
	public var viewStatus = ViewStatus.search
	
	var searchList: [String]?	// 검색어 리스트
	
	// 멤버 조회 리스트
	var memberList: [MemberItem]? { didSet { DispatchQueue.main.async { self.searchTableView.reloadData() }}}
	// 출입관리 승인자 조회 리스트
	var entranceApproverList: [EntranceApproverItem]? { didSet { DispatchQueue.main.async { self.searchTableView.reloadData() }}}
	
	public override func viewDidLoad() {
		
        super.viewDidLoad()
		
		if inquiryMode == .entrance_approver && viewStatus == .result {
			
			KB.Member.searchApproverTeamLeaderAPI() { [self] items in
				
				if items.count == 1 {
					
					// 승인자 정보가 1건 존재 시 바로 표시
					self.entranceApproverList = items
				}
				else {
					
					// 승인자 정보가 2건 이상이거나 0건 일 경우 빈 항목으로 표시
					// 2건 이상일 경우 검색어 처리
					self.entranceApproverList = items.filter {
						let searchText = searchBar.text ?? ""
						return $0.emp_name.contains(searchText) || $0.dept_name.contains(searchText)
					}
				}
			}
		}

        return
    }
	
	public override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		
		// 검색 리스트 가져오기
		searchList = KB.UserData.listSearchItems()
		
		return
	}
    

    // MARK: - Navigation

	public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		switch segue.destination {
			
			case let vc as MemberDetailViewController:
				vc.member = sender as? MemberItem
				
			default:
				break
		}
    }
	
	
	// MARK: - UIButton Actions
	
	@IBAction func closeButtonTouchUpInside(_ sender: UIButton) {
		
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func checkButtonTouchUpInside(_ sender: UIButton) {
		
		selectedCheckButton?.isSelected = false
		selectedCheckButton = sender
		selectedCheckButton?.isSelected = true
	}
	
	
	// MARK: - UIView Event
	
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		// Keyboard Hide
		view.endEditing(true)
	}
}


// MARK: - UITableView
extension MemberSearchViewController: UISearchBarDelegate {
	
	public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		guard searchText.count >= 2 else {
			
			viewStatus = .search
			searchTableView.reloadData()
			
			return
		}
		
		// 결과 처리
		switch inquiryMode {
		
			case .member_search:
				KB.Member.searchMemberDataAPI(text: searchText) { items in
					
					self.viewStatus = .result
					self.memberList = items
					
					// 검색어 저장
					if self.memberList?.count ?? 0 > 0 && searchText.count >= 2 {
						
						self.searchList = KB.UserData.addSearchItem(string: searchText)
					}
				}
				
			case .entrance_approver:
				KB.Member.searchApproverTeamLeaderAPI() { items in
					
					self.viewStatus = .result
					self.entranceApproverList = items
					
					// 검색어 저장
					if self.memberList?.count ?? 0 > 0 && searchText.count >= 2 {
						
						self.searchList = KB.UserData.addSearchItem(string: searchText)
					}
				}
				
			default:
				break
		}
		
		
		return
	}
}

extension MemberSearchViewController: SearchTextTableViewHeaderCellDelegate {
	
	func deleteAllSearchList() {
		
		searchList = KB.UserData.deleteAllSearchList()
		
		searchTableView.reloadData()
	}
}

extension MemberSearchViewController: SearchTextTableViewCellDelegate {
	
	func deleteSearchedText(index: Int) {
		
		searchList = KB.UserData.deleteSearchList(index: index)
		
		searchTableView.reloadData()
	}
}


// MARK: - UITableView
protocol SearchTextTableViewHeaderCellDelegate {
	
	func deleteAllSearchList()
}

class SearchTextTableViewHeaderCell: UITableViewCell {
	
	var delegate: SearchTextTableViewHeaderCellDelegate?
	
	@IBAction func deleteAllButtonTouchUpInside(_ sender: UIButton) {
		
		delegate?.deleteAllSearchList()
		
		return
	}
}

protocol SearchTextTableViewCellDelegate {
	
	func deleteSearchedText(index: Int)
}

class SearchTextTableViewCell: UITableViewCell {
	
	@IBOutlet weak var searchTextLabel: UILabel!
	
	var delegate: SearchTextTableViewCellDelegate?
	var index = 0
	
	@IBAction func deleteButtonTouchUpInside(_ sender: UIButton) {
		
		delegate?.deleteSearchedText(index: index)
		
		return
	}
}

class SearchResultTableViewHeaderCell: UITableViewCell {
	
	@IBOutlet weak var resultCountLabel: UILabel!
}

class SearchResultTableViewCell: UITableViewCell {
	
	@IBOutlet weak var memberButton: UIButton!
	@IBOutlet weak var memberNameLabel: UILabel!
	@IBOutlet weak var memberTitleLabel: UILabel!
	@IBOutlet weak var memberGroupLabel: UILabel!
	
	@IBOutlet weak var checkButton: UIButton!
}

extension MemberSearchViewController: UITableViewDataSource {
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		
		return 1
	}
	
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		return 44
	}
	
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		if viewStatus == .search {
			
			let headerCell = tableView.dequeueReusableCell(withIdentifier: "SearchTextTableViewHeaderCell") as! SearchTextTableViewHeaderCell
			headerCell.backgroundColor = .clear
			headerCell.delegate = self
			
			return headerCell
		}
		else {	// if mode == .result {
			
			var count = 0
			
			switch inquiryMode {
			
				case .member_search:
					count = memberList?.count ?? 0
					
				case .entrance_approver:
					count = entranceApproverList?.count ?? 0
					
				default:
					break
			}
			
			let headerCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewHeaderCell") as! SearchResultTableViewHeaderCell
			headerCell.backgroundColor = .clear
			headerCell.resultCountLabel.text = "검색결과 \(count)건"
			
			return headerCell
		}
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		var count = 0
		
		if viewStatus == .search {
			
			count = searchList?.count ?? 0
		}
		else {
			
			switch inquiryMode {
			
				case .member_search:
					count = memberList?.count ?? 0
					
				case .entrance_approver:
					count = entranceApproverList?.count ?? 0
					
				default:
					break
			}
		}
		
		return count
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return viewStatus == .search ? 44: 88
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if viewStatus == .search {
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTextTableViewCell", for: indexPath) as! SearchTextTableViewCell
			cell.delegate = self
			cell.index = indexPath.row
			
			if let item = searchList?[cell.index] {
				
				cell.searchTextLabel.text = item
			}
			
			return cell
		}
		else {	// if mode == .result {
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
			
			switch inquiryMode {
			
				case .member_search:
					
					let index = indexPath.row
					
					if let item = memberList?[index] {
						
						let image = UIImage(named: "icon-outlined-24-px-person")
						cell.memberButton.setImage(image, for: .normal)
						
						cell.memberNameLabel.text = item.userName
						cell.memberTitleLabel.text = item.titleName
						cell.memberGroupLabel.text = item.deptName
						
						cell.checkButton.isHidden = true
					}
					
				case .entrance_approver:
					
					let index = indexPath.row
					
					if let item = entranceApproverList?[index] {
						
						let image = UIImage(named: "icon-outlined-24-px-person")
						cell.memberButton.setImage(image, for: .normal)
						
						cell.memberNameLabel.text = item.emp_name
						cell.memberTitleLabel.text = ""
						cell.memberGroupLabel.text = "\(item.dept_name) | \(item.companyname)"
						
						cell.checkButton.isHidden = false
						cell.checkButton.isSelected = entranceApproverList?.count ?? 0 == 1 ? true: false
					}
					
				default:
					break
			}
			
			return cell
		}
	}
}

extension MemberSearchViewController: UITableViewDelegate {
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if viewStatus == .search {
			
			let index = indexPath.row
			
			if let item = searchList?[index] {
				
				searchBar(searchBar, textDidChange: item)
			}
		}
		else {	// if mode == .result {
			
			switch inquiryMode {
			
				case .member_search:
					// 임직원 조회 모드
					let index = indexPath.row
					let item = memberList?[index]
					performSegue(withIdentifier: "MemberDetailViewControllerSegue", sender: item)
					
				case .entrance_approver:
					// 출입관리 승인자 조회 모드
					let index = indexPath.row
					if let item = entranceApproverList?[index] {
						delegate?.selectedEntranceApprover(user: item)
						DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
					}
					
				default:
					break
			}
		}
		
		return
	}
	
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		// Keyboard Hide
		view.endEditing(true)
	}
}
