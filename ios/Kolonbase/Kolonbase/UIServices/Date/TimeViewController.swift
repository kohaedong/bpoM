//  Desc : datePicker (Time)
//
//  TimeViewController.swift
//  IKEN-Work
//
//  Created by mk on 2021/02/26.
//

import UIKit

public class TimeViewController: UIViewController {
	
	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var datePicker: UIDatePicker!
	
	
	var time: Date?
	var completionHandler: ((Date) -> Void)?
	var sender: UIViewController?
	
    var timeInterval = 0
    var minimumDate:Date? = nil
    var maximumDate:Date? = nil
	
    public convenience init(time: Date, completion: ((Date) -> Void)? = nil, sender: UIViewController? = nil, timeInterval: Int = 0, minimumDate: Date? = nil, maximumDate: Date? = nil) {
		
		self.init()
		
		self.time = time
		self.completionHandler = completion
		self.sender = sender
        
        self.timeInterval = timeInterval
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
	}
	
	public override func loadView() {
		
		super.loadView()
		
		let className = String(describing: TimeViewController.self)
		
		if let bundle = Bundle(identifier: baseBundleId),
		   let nib = bundle.loadNibNamed(className, owner: self),
		   let nibView = nib.first as? UIView {
			
			view = nibView
		}
	}
	
    public override func viewDidLoad() {
		
        super.viewDidLoad()
		
		// Set UI
		baseView.center = view.center
		
		datePicker.date = time ?? Date()
        
        if timeInterval != 0{
            datePicker.minuteInterval = timeInterval
        }
        if minimumDate != nil{
            datePicker.minimumDate = minimumDate
        }
        if maximumDate != nil{
            datePicker.maximumDate = maximumDate
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	
	// MARK: - UIButton Actions
	@IBAction func cancelButtonTouchUpInside(_ sender: UIButton) {
		
		dismiss(animated: false, completion: nil)
	}
	
	@IBAction func confirmButtonTouchUpInside(_ sender: UIButton) {
		
		let time = datePicker.date
		if let handle = completionHandler { handle(time) }
		
		dismiss(animated: false, completion: nil)
	}
	
	
	// MARK: - UIView Event
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		dismiss(animated: false, completion: nil)
	}
}


extension TimeViewController {
	
	public func show() {
		
		modalPresentationStyle = .overFullScreen
		modalTransitionStyle = .crossDissolve
		
		if let vc = sender {
			vc.present(self, animated: false, completion: nil)
		}
		else {
			if let vc = UIApplication.shared.getCurrentViewController() {
				vc.present(self, animated: false, completion: nil)
			}
		}
	}
}
