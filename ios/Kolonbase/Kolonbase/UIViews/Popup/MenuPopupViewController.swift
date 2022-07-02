//
//  MenuPopupViewController.swift
//  ikenappmodule
//
//  Created by mk on 2020/10/19.
//

import UIKit

public class FloatingMenuViewController: UIViewController {

	@IBOutlet weak var baseView: UIView!
	
	public override func loadView() {
		
		super.loadView()
		
		let className = String(describing: FloatingMenuViewController.self)
		
		if let bundle = Bundle(identifier: bundleId),
		   let nib = bundle.loadNibNamed(className, owner: self),
		   let nibView = nib.first as? UIView {
			
			view = nibView
		}
	}
	
	public override func viewDidLoad() {
		
        super.viewDidLoad()
		
		// Set UI
		if let b = baseView {
			
			//b.frame.size.width = SCREEN_WIDTH - (DEFAULT_WIDTH * 2)
			//b.center = view.center
		}

        return
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
	
	@IBAction func closeButtonTouchUpInside(_ sender: UIButton) {
		
		dismiss(animated: true, completion: nil)
		
		return
	}
}
