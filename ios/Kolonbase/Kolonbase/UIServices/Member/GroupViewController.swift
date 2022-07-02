//  Desc : 임직원 조회
//
//  GroupViewController.swift
//  Kolonbase
//
//  Created by mk on 2020/11/06.
//

import UIKit

public class GroupViewController: UIViewController {
	
	@IBOutlet weak var groupTableView: UITableView!
	
	var groupList: [GroupItem]?
	var path: String?
	
	public override func viewDidLoad() {
		
        super.viewDidLoad()
		
//		if let path = path {
//
//			groupList = memberData?
//				.sorted(by: { $0.type < $1.type})
//				.filter({ $0.group?.range(of: path) != nil })
//		}
//		else {
//
//			// 루트 데이터
//			groupList = memberData?.filter({ $0.type == "group" && $0.group == nil })
//		}

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
	
	
	// MARK: - UIBarButtonItem Actions
	@IBAction func closeBarButtonItemAction(_ sender: UIBarButtonItem) {
		
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func searchBarButtonItemAction(_ sender: UIBarButtonItem) {
		
		performSegue(withIdentifier: "MemberSearchViewControllerSegue", sender: nil)
	}
	
	
	// MARK: - UIButton Actions
	@IBAction func closeButtonTouchUpInside(_ sender: UIButton) {
		
		dismiss(animated: true, completion: nil)
		
		return
	}
	
	@IBAction func searchTextRemoveAllButtonTouchUpInside(_ sender: UIButton) {
		
		return
	}
	
	
	// MARK: - UIView Event
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		// Keyboard Hide
		view.endEditing(true)
	}
}


// MARK: - UITableView
class GroupTableViewCell: UITableViewCell {
	
	@IBOutlet weak var groupNameLabel: UILabel!
	@IBOutlet weak var expandButton: UIButton!
	
	@IBAction func expandButtonTouchUpInside(_ sender: UIButton) {
		
	}
}

class MemberTableViewCell: UITableViewCell {
	
	@IBOutlet weak var groupButton: UIButton!
	@IBOutlet weak var groupNameLabel: UILabel!
	@IBOutlet weak var groupTitleLabel: UILabel!
	
	var groupDepth = 0
}

extension GroupViewController: UITableViewDataSource {
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		
		return 1
	}
	
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		return 0
	}
	
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let headerCell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewHeaderCell") as! GroupTableViewCell
		headerCell.backgroundColor = .clear
		
		return headerCell
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return groupList?.count ?? 0
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return 44
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
		
		let index = indexPath.row
		
		if let item = groupList?[index] {
			
			//let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .light, scale: .small)
			//let image = UIImage(systemName: "building", withConfiguration: largeConfig)
			let image = UIImage(named: "icon-outlined-24-px-person")
			cell.groupButton.setImage(image, for: .normal)
			
			cell.groupNameLabel.text = item.company?.companyName
			cell.groupTitleLabel.text = item.deptName
			
			cell.groupButton.frame.origin.x = 20
			cell.groupNameLabel.frame.origin.x = 84
			
			if let group = item.fullPath {
				
				let strings = group.split(separator: "/")
				//print(strings)
				
				cell.groupDepth = strings.count
				cell.groupButton.frame.origin.x += DEFAULT_WIDTH * CGFloat(strings.count)
				cell.groupNameLabel.frame.origin.x += DEFAULT_WIDTH * CGFloat(strings.count)
			}
		}
		
		return cell
	}
}

extension GroupViewController: UITableViewDelegate {
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let index = indexPath.row
		guard let item = groupList?[index] else { return }
		
		if item.parentCd == "LS" {
			
			// 그룹 처리
			setSubGroup(item: item, index: index)
		}
		else {
			
			// 개인 상세
			performSegue(withIdentifier: "MemberDetailViewControllerSegue", sender: item)
		}
		
		return
	}
	
	func setSubGroup(item: GroupItem, index: Int) {
		
		// Get Path
		var path = ""
		
		let name = item.company?.companyName ?? ""
		if let group = item.fullPath {
			
			path = "\(group)/\(name)"
		}
		else {
			
			path = "\(name)"
		}
		
		// Check Data
		if let existItems = groupList?.filter({ $0.fullPath == path }) {
			
			if existItems.count > 0 {
				
				// 기존 데이터 삭제
				groupList = groupList?.filter({ $0.fullPath?.range(of: path) == nil })
			}
			else {
				
				// 하위 데이터 추가
//				var offset = index
//				if let items = memberData?.filter({ $0.group == path }) {
//					
//					for item in items {
//						
//						offset += 1
//						groupList?.insert(item, at: offset)
//					}
//				}
			}
			
			groupTableView.reloadData()
		}
	}
	
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		// Keyboard Hide
		view.endEditing(true)
	}
}
