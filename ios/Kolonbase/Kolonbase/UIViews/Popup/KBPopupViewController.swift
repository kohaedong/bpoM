//
//  KBPopupViewController.swift
//  Kolonbase
//
//  Created by 이가람 on 2021/06/23.
//

import UIKit

public class KBPopupViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.presentationController?.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension KBPopupViewController: UIAdaptivePresentationControllerDelegate{
    
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}
