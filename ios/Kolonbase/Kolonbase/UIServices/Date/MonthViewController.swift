//  Desc : datePicker (Month)
//
//  MonthViewController.swift
//  IKEN-Work
//
//  Created by mk on 2021/02/26.
//

import UIKit

public class MonthViewController: UIViewController {
	
	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var monthLabel: UILabel!
	@IBOutlet weak var yyyymmPickerView: UIPickerView!
	
	
	var yyyy: String?
	var mm: String?
	var completionHandler: ((String) -> Void)?
	var sender: UIViewController?
	
	
	public convenience init(yyyy: String? = nil, mm: String? = nil, completion: ((String) -> Void)? = nil, sender: UIViewController? = nil) {
		
		self.init()
		
		self.yyyy = yyyy
		self.mm = mm
		self.completionHandler = completion
		self.sender = sender
	}
	
	public override func loadView() {
		
		super.loadView()
		
		let className = String(describing: MonthViewController.self)
		
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
		
		// Set Date
		let today = Date()
		let year = today.formattedString(format: "yyyy")
		let month = today.formattedString(format: "MM").replacingOccurrences(of: "0", with: "")
		
        //상단에 표시되는 날짜가 변경됐어도 현재날짜로 셋팅되던 현상 수정
        if let getYear = yyyy, let getMonth = mm {
            monthLabel.text = "\(getYear)년 \(getMonth)월"
        }else{
            monthLabel.text = "\(year)년 \(month)월"
        }
        //
		
		if let y = Int(yyyy ?? year) {
			
			let index = y - 1950
			yyyymmPickerView.selectRow(index, inComponent: 0, animated: false)
		}
		
		if let m = Int(mm ?? month) {
			
			let index = m - 1
			yyyymmPickerView.selectRow(index, inComponent: 1, animated: false)
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
		
		let yIndex = yyyymmPickerView.selectedRow(inComponent: 0)
		let mIndex = yyyymmPickerView.selectedRow(inComponent: 1)
		
		let yyyy = String(1950 + yIndex)
		let mm = mIndex + 1 < 10 ? String(format: "%02d", mIndex + 1 ): String(mIndex + 1)
		
		let string = "\(yyyy)-\(mm)"
		if let handle = completionHandler { handle(string) }
		
		dismiss(animated: false, completion: nil)
	}
	
	
	// MARK: - UIView Event
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		dismiss(animated: false, completion: nil)
	}
}


// MARK: - UIPickerView
extension MonthViewController: UIPickerViewDataSource {
	
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		
		return 2
	}
	
	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		var count = 0
		
		switch component {
		
			case 0:
				count = 100
				
			case 1:
				count = 12
				
			default:
				break
		}
		
		return count
	}
}

extension MonthViewController: UIPickerViewDelegate {
	
	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		var title = ""
		
		switch component {
		
			case 0:
				let year = "\(1950 + row) 년"
				title = String(year)
				
			case 1:
				let month = "\(1 +  row) 월"
				title = String(month)
				
			default:
				break
		}
		
		return title
	}
	
	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		let yIndex = yyyymmPickerView.selectedRow(inComponent: 0)
		let mIndex = yyyymmPickerView.selectedRow(inComponent: 1)
		
		let yyyy = 1950 + yIndex
		let mm = 1 + mIndex
		
		monthLabel.text = "\(yyyy)년 \(mm)월"
	}
}


// Mark: - Show Method
extension MonthViewController {
	
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
