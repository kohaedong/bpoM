//  Desc : 리스트 선택 팝업
//
//  SelectPopupViewController.swift
//  Kolonbase
//
//  Created by 이가람 on 2021/07/08.
//

import UIKit

public class SelectPopupViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var doneView: UIView!
    
    var sender: UIViewController?
    public var titleString : String?
    public var doneButtonHandler: (() -> Void)?
    public var selectedHandler: ((Int) -> Void)?

    var items : [String] = []
    
    public func initWith(items: [String],
                         sender: UIViewController? = nil,
                         title : String? = nil,
                         isEdit : Bool? = false,
                         closed: (() -> Void)? = nil,
                         selected: ((Int) -> Void)? = nil) -> SelectPopupViewController? {
        
        var className = String(describing: SelectPopupViewController.self)
        let bundle = Bundle(identifier: baseBundleId)
        let storyboard = UIStoryboard(name: className, bundle: bundle)
        if isEdit == true{
            className = String(describing: SelectPopupViewController.self) + "_Edit"
        }
        if let vc = storyboard.instantiateViewController(withIdentifier: className) as? SelectPopupViewController{
            vc.items = items
            vc.sender = sender
            vc.titleString = title
            vc.doneButtonHandler = closed
            vc.selectedHandler = selected
            return vc
        }
        return nil
    }
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.isHidden = titleString == nil
        doneView.isHidden = doneButtonHandler == nil
        
        if let title = titleString {
            titleLabel.text = title
        }
        
        if items.count == 1 {
            //레드마인 #10075
            tableViewHeightConst.constant = 59
        }
        else{
            tableViewHeightConst.constant = CGFloat((items.count * 40) + 33)
        }
    }
        
    public func show() {
        
        self.modalPresentationStyle = .custom
        self.modalTransitionStyle = .crossDissolve

        if let vc = UIApplication.shared.getCurrentViewController() {
            vc.present(self, animated: false, completion: nil)
        }
    }
    
    @IBAction func doneButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: false) {
            if let action = self.doneButtonHandler {
                action()
            }
        }
    }
}

extension SelectPopupViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPopupTableVIewCell", for: indexPath)
        let label = cell.viewWithTag(100) as! UILabel
        label.text = items[indexPath.row]
        
        //레드마인 #10079, #10137
        if let lineView = cell.viewWithTag(200){
            if items.count == 1{
                lineView.isHidden = true
            }            
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: false) {
            if let action = self.selectedHandler {
                action(indexPath.row)
            }
        }
    }
}
