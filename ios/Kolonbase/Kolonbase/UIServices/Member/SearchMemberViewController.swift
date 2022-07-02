//
//  SearchMemberViewController.swift
//  Kolonbase
//
//  Created by 이가람 on 2021/04/27.
//

import UIKit

public protocol SearchMemberViewControllerDelegate {
    
    func selectedMember(item: MemberItem)
}

public class SearchMemberViewController: UIViewController {

    public var searchKeyword : String?
    
    public var delegate: SearchMemberViewControllerDelegate?
    public var nameSearchValue : String? = "n"
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchCancelButton: UIButton!
    @IBOutlet weak var searchCancelView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topSearchHistoryView: UIView!
    
    @IBOutlet weak var searchResultCountLabel: UILabel!
    
    enum ViewStatus { case search; case result; }
    
    var viewStatus = ViewStatus.search {
        didSet{
            DispatchQueue.main.async { [self] in
                if viewStatus == .search{
                    searchResultCountLabel.text = ""
                }
                topSearchHistoryView.isHidden = (viewStatus == .result || (searchList?.count ?? 0 == 0))
                tableView.reloadData()
            }
        }
    }

    var searchList: [String]?{
        didSet{
            DispatchQueue.main.async { [self] in
                topSearchHistoryView.isHidden = (viewStatus == .result || (searchList?.count ?? 0 == 0))
                tableView.reloadData()
            }
        }
    }
    
    var memberList: [MemberItem]? {
        didSet {
            DispatchQueue.main.async { [self] in
                if let list = memberList{
                    searchResultCountLabel.text = "검색결과 \(list.count)건"
                }else{
                    searchResultCountLabel.text = ""
                }
                tableView.reloadData()
            }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchList = KB.UserData.listSearchItems()
        
        if let text = searchKeyword{
            searchTextField.text = text
            searchButtonTouchUpInside(nil)
        }
    }
    
    @IBAction func searchButtonTouchUpInside(_ sender: Any?) {
        guard let searchText = searchTextField.text else{
            return
        }

        searchTextField.endEditing(true)

        if searchText.count < 2 {
            ToastView(message: "2글자 이상 입력 시 검색이 가능합니다.").flash()
            return
        }
        
        searchCancelView.isHidden = false
        searchButton.isEnabled = !searchCancelView.isHidden

        KB.Member.searchMemberDataAPI(text: searchText, nameSearch: nameSearchValue) { items in
            self.viewStatus = .result
            
            self.memberList = items
            // 검색어 저장
            if self.memberList?.count ?? 0 > 0 &&
                searchText.count >= 2{
                
                let searchItem = KB.UserData.listSearchItems()
                
                if searchItem == nil {
                    self.searchList = KB.UserData.addSearchItem(string: searchText)
                }
                else{
                    if let filtered = searchItem?.filter({ $0 == searchText }),
                       filtered.count == 0 {
                        
                        self.searchList = KB.UserData.addSearchItem(string: searchText)
                    }
                }
            }

        }
    }
    
    @IBAction func allDeleteButtonTouchInside(_ sender: Any) {
        self.searchList = KB.UserData.deleteAllSearchList()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        searchCancelView.isHidden = true
        if sender.text?.count ?? 0 > 0 {
            searchCancelView.isHidden = false
        }
        searchButton.isEnabled = !searchCancelView.isHidden
    }
    
    @IBAction func searchCancelButtonTouchUpInside(_ sender: Any) {
        searchTextField.text = ""
        viewStatus = .search
        searchCancelView.isHidden = true
        searchButton.isEnabled = !searchCancelView.isHidden
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        
        guard let _ = navigationController?.popViewController(animated: true)
        else {
            dismiss(animated: true, completion: nil)
            return
        }
    }
    
    @objc func didSelectIndex(_ sender: UIButton) {
        
        //print("Menu Button Tag: ", sender.tag)
        
        let index = sender.tag
        
        if let item = memberList?[index]{
            
            DispatchQueue.main.async {
                sender.isSelected = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                if let nvc = self.navigationController{
                    nvc.popViewController(animated: true)
                    self.delegate?.selectedMember(item: item)
                }
                else {
                    self.dismiss(animated: true) {
                        self.delegate?.selectedMember(item: item)
                    }
                }
            }
        }
    }
    
}

class SearchMemberResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
            
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberTitleLabel: UILabel!
    @IBOutlet weak var memberGroupLabel: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
}

extension SearchMemberViewController : UITableViewDelegate, UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewStatus == .search {
            return searchList?.count ?? 0
        }else if viewStatus == .result{
            return memberList?.count ?? 0
        }else{
          return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewStatus == .search {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTextTableViewCell", for: indexPath) as! SearchTextTableViewCell
            cell.index = indexPath.row
            cell.delegate = self
            if let item = searchList?[cell.index] {
                cell.searchTextLabel.text = item
            }
            return cell


        }else if viewStatus == .result{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMemberResultTableViewCell", for: indexPath) as! SearchMemberResultTableViewCell
            
            cell.profileImageView?.image = nil

            if let item = memberList?[indexPath.row]{
                if let id = item.userAccount ,
                   let url = URL.init(string: "\(rest_host)/pic/getByUserAccount/\(id)"){
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    cell.profileImageView.image = image
                                }
                            }
                        }
                    }
                }
                
                cell.memberNameLabel.text = item.userName
                if let roleName = item.roleName, roleName.count > 0 {
                    cell.memberTitleLabel.text = (item.roleName ?? "") + "/" + (item.titleName ?? "")
                } else {
                    cell.memberTitleLabel.text = item.titleName
                }
                cell.memberGroupLabel.text = (item.deptName ?? "") + " | " + (item.companyName ?? "")
            }
            
            cell.checkButton.tag = indexPath.row
            cell.checkButton.addTarget(self, action: #selector(didSelectIndex(_:)), for: .touchUpInside)

            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMemberResultTableViewCell", for: indexPath) as! SearchMemberResultTableViewCell
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        if viewStatus == .search {
            
            if let item = searchList?[indexPath.row]{
                searchTextField.text = item
                searchCancelView.isHidden = false
                searchButtonTouchUpInside(nil)
            }
            
        }else if viewStatus == .result{
            
            if let item = memberList?[indexPath.row]{
                
                DispatchQueue.main.async {
                    if let cell = tableView.cellForRow(at: indexPath) as? SearchMemberResultTableViewCell {
                        cell.checkButton.isSelected = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    if let nvc = self.navigationController{
                        nvc.popViewController(animated: true)
                        self.delegate?.selectedMember(item: item)
                    }
                    else {
                        self.dismiss(animated: true) {
                            self.delegate?.selectedMember(item: item)
                        }
                    }
                }
            }
        }
    }
    
    
}

extension SearchMemberViewController: SearchTextTableViewCellDelegate {
    
    func deleteSearchedText(index: Int) {
        
        searchList = KB.UserData.deleteSearchList(index: index)
        
        tableView.reloadData()
    }
}


extension SearchMemberViewController: UITextFieldDelegate{
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        searchButtonTouchUpInside(nil)
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
