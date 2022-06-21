//
//  ChangeStatusVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 11/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit
import HGRippleRadarView

class ChangeStatusVC: UIViewController {
    
    //MARK:- outlet and Variables
    // @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var viewScroll: UIScrollView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var btnStart: CustomButton!
    @IBOutlet weak var btnCompleted: CustomButton!
    @IBOutlet weak var viewCompleted: UIView!
    @IBOutlet weak var btnReached: CustomButton!
    @IBOutlet weak var lblAlertTitle: UILabel!
    @IBOutlet weak var viewReached: UIView!
    @IBOutlet weak var lblAlertMessage: UILabel!
    @IBOutlet weak var viewAlert: CustomUIView!
    @IBOutlet weak var viewOntheWay: UIView!
    @IBOutlet weak var btnOntheWay: UIButton!
    @IBOutlet weak var viewStartCurve: UIView!
    @IBOutlet weak var viewUserOnWay: UIView!
    // @IBOutlet weak var btnNavigation: UIBarButtonItem!
    @IBOutlet weak var imageCar: UIImageView!
    @IBOutlet weak var viewRipple: RippleView!
    @IBOutlet weak var btnNavigation: UIButton!
    
    let shapeLayer = CAShapeLayer()
    let shapeLayerforOnWay = CAShapeLayer()
    let shapeLayerReached = CAShapeLayer()
    let shapeLayerCompleted = CAShapeLayer()
    var isStartClicked = false
    var isReachedClick = false
    var isOwnWayclicked = false
    var isCompletedClick = false
    var trackStatus = 0
    var orderId : String?
    var viewModel:HomeViewModel?
    var trankStatusfromApi:Int?
    var currentStatus:Int?
    var startImageView:UIImageView = UIImageView()
    var onWayImageView:UIImageView = UIImageView()
    var reachedImageView:UIImageView = UIImageView()
    var completedImageView:UIImageView = UIImageView()
    var timerStart,timeOnWay,timeReached,timeCompleted : Timer?
    var lineOnWay,lineCompleted:Timer?
    let image = UIImage(named: "deliveryBoy")
    var tap = UITapGestureRecognizer()
    var isUserOwnWay = false
    var isUserOnCompleted = false
    var destinationlat:Double?
    var destinationlog:Double?
    var sourcelat:Double?
    var sourcelog:Double?
    var modelName :String?
    var price:String?
    var paymentType : Int?
    var otp:String?
    var imgURL:URL!
    
    
    @IBOutlet weak var imageDownArrow: UIImageView!
    
    //MARK:- life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelName = UIDevice.modelName
        print(modelName)
        
        
        getStatus()
        setView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK:- Hit api
    func getStatus()
    {
        viewModel?.getStatusListApi(completion: { (data) in
            if let response = data.body
            {
                if response.count > 0
                {
                    for data in response{
                        if data.statusName == ""
                        {
                            
                        }
                    }
                }
            }
        })
    }
    //MARK:- Other functions
    
