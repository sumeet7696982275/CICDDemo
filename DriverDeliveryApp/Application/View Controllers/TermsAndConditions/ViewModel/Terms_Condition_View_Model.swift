//
//  Terms_Condition_View_Model.swift
//  DriverDeliveryApp
//
//  Created by Sumeet Pal on 24/03/22.
//  Copyright © 2022 Navaldeep Kaur. All rights reserved.
//

import Foundation


protocol TermsConditionsDelegate
{
    func Show(msg: String)
    func didError(error:String)
}

class Terms_Conditions_View_Model{
    typealias successHandler = (TermsCondtion) -> Void
    var delegate : TermsConditionsDelegate
    var view : UIViewController
    
    init(Delegate : TermsConditionsDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }
    
    
    func getTermsConditionsListApi(completion: @escaping successHandler)
    {
        
        let url = "https://stgcerb.cerebruminfotech.com:9062/zigricart/mobile/document"
        WebService.Shared.GetApi(url: url,Target: self.view, showLoader: true, completionResponse: { (response) in
            print(response)
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let getAllListResponse = try JSONDecoder().decode(TermsCondtion.self, from: jsonData)
                completion(getAllListResponse)
                print(getAllListResponse)
            }
            catch
            {
                print(error.localizedDescription)
                self.view.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
            }
            
        }, completionnilResponse: {(error) in
            self.delegate.didError(error: error)
        })
    }
    
}



