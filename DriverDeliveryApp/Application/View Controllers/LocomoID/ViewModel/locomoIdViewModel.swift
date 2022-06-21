//
//  locomoIdViewModel.swift
//  DriverApp
//
//  Created by Poonam  on 18/11/20.
//  Copyright © 2020 Seasia. All rights reserved.
//

import Foundation
protocol locomoIdDelegate
{
//    func TransportList(data: [Body]?)
//    func RegionList(data: [BodyRegion]?)
    func didError(error:String)
}
class locomoIdViewModel
{
    var view : LOCOMOIDVC
    var delegate : locomoIdDelegate
   typealias successHandler = (LOCOMOIDModel) -> Void

    init(Delegate : locomoIdDelegate, view : LOCOMOIDVC)
      {
          delegate = Delegate
          self.view = view
      }
    func getLocomoIDDetail(completion: @escaping successHandler){
        let urlPAth = APIAddress.companyDetail
        WebService.Shared.GetApi(url: urlPAth ,Target: self.view, showLoader: true, completionResponse: { (response) in
            print(response)
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let getAllListResponse = try JSONDecoder().decode(LOCOMOIDModel.self, from: jsonData)
                completion(getAllListResponse)
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