    func animate(_ image: UIImageView) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveLinear],
                       animations: {image.center.x -= 10},
                       completion: {_ in self.animate(image)})}
    
    func setView()
    {
        viewAlert.isHidden = true
        //     viewRipple?.delegate = self
        currentStatus = trankStatusfromApi
        self.viewModel = HomeViewModel.init(Delegate: self, view: self)
        UIView.animate(withDuration: 1, animations: {
            
            self.viewScroll.contentOffset = CGPoint(x: 0, y: 1000)
        })
        viewRipple.diskColor = Appcolor.kThemeColor
        viewRipple.numberOfCircles = 0
        lblAlertTitle.text = kAppName
        
        setPathForStart()
        setPathOntheWay()
        setPathReached()
        setPathCompleted()
        
        //start
        startImageView = UIImageView(image: image!)
        startImageView.frame = CGRect(x: viewStartCurve.frame.width-90, y: 0, width: 20, height: 20)
        viewStartCurve.bringSubviewToFront(startImageView)
        //    viewStartCurve.addSubview(startImageView)
        //onTheWay
        onWayImageView = UIImageView(image: image!)
        onWayImageView.frame = CGRect(x: viewOntheWay.frame.width/2-16, y: 0, width: 20, height: 20)
        viewOntheWay.bringSubviewToFront(onWayImageView)
        //   viewOntheWay.addSubview(onWayImageView)
        //reached
        reachedImageView = UIImageView(image: UIImage(named: "reachedIcon"))
        if ((modelName?.contains("iPhone 11"))! || ((modelName?.contains("iPhone 6"))!))
        {
            reachedImageView.frame = CGRect(x: viewReached.frame.width-64, y: 0, width: 36, height: 36)
        }
        else{
            reachedImageView.frame = CGRect(x: viewReached.frame.width-98, y: 0, width: 36, height: 36)
        }
        viewReached.bringSubviewToFront(reachedImageView)
        viewReached.addSubview(reachedImageView)
        
        //completed
        completedImageView = UIImageView(image: UIImage(named: "completedJob"))
        if ((modelName?.contains("iPhone 11"))! || ((modelName?.contains("iPhone 6"))!))
        {
            completedImageView.frame = CGRect(x:viewCompleted.frame.width/8,y:viewCompleted.frame.height/14, width: 36, height: 36)
        }
        else{
            completedImageView.frame = CGRect(x:viewCompleted.frame.width/6,y:viewCompleted.frame.height/14, width: 36, height: 36)
        }
        viewCompleted.bringSubviewToFront(completedImageView)
        viewCompleted.addSubview(completedImageView)
        
        setButtonValidations()
        
    }
    
    @objc func dismissView() {
        self.viewUserOnWay.isHidden = true
        self.view.removeGestureRecognizer(tap)
    }
    
    
    @IBAction func action_View_Direction(_ sender: Any) {
        let controller = Navigation.GetInstance(of: .MapVC) as! MapVC
        controller.destinationlat = destinationlat!
        controller.destinationlong = destinationlog!
        controller.sourcelat = sourcelat!
        controller.sourcelong = sourcelog!
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnNAvigationAction(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .MapVC) as! MapVC
        controller.destinationlat = destinationlat
        controller.destinationlong = destinationlog
        controller.orderId = orderId
        controller.trackStatus = currentStatus
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    //MARK:- SetButtonValidations
    func setButtonValidations()
    {
        if (currentStatus == 8)
        {
            self.btnNavigation.isHidden = false
            // self.btnNavigation.tintColor = UIColor.darkGray
        }
        else{
            self.btnNavigation.isHidden = true
            //   self.btnNavigation.tintColor = UIColor.clear
        }
        
        switch currentStatus
        {
        case 0:
            self.btnStart.isUserInteractionEnabled = true
            self.btnStart.backgroundColor = Appcolor.kThemeDisableColor//klightOrange
            self.btnStart.setTitle("Start", for: .normal)
            
            self.btnOntheWay.isUserInteractionEnabled = false
            //  self.btnOntheWay.backgroundColor = Appcolor.kDisableRed_Color
            self.btnReached.isUserInteractionEnabled = false
            self.btnReached.backgroundColor = Appcolor.kThemeDisableColor//kDisableRed_Color
            self.btnCompleted.isUserInteractionEnabled = false
            self.btnCompleted.backgroundColor = Appcolor.kThemeDisableColor//kDisableRed_Color
            startImageView.isHidden = true
            onWayImageView.isHidden = true
            reachedImageView.isHidden = true
            completedImageView.isHidden = true
            viewRipple.isHidden = true
            btnOntheWay.isHidden = true
            startTimer()
            //            self.btnBack.isEnabled = true
            //            self.btnBack.tintColor = UIColor.gray
            break
        case 8: //8,3,6,7,
            self.btnStart.isUserInteractionEnabled = false
            self.btnStart.backgroundColor = Appcolor.kThemeDisableColor//kDisableRed_Color
            //            self.btnOntheWay.isUserInteractionEnabled = false
            //            self.btnOntheWay.backgroundColor = Appcolor.kDisableRed_Color
            shapeLayer.removeFromSuperlayer()
            shapeLayer.strokeColor = UIColor.green.cgColor//UIColor.green.cgColor
            viewStartCurve.layer.addSublayer(shapeLayer)
            
            //            shapeLayerReached.removeFromSuperlayer()
            //            shapeLayerReached.strokeColor = UIColor.orange.cgColor
            //            viewReached.layer.addSublayer(shapeLayerReached)
            //
            shapeLayerforOnWay.removeFromSuperlayer()
            shapeLayerforOnWay.strokeColor = UIColor.orange.cgColor
            viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
            viewOntheWay.bringSubviewToFront(onWayImageView)
            self.btnStart.setTitle("On the way", for: .normal)
            self.btnOntheWay.isUserInteractionEnabled = true
            // self.btnOntheWay.backgroundColor = Appcolor.klightOrange
            self.btnReached.isUserInteractionEnabled = true
            self.btnReached.backgroundColor = Appcolor.kThemeDisableColor//klightOrange
            self.btnCompleted.isUserInteractionEnabled = true
            self.btnCompleted.backgroundColor = Appcolor.kThemeDisableColor//klightOrange
            
            startImageView.isHidden = true
            onWayImageView.isHidden = false
            reachedImageView.isHidden = true
            completedImageView.isHidden = true
            viewRipple.isHidden = false
            //  btnOntheWay.isHidden = false
            
            //            self.btnBack.isEnabled = false
            //            self.btnBack.tintColor = UIColor.clear
            btnOntheWay.fadeIn()
            // onWayTimer()
            reachedTimer()
            onWayLineAnimation()
            stopStartTimerTest()
            // stopReachedTimerTest()
            stopCompletdTimerTest()
            stopCompleteLineAnimation()
            
            break
        case 9: //2
            self.btnStart.isUserInteractionEnabled = false
            self.btnOntheWay.isUserInteractionEnabled = false
            self.btnStart.backgroundColor = Appcolor.kThemeDisableColor//kDisableRed_Color
            //   self.btnOntheWay.backgroundColor = Appcolor.kDisableRed_Color
            shapeLayer.removeFromSuperlayer()
            shapeLayer.strokeColor = UIColor.green.cgColor
            viewStartCurve.layer.addSublayer(shapeLayer)
            shapeLayerforOnWay.removeFromSuperlayer()
            shapeLayerforOnWay.strokeColor = UIColor.green.cgColor
            viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
            self.btnStart.setTitle("On the way", for: .normal)
            shapeLayerReached.removeFromSuperlayer()
            shapeLayerReached.strokeColor = UIColor.green.cgColor// UIColor.green.cgColor
            viewReached.layer.addSublayer(shapeLayerReached)
            viewReached.bringSubviewToFront(reachedImageView)
            
            shapeLayerCompleted.removeFromSuperlayer()
            shapeLayerCompleted.strokeColor = UIColor.orange.cgColor
            viewCompleted.layer.addSublayer(shapeLayerCompleted)
            // viewOntheWay.bringSubviewToFront(onWayImageView)
            
            self.btnReached.isUserInteractionEnabled = false
            self.btnReached.backgroundColor = Appcolor.kThemeDisableColor//kDisableRed_Color
            self.btnCompleted.isUserInteractionEnabled = true
            self.btnCompleted.backgroundColor = Appcolor.kThemeDisableColor//klightOrange
            
            startImageView.isHidden = true
            onWayImageView.isHidden = true
            //            reachedImageView.isHidden = false
            completedImageView.isHidden = true
            viewRipple.isHidden = true
            //  btnOntheWay.isHidden = true
            
            btnOntheWay.fadeOut()
            reachedImageView.fadeIn()
            
            reachedTimer()
            completedTimer()
            completedLineAnimation()
            //   stopOnWaystopTimerTest()
            stopStartTimerTest()
            stopReachedTimerTest()
            stopOnWayLineAnimation()
            break
        case 5: //5
            self.btnStart.isUserInteractionEnabled = false
            self.btnReached.isUserInteractionEnabled = false
            self.btnOntheWay.isUserInteractionEnabled = false
            self.btnStart.backgroundColor = Appcolor.kThemeDisableColor//kDisableRed_Color
            //  self.btnOntheWay.backgroundColor = Appcolor.kDisableRed_Color
            self.btnReached.backgroundColor = Appcolor.kThemeDisableColor//kDisableRed_Color
            shapeLayer.removeFromSuperlayer()
            shapeLayer.strokeColor = UIColor.green.cgColor
            viewStartCurve.layer.addSublayer(shapeLayer)
            shapeLayerforOnWay.removeFromSuperlayer()
            shapeLayerforOnWay.strokeColor = UIColor.green.cgColor
            viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
            shapeLayerReached.removeFromSuperlayer()
            shapeLayerReached.strokeColor = UIColor.green.cgColor
            viewReached.layer.addSublayer(shapeLayerReached)
            shapeLayerCompleted.removeFromSuperlayer()
            shapeLayerCompleted.strokeColor = UIColor.green.cgColor
            viewCompleted.layer.addSublayer(shapeLayerCompleted)
            viewCompleted.bringSubviewToFront(completedImageView)
            
            self.btnCompleted.isUserInteractionEnabled = false
            self.btnCompleted.backgroundColor = Appcolor.kThemeDisableColor//kDisableRed_Color
            
            startImageView.isHidden = true
            onWayImageView.isHidden = true
            //  reachedImageView.isHidden = true
            // completedImageView.isHidden = false
            viewRipple.isHidden = true
            btnOntheWay.isHidden = true
            
            reachedImageView.fadeOut()
            completedImageView.fadeIn()
            
            // completedTimer()
            stopCompletdTimerTest()
            stopOnWaystopTimerTest()
            stopStartTimerTest()
            stopReachedTimerTest()
            stopCompleteLineAnimation()
            stopOnWayLineAnimation()
            
            break
        default:
            self.btnStart.isUserInteractionEnabled = true
            self.btnStart.backgroundColor = Appcolor.kThemeDisableColor//klightOrange
            
            self.btnOntheWay.isUserInteractionEnabled = false
            //  self.btnOntheWay.backgroundColor = Appcolor.kDisableRed_Color
            self.btnReached.isUserInteractionEnabled = false
            self.btnReached.backgroundColor = Appcolor.kThemeDisableColor//kDisableRed_Color
            self.btnCompleted.isUserInteractionEnabled = false
            self.btnCompleted.backgroundColor = Appcolor.kThemeDisableColor//kDisableRed_Color
            startImageView.isHidden = true
            onWayImageView.isHidden = true
            reachedImageView.isHidden = true
            completedImageView.isHidden = true
            viewRipple.isHidden = true
            btnOntheWay.isHidden = true
            startTimer()
            break
        }
    }
    //MARK:- Animation on Image
    @objc func alarmAlertActivateStart(){
        //startImageView.isHidden = !startImageView.isHidden
        btnStart.flash()
    }
    @objc func alarmAlertActivateOnWay(){
        //  btnOntheWay.isHidden = !btnOntheWay.isHidden
        btnOntheWay.flashButton()
    }
    @objc func alarmAlertActivateReached(){
        btnReached.flash()
    }
    @objc func alarmAlertActivateCompleted(){
        //  btnCompleted.isHidden = !btnCompleted.isHidden
        btnCompleted.flash()
    }
    //MARK- Line animtion
    @objc func OnWayLineAnimate()
    {
        if(isUserOwnWay == false){
            isUserOwnWay = true
            self.shapeLayerforOnWay.removeFromSuperlayer()
            self.shapeLayerforOnWay.strokeColor = UIColor.white.cgColor//UIColor.green.cgColor
            self.viewOntheWay.layer.addSublayer(self.shapeLayerforOnWay)
            self.viewOntheWay.bringSubviewToFront(self.onWayImageView)
            
            //            self.shapeLayerReached.removeFromSuperlayer()
            //            self.shapeLayerReached.strokeColor = UIColor.white.cgColor
            //            self.viewReached.layer.addSublayer(self.shapeLayerReached)
        }
        else{
            self.shapeLayerforOnWay.removeFromSuperlayer()
            self.shapeLayerforOnWay.strokeColor = UIColor.orange.cgColor
            self.viewOntheWay.layer.addSublayer(self.shapeLayerforOnWay)
            self.viewOntheWay.bringSubviewToFront(self.onWayImageView)
            
            //            self.shapeLayerReached.removeFromSuperlayer()
            //            self.shapeLayerReached.strokeColor = UIColor.orange.cgColor
            //            self.viewReached.layer.addSublayer(self.shapeLayerReached)
            
            isUserOwnWay = false
        }
        
        //
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute:
        //         {
        //
        //         })
        
        
    }
    
    @objc func CompleteLineAnimate()
    {
        if(isUserOnCompleted == false){
            isUserOnCompleted = true
            self.shapeLayerCompleted.removeFromSuperlayer()
            self.shapeLayerCompleted.strokeColor = UIColor.white.cgColor//UIColor.green.cgColor
            self.viewCompleted.layer.addSublayer(self.shapeLayerCompleted)
            
        }
        else{
            self.shapeLayerCompleted.removeFromSuperlayer()
            self.shapeLayerCompleted.strokeColor = UIColor.orange.cgColor
            self.viewCompleted.layer.addSublayer(self.shapeLayerCompleted)
            //  self.viewOntheWay.bringSubviewToFront(self.onWayImageView)
            
            isUserOnCompleted = false
        }
    }
    //MARK:- SetPath
    func setPathForStart(){
        shapeLayer.path = applePath.cgPath
        // shapeLayer.path = ringPath.CGPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4.0
        // shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineDashPattern = [12, 4]
        viewStartCurve.layer.addSublayer(shapeLayer)
    }
    
    func setPathOntheWay(){
        //onTheWay
        shapeLayerforOnWay.path = applePathOntheWay.cgPath
        // shapeLayer.path = ringPath.CGPath
        shapeLayerforOnWay.strokeColor = UIColor.white.cgColor
        shapeLayerforOnWay.fillColor = UIColor.clear.cgColor
        shapeLayerforOnWay.lineWidth = 4.0
        // shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayerforOnWay.lineDashPattern = [12, 4]
        viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
        viewOntheWay.bringSubviewToFront(btnOntheWay)
    }
    func setPathReached(){
        
        shapeLayerReached.path = applePathReached.cgPath
        // shapeLayer.path = ringPath.CGPath
        shapeLayerReached.strokeColor = UIColor.white.cgColor
        shapeLayerReached.fillColor = UIColor.clear.cgColor
        shapeLayerReached.lineWidth = 4.0
        // shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayerReached.lineDashPattern = [12, 4]
        viewReached.layer.addSublayer(shapeLayerReached)
        viewReached.bringSubviewToFront(btnOntheWay)
    }
    func setPathCompleted(){
        shapeLayerCompleted.path = applePathCompleted.cgPath
        // shapeLayer.path = ringPath.CGPath
        shapeLayerCompleted.strokeColor = UIColor.white.cgColor
        shapeLayerCompleted.fillColor = UIColor.clear.cgColor
        shapeLayerCompleted.lineWidth = 4.0
        // shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayerCompleted.lineDashPattern = [12, 4]
        viewCompleted.layer.addSublayer(shapeLayerCompleted)
    }
    
    //MARK:- setAnimation
    
    func animationOnStartJob(){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.byValue = 1.0
        animation.duration = 1.5
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        shapeLayer.removeFromSuperlayer()
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4.0
        //shapeLayer.lineCap = CAShapeLayerLineCap.round
        viewStartCurve.layer.addSublayer(shapeLayer)
        viewStartCurve.bringSubviewToFront(startImageView)
        shapeLayer.add(animation, forKey: "drawLineAnimation")
        
    }
    
    func animationOntheWay()
    {
        let animationforOntheWay = CABasicAnimation(keyPath: "strokeEnd")
        animationforOntheWay.fromValue = 0.0
        animationforOntheWay.byValue = 1.0
        animationforOntheWay.duration = 1.5
        animationforOntheWay.fillMode = CAMediaTimingFillMode.forwards
        animationforOntheWay.isRemovedOnCompletion = false
        
        shapeLayerforOnWay.removeFromSuperlayer()
        shapeLayerforOnWay.strokeColor = UIColor.green.cgColor
        shapeLayerforOnWay.fillColor = UIColor.clear.cgColor
        shapeLayerforOnWay.lineWidth = 4.0
        // shapeLayerforOnWay.lineCap = CAShapeLayerLineCap.round
        viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
        viewOntheWay.bringSubviewToFront(onWayImageView)
        shapeLayerforOnWay.add(animationforOntheWay, forKey: "drawLineAnimation")
    }
    
    func animationReached()
    {
        let animationforOntheWay = CABasicAnimation(keyPath: "strokeEnd")
        animationforOntheWay.fromValue = 0.0
        animationforOntheWay.byValue = 1.0
        animationforOntheWay.duration = 1.5
        animationforOntheWay.fillMode = CAMediaTimingFillMode.forwards
        animationforOntheWay.isRemovedOnCompletion = false
        
        shapeLayerReached.removeFromSuperlayer()
        shapeLayerReached.strokeColor = UIColor.green.cgColor
        shapeLayerReached.fillColor = UIColor.clear.cgColor
        shapeLayerReached.lineWidth = 4.0
        // shapeLayerforOnWay.lineCap = CAShapeLayerLineCap.round
        viewReached.layer.addSublayer(shapeLayerReached)
        viewReached.bringSubviewToFront(btnOntheWay)
        shapeLayerReached.add(animationforOntheWay, forKey: "drawLineAnimation")
    }
    func animationCompleted()
    {
        let animationforOntheWay = CABasicAnimation(keyPath: "strokeEnd")
        animationforOntheWay.fromValue = 0.0
        animationforOntheWay.byValue = 1.0
        animationforOntheWay.duration = 1.5
        animationforOntheWay.fillMode = CAMediaTimingFillMode.forwards
        animationforOntheWay.isRemovedOnCompletion = false
        
        shapeLayerCompleted.removeFromSuperlayer()
        shapeLayerCompleted.strokeColor = UIColor.green.cgColor
        shapeLayerCompleted.fillColor = UIColor.clear.cgColor
        shapeLayerCompleted.lineWidth = 4.0
        // shapeLayerforOnWay.lineCap = CAShapeLayerLineCap.round
        viewCompleted.layer.addSublayer(shapeLayerCompleted)
        viewCompleted.bringSubviewToFront(completedImageView)
        shapeLayerCompleted.add(animationforOntheWay, forKey: "drawLineAnimation")
    }
    
    @objc func animationCompletedLine()
    {
        let animationforOntheWay = CABasicAnimation(keyPath: "strokeEnd")
        animationforOntheWay.fromValue = 0.0
        animationforOntheWay.byValue = 1.0
        animationforOntheWay.duration = 1.5
        animationforOntheWay.fillMode = CAMediaTimingFillMode.forwards
        animationforOntheWay.isRemovedOnCompletion = false
        
        shapeLayerCompleted.removeFromSuperlayer()
        shapeLayerCompleted.strokeColor = UIColor.orange.cgColor
        shapeLayerCompleted.fillColor = UIColor.clear.cgColor
        shapeLayerCompleted.lineWidth = 4.0
        
        //        if(isUserOnCompleted == false){
        //              isUserOnCompleted = true
        //              self.shapeLayerCompleted.removeFromSuperlayer()
        //              self.shapeLayerCompleted.strokeColor = UIColor.white.cgColor//UIColor.green.cgColor
        //              self.viewCompleted.layer.addSublayer(self.shapeLayerCompleted)
        //
        //          }
        //          else{
        //              self.shapeLayerCompleted.removeFromSuperlayer()
        //              self.shapeLayerCompleted.strokeColor = UIColor.orange.cgColor
        //              self.viewCompleted.layer.addSublayer(self.shapeLayerCompleted)
        //            //  self.viewOntheWay.bringSubviewToFront(self.onWayImageView)
        //
        //               isUserOnCompleted = false
        //              }
        // shapeLayerforOnWay.lineCap = CAShapeLayerLineCap.round
        viewCompleted.layer.addSublayer(shapeLayerCompleted)
        viewCompleted.bringSubviewToFront(completedImageView)
        shapeLayerCompleted.add(animationforOntheWay, forKey: "drawLineAnimation")
        
        
    }
    
    //MARK:- ShowAlert
    
    func showAlert()
    {
        self.viewAlert.isHidden = false
        self.viewAlert.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {() -> Void in
            self.viewAlert.transform = .identity
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
        })
    }
    //MARK:- Draw path
    var applePath: UIBezierPath{
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x:  viewStartCurve.frame.width/2+20, y: viewStartCurve.frame.width/2-20))
        bezierPath.addCurve(to: CGPoint(x:viewStartCurve.frame.width-80,y:0), controlPoint1: CGPoint(x: 160, y:40), controlPoint2: CGPoint(x: 300, y: viewStartCurve.frame.height))
        
        return bezierPath
    }
    //viewStartCurve.frame.width-80
    var applePathOntheWay: UIBezierPath{
        
        let bezierPath = UIBezierPath()
        if ((modelName?.contains("iPhone 11"))! || ((modelName?.contains("iPhone 6"))!))
        {
            bezierPath.move(to: CGPoint(x: viewOntheWay.frame.width-96, y: viewOntheWay.frame.width/2-40))
            bezierPath.addCurve(to: CGPoint(x:viewOntheWay.frame.width/2-2,y:0), controlPoint1: CGPoint(x: 160, y:80), controlPoint2: CGPoint(x: 198, y: viewStartCurve.frame.height))
            
        }
        else{
            bezierPath.move(to: CGPoint(x: viewOntheWay.frame.width-140, y: viewOntheWay.frame.width/2-40))
            bezierPath.addCurve(to: CGPoint(x:viewOntheWay.frame.width/2-2,y:0), controlPoint1: CGPoint(x: 160, y:80), controlPoint2: CGPoint(x: 198, y: viewStartCurve.frame.height))
            
        }
        
        return bezierPath
    }
    
    var applePathReached: UIBezierPath{
        
        let bezierPath = UIBezierPath()
        if ((modelName?.contains("iPhone 11"))! || ((modelName?.contains("iPhone 6"))!))
        {
            bezierPath.move(to: CGPoint(x: viewReached.frame.width/2, y:viewReached.frame.width/2-24))
            bezierPath.addCurve(to: CGPoint(x:viewReached.frame.width-40,y:0), controlPoint1: CGPoint(x: 160, y:40), controlPoint2: CGPoint(x: 300, y: viewReached.frame.height))
        }
        else{
            bezierPath.move(to: CGPoint(x: viewReached.frame.width/2, y:viewReached.frame.width/2-24))
            bezierPath.addCurve(to: CGPoint(x:viewReached.frame.width-88,y:0), controlPoint1: CGPoint(x: 160, y:40), controlPoint2: CGPoint(x: 300, y: viewReached.frame.height))
        }
        
        return bezierPath
    }
    
    var applePathCompleted: UIBezierPath{
        
        let bezierPath = UIBezierPath()
        if ((modelName?.contains("iPhone 11"))! || ((modelName?.contains("iPhone 6"))!))
        {
            bezierPath.move(to: CGPoint(x: viewCompleted.frame.width-40, y: viewCompleted.frame.width/2-44))
            bezierPath.addCurve(to: CGPoint(x:viewCompleted.frame.width/6,y:viewCompleted.frame.height/18), controlPoint1: CGPoint(x: 220, y:40), controlPoint2: CGPoint(x: 80, y: viewCompleted.frame.height))
        }
        else{
            bezierPath.move(to: CGPoint(x: viewCompleted.frame.width-90, y: viewCompleted.frame.width/2-44))
            bezierPath.addCurve(to: CGPoint(x:viewCompleted.frame.width/6,y:viewCompleted.frame.height/18), controlPoint1: CGPoint(x: 220, y:40), controlPoint2: CGPoint(x: 80, y: viewCompleted.frame.height))
            
        }
        return bezierPath
    }
    
    //MARK:- Hit Api
    
    func cashCollection(){
        viewModel?.cashCollect(orderId: self.orderId ?? "", amount: price, completion: { (response) in
            //StartIndicator(message: kLoading)
            self.UpdateTrackStatusApi(status: "5", id: self.orderId, otp: self.otp ?? "", imgURL: self.imgURL)
        })
    }
    //updateTrack
    func UpdateTrackStatusApi(status:String?,id:String?,otp:String,imgURL:URL?)
    {
        viewModel?.UpdateTrackStatusApi(Id: id ?? "", status: status, otp: otp, orderImage: imgURL, completion: { (response) in
            print(response)
            
            switch self.trackStatus {
            case 0:
                AppDefaults.shared.startedJobId = id ?? ""
                self.currentStatus = 8
                self.btnStart.isUserInteractionEnabled = false
                self.btnStart.backgroundColor = Appcolor.kDisableRed_Color
                //                self.btnBack.isEnabled = false
                //                self.btnBack.tintColor = UIColor.clear
                break
            case 1:
                self.currentStatus = 9//2
                self.btnStart.isUserInteractionEnabled = false
                self.btnOntheWay.isUserInteractionEnabled = false
                self.btnStart.backgroundColor = Appcolor.kDisableRed_Color
                //   self.btnOntheWay.backgroundColor = Appcolor.kDisableRed_Color
                //                self.btnBack.isEnabled = false
                //                self.btnBack.tintColor = UIColor.clear
                break
            case 2:
                AppDefaults.shared.startedJobId = ""
                self.currentStatus = 5
                self.btnStart.isUserInteractionEnabled = false
                self.btnReached.isUserInteractionEnabled = false
                self.btnOntheWay.isUserInteractionEnabled = false
                self.btnCompleted.isUserInteractionEnabled = false
                self.btnStart.backgroundColor = Appcolor.kDisableRed_Color
                //  self.btnOntheWay.backgroundColor = Appcolor.kDisableRed_Color
                self.btnReached.backgroundColor = Appcolor.kDisableRed_Color
                self.btnCompleted.backgroundColor = Appcolor.kDisableRed_Color
                //                self.btnBack.isEnabled = true
                //                self.btnBack.tintColor = UIColor.gray
                //self.showAlertMessage(titleStr: kAppName, messageStr: "Job has been completed successfully.")
                self.navigationController?.popViewController(animated: false)
                break
            default:
                
                break
            }
            HomeVC.locationManager.startUpdatingLocation()
            self.setButtonValidations()
            
            //     self.navigationController?.popViewController(animated: false)
        })
    }
    
    //MARK:- Actions
    
    @IBAction func btnReached(_ sender: Any) {
        viewUserOnWay.isHidden = true
        trackStatus = 1
        isReachedClick = true
        self.animationOnStartJob()
        lblAlertMessage.text = "Are you sure you have reached at your destination location?"
        let delayTime = DispatchTime.now() + 0.8
        print("one")
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
            self.animationOntheWay()
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute:
                                        {
                                            self.animationReached()
                                        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.4, execute: {
            //   self.showAlert()
            self.UpdateTrackStatusApi(status: "9", id: self.orderId, otp: "", imgURL: nil)
        })
        
        
        
    }
    
    @IBAction func btnCompleted(_ sender: Any) {
        // btnCompleted.isUserInteractionEnabled = false
        isCompletedClick = true
        viewUserOnWay.isHidden = true
        trackStatus = 2
        animationOnStartJob()
        lblAlertMessage.text = "Are you sure you want to complete this job?"
        let delayTime = DispatchTime.now() + 0.2
        print("one")
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
            self.animationOntheWay()
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6, execute:
                                        {
                                            self.animationReached()
                                        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8, execute:
                                        {
                                            self.animationCompleted()
                                        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
            self.showAlert()
        })
    }
    @IBAction func btnOnWayAction(_ sender: Any) {
        //        trackStatus = 1
        //        isOwnWayclicked = true
        //        self.animationOnStartJob()
        //        lblAlertMessage.text = "Are you sure you have reached at your destination location?"
        //        let delayTime = DispatchTime.now() + 0.8
        //        print("one")
        //        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
        //            self.animationOntheWay()
        //        })
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
        //            self.showAlert()
        //        })
        //        viewUserOnWay.isHidden = false
        ////
        //        UIView.animate(withDuration: 1, animations: {
        //            self.viewUserOnWay.backgroundColor = .brown
        //            self.viewUserOnWay.frame.size.width += 10
        //            self.viewUserOnWay.frame.size.height += 10
        //        }) { _ in
        //            UIView.animate(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations: {
        //                self.viewUserOnWay.frame.origin.y -= 20
        //            })
        //        }
        //
        //        tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        //              view.addGestureRecognizer(tap )
    }
    
    @IBAction func btnStartAction(_ sender: Any)
    {
        viewUserOnWay.isHidden = true
        trackStatus = 0
        isStartClicked = true
        animationOnStartJob()
        lblAlertMessage.text = "Are you sure you want to start this job?"
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8, execute: {
            // self.showAlert()
            //            self.startImageView.isHidden = false
            //            self.startTimer()
            let controller = Navigation.GetInstance(of: .AlertVC) as! AlertVC
            controller.isStartJob = true
            controller.alertDelegate = self
            self.navigationController?.present(controller, animated: false, completion: nil)
            //self.UpdateTrackStatusApi(status: "3", id: self.orderId)
        })
        
    }
    //MARK:- AnimationStart
    func startTimer () {
        guard timerStart == nil else { return }
        
        timerStart =  Timer.scheduledTimer(
            timeInterval: TimeInterval(1.0),
            target      : self,
            selector    : #selector(self.alarmAlertActivateStart),
            userInfo    : nil,
            repeats     : true)
    }
    func onWayTimer () {
        guard timeOnWay == nil else { return }
        
        timeOnWay =  Timer.scheduledTimer(
            timeInterval: TimeInterval(1.0),
            target      : self,
            selector    : #selector(self.alarmAlertActivateOnWay),
            userInfo    : nil,
            repeats     : true)
    }
    func reachedTimer () {
        guard timeReached == nil else { return }
        
        timeReached =  Timer.scheduledTimer(
            timeInterval: TimeInterval(1.0),
            target      : self,
            selector    : #selector(self.alarmAlertActivateReached),
            userInfo    : nil,
            repeats     : true)
    }
    func completedTimer () {
        guard timeCompleted == nil else { return }
        
        timeCompleted =  Timer.scheduledTimer(
            timeInterval: TimeInterval(2.0),
            target      : self,
            selector    : #selector(self.alarmAlertActivateCompleted),
            userInfo    : nil,
            repeats     : true)
    }
    
    func onWayLineAnimation() {
        guard lineOnWay == nil else { return }
        
        lineOnWay =  Timer.scheduledTimer(
            timeInterval: TimeInterval(2.4),
            target      : self,
            selector    : #selector(self.OnWayLineAnimate),
            userInfo    : nil,
            repeats     : true)
    }
    
    func completedLineAnimation() {
        guard lineCompleted == nil else { return }
        
        lineCompleted =  Timer.scheduledTimer(
            timeInterval: TimeInterval(2.4),
            target      : self,
            selector    : #selector(self.CompleteLineAnimate),
            userInfo    : nil,
            repeats     : true)
    }
    //MARK:- stopAnimation
    func stopStartTimerTest() {
        timerStart?.invalidate()
        timerStart = nil
    }
    func stopOnWaystopTimerTest() {
        timeOnWay?.invalidate()
        timeOnWay = nil
    }
    func stopReachedTimerTest() {
        timeReached?.invalidate()
        timeReached = nil
    }
    func stopCompletdTimerTest() {
        timeCompleted?.invalidate()
        timeCompleted = nil
    }
    func stopOnWayLineAnimation() {
        lineOnWay?.invalidate()
        lineOnWay = nil
    }
    func stopCompleteLineAnimation() {
        lineCompleted?.invalidate()
        lineCompleted = nil
    }
    //MARK:- Alert Actions
    @IBAction func AlertYesAction(_ sender: Any) {
        viewAlert.isHidden = true
        switch trackStatus {
        case 0:
            self.UpdateTrackStatusApi(status: "8", id: self.orderId, otp: "", imgURL: nil)
            break
        case 1:
            self.UpdateTrackStatusApi(status: "9", id: self.orderId, otp: "", imgURL: nil)
            break
        case 2:
            let controller = Navigation.GetInstance(of: .AlertVC) as! AlertVC
            controller.isStartJob = false
            controller.alertDelegate = self
            self.navigationController?.present(controller, animated: false, completion: nil)
            
            
            
            break
        default:
            
            break
        }
        
        
    }
    @IBAction func AlertNoAction(_ sender: Any) {
        viewAlert.isHidden = true
        btnCompleted.isUserInteractionEnabled = true
        
        if(isOwnWayclicked == true && isStartClicked == false){
            
            if currentStatus == 1{
                
                
                shapeLayerReached.removeFromSuperlayer()
                shapeLayerReached.strokeColor = UIColor.white.cgColor
                viewReached.layer.addSublayer(shapeLayerReached)
                
                shapeLayerCompleted.removeFromSuperlayer()
                shapeLayerCompleted.strokeColor = UIColor.white.cgColor
                viewCompleted.layer.addSublayer(shapeLayerCompleted)
                
                shapeLayerforOnWay.removeFromSuperlayer()
                shapeLayerforOnWay.strokeColor = UIColor.orange.cgColor
                viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
                viewOntheWay.bringSubviewToFront(onWayImageView)
            }
            else{
                shapeLayer.removeFromSuperlayer()
                shapeLayer.strokeColor = UIColor.white.cgColor
                viewStartCurve.layer.addSublayer(shapeLayer)
                
                
                shapeLayerforOnWay.removeFromSuperlayer()
                shapeLayerforOnWay.strokeColor = UIColor.white.cgColor
                viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
                
                shapeLayerReached.removeFromSuperlayer()
                shapeLayerReached.strokeColor = UIColor.white.cgColor
                viewReached.layer.addSublayer(shapeLayerReached)
                
                shapeLayerCompleted.removeFromSuperlayer()
                shapeLayerCompleted.strokeColor = UIColor.white.cgColor
                viewCompleted.layer.addSublayer(shapeLayerCompleted)
            }
        }
        
        else if (isReachedClick == true && isOwnWayclicked == false){
            
            if(currentStatus ?? 0 == 2){
                
                shapeLayerCompleted.removeFromSuperlayer()
                shapeLayerCompleted.strokeColor = UIColor.white.cgColor
                viewCompleted.layer.addSublayer(shapeLayerCompleted)
            }
            else if(currentStatus ?? 0 == 4){
                shapeLayerCompleted.removeFromSuperlayer()
                shapeLayerCompleted.strokeColor = UIColor.white.cgColor
                viewCompleted.layer.addSublayer(shapeLayerCompleted)
            }
            else if (currentStatus ?? 0 == 1){
                shapeLayerforOnWay.removeFromSuperlayer()
                shapeLayerforOnWay.strokeColor = UIColor.orange.cgColor
                viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
                viewOntheWay.bringSubviewToFront(onWayImageView)
                
                shapeLayerReached.removeFromSuperlayer()
                shapeLayerReached.strokeColor = UIColor.white.cgColor
                viewReached.layer.addSublayer(shapeLayerReached)
                
                shapeLayerCompleted.removeFromSuperlayer()
                shapeLayerCompleted.strokeColor = UIColor.white.cgColor
                viewCompleted.layer.addSublayer(shapeLayerCompleted)
            }
            else{
                shapeLayerforOnWay.removeFromSuperlayer()
                shapeLayerforOnWay.strokeColor = UIColor.white.cgColor
                viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
                shapeLayerReached.removeFromSuperlayer()
                shapeLayerReached.strokeColor = UIColor.white.cgColor
                viewReached.layer.addSublayer(shapeLayerReached)
                
            }
            
        }
        else if (isCompletedClick == true && isOwnWayclicked == false){
            
            if(currentStatus ?? 0 == 2){
                
                shapeLayerCompleted.removeFromSuperlayer()
                shapeLayerCompleted.strokeColor = UIColor.white.cgColor
                viewCompleted.layer.addSublayer(shapeLayerCompleted)
            }
            else   if currentStatus ?? 0 == 1{
                shapeLayerReached.removeFromSuperlayer()
                shapeLayerReached.strokeColor = UIColor.white.cgColor
                viewReached.layer.addSublayer(shapeLayerReached)
                
                shapeLayerCompleted.removeFromSuperlayer()
                shapeLayerCompleted.strokeColor = UIColor.white.cgColor
                viewCompleted.layer.addSublayer(shapeLayerCompleted)
                
                shapeLayerforOnWay.removeFromSuperlayer()
                shapeLayerforOnWay.strokeColor = UIColor.orange.cgColor
                viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
                viewOntheWay.bringSubviewToFront(onWayImageView)
            }
            else{
                shapeLayerforOnWay.removeFromSuperlayer()
                shapeLayerforOnWay.strokeColor = UIColor.white.cgColor
                viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
                shapeLayerReached.removeFromSuperlayer()
                shapeLayerReached.strokeColor = UIColor.white.cgColor
                viewReached.layer.addSublayer(shapeLayerReached)
                shapeLayerCompleted.removeFromSuperlayer()
                shapeLayerCompleted.strokeColor = UIColor.white.cgColor
                viewCompleted.layer.addSublayer(shapeLayerCompleted)
                
            }
            
        }
        else if(isReachedClick == true && isOwnWayclicked == false && isStartClicked == false){
            shapeLayer.removeFromSuperlayer()
            shapeLayer.strokeColor = UIColor.white.cgColor
            viewStartCurve.layer.addSublayer(shapeLayer)
            shapeLayerforOnWay.removeFromSuperlayer()
            shapeLayerforOnWay.strokeColor = UIColor.white.cgColor
            viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
            shapeLayerReached.removeFromSuperlayer()
            shapeLayerReached.strokeColor = UIColor.white.cgColor
            viewReached.layer.addSublayer(shapeLayerReached)
        }
        else if(isStartClicked == true){
            isStartClicked = false
            shapeLayer.removeFromSuperlayer()
            shapeLayer.strokeColor = UIColor.white.cgColor
            viewStartCurve.layer.addSublayer(shapeLayer)
            //stopTimerTest()
        }
        else  if(isOwnWayclicked == true){
            isOwnWayclicked = false
            shapeLayerforOnWay.removeFromSuperlayer()
            shapeLayerforOnWay.strokeColor = UIColor.white.cgColor
            viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
        }
        else  if(isReachedClick == true){
            isReachedClick = false
            shapeLayerReached.removeFromSuperlayer()
            shapeLayerReached.strokeColor = UIColor.white.cgColor
            viewReached.layer.addSublayer(shapeLayerReached)
        }
        else  if(isCompletedClick == true){
            isCompletedClick = false
            if currentStatus == 1{
                shapeLayerReached.removeFromSuperlayer()
                shapeLayerReached.strokeColor = UIColor.white.cgColor
                viewReached.layer.addSublayer(shapeLayerReached)
                
                shapeLayerCompleted.removeFromSuperlayer()
                shapeLayerCompleted.strokeColor = UIColor.white.cgColor
                viewCompleted.layer.addSublayer(shapeLayerCompleted)
                
                shapeLayerforOnWay.removeFromSuperlayer()
                shapeLayerforOnWay.strokeColor = UIColor.orange.cgColor
                viewOntheWay.layer.addSublayer(shapeLayerforOnWay)
                viewOntheWay.bringSubviewToFront(onWayImageView)
            }
            else{
                shapeLayerCompleted.removeFromSuperlayer()
                shapeLayerCompleted.strokeColor = UIColor.white.cgColor
                viewCompleted.layer.addSublayer(shapeLayerCompleted)
            }
            
        }
        else{
            
        }
        //
        
        viewReached.bringSubviewToFront(btnOntheWay)
    }
    
    
}
//MARK:- ViewModelDelegate
extension ChangeStatusVC:HomeVCDelegate{
    func Show(msg: String) {
    }
    
    func didError(error: String) {
        showAlertMessage(titleStr: kAppName, messageStr: error)
    }
    
    
}
extension ChangeStatusVC: RadarViewDelegate {
    func radarView(radarView: RadarView, didSelect item: Item) {
        print(item.uniqueKey)
    }
    
    func radarView(radarView: RadarView, didDeselect item: Item) {}
    
    func radarView(radarView: RadarView, didDeselectAllItems lastSelectedItem: Item) {}
}


extension ChangeStatusVC:AlertDelegate{
    func startCompleteJobAction(url: URL, otp: String, isStart: Bool) {
        self.otp = otp
        self.imgURL = url
        if isStart == true
        {
            self.UpdateTrackStatusApi(status: "8", id: self.orderId, otp: otp, imgURL: url)
        }
        else
        {
          //  btnCompleted.isUserInteractionEnabled = false
            if paymentType == 2
            {
                self.cashCollection()
            }
            else
            {
                self.UpdateTrackStatusApi(status: "5", id: self.orderId, otp: otp, imgURL: url)
            }
        }
    }
    
    
}
