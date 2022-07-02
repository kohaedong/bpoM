//  Desc : datePicker (date)
//
//  DateViewController.swift
//  IKEN-Work
//
//  Created by mk on 2021/02/26.
//

import UIKit

public enum KBDatePickerStyle : Int {
    case automatic = 0
    case wheels = 1
    case compact = 2
    @available(iOS 14.0, *)
    case inline = 3
    
    @available(iOS 13.4, *)
    func getPickerStyle() -> UIDatePickerStyle{
        switch self {
        case .automatic:
            return .automatic
        case .wheels:
            return .wheels
        case .compact:
            return .compact
        case .inline:
            if #available(iOS 14.0, *) {
                return .inline
            } else {
                return .automatic
            }
        }
    }
}

public class DateViewController: UIViewController {
	
	@IBOutlet weak var baseView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!{
        didSet{
            datePicker.locale = Locale(identifier: "ko-KR")
            //레드마인 #8886
            datePicker.calendar.locale = Locale(identifier: "ko-KR")
        }
    }
	
	
	var date: Date?
    var minimumDate: Date?
    var maximumDate: Date?
	var completionHandler: ((Date) -> Void)?
    var valueChangedHandler: ((Date) -> Void)?
	var sender: UIViewController?
	
    var datePickerStyle : KBDatePickerStyle?
    
	public convenience init(date: Date,
                            completion: ((Date) -> Void)? = nil,
                            valueChanged: ((Date) -> Void)? = nil,
                            minimumDate: Date? = nil,
                            maximumDate: Date? = nil,
                            datePickerStyle : KBDatePickerStyle? = nil,
                            sender: UIViewController? = nil) {
		
		self.init()
		
		self.date = date
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.datePickerStyle = datePickerStyle
		self.completionHandler = completion
        self.valueChangedHandler = valueChanged
		self.sender = sender
	}
	
	public override func loadView() {
		
		super.loadView()
		
		let className = String(describing: DateViewController.self)
		
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
		
		datePicker.date = date ?? Date()
        
        if let style = datePickerStyle{
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = style.getPickerStyle()
            }
        }        
        
        if let date = self.minimumDate {
            datePicker.minimumDate = date
        }
        if let date = self.maximumDate {
            datePicker.maximumDate = date
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
		
		let date = datePicker.date
		if let handle = completionHandler { handle(date) }
		
		dismiss(animated: false, completion: nil)
	}
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        if let handle = valueChangedHandler { handle(sender.date) }
    }
    
	
	// MARK: - UIView Event
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		dismiss(animated: false, completion: nil)
	}
}

extension DateViewController {
	
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
