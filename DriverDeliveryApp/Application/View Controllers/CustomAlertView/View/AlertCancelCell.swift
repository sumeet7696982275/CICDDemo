//
//  AlertCancelCell.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 02/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit

class AlertCancelCell: UITableViewCell {

    @IBOutlet weak var btnSubmit: CustomButton!
    @IBOutlet weak var ktextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textReson: UITextView!
    @IBOutlet weak var kButtonHight: NSLayoutConstraint!
    @IBOutlet weak var btnRadio: UIButton!
    
    var viewDelegate :AlertCanacelDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textReson.delegate = self
        btnRadio.tintColor = Appcolor.kThemeColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnSubmitAction(_ sender: Any) {
        viewDelegate?.otherSelected(index:(sender as AnyObject).tag,message: textReson.text)
    }
    
  
}
//MARK:- TextViewDelegate

extension AlertCancelCell : UITextViewDelegate{
   
    func textViewShouldReturn(textView: UITextView!) -> Bool {
        textView.resignFirstResponder()
        return true;
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        textView.textColor = UIColor.black
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Enter here ..."
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
