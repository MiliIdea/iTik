//
//  ViewController.swift
//  iTik
//
//  Created by MILAD on 11/28/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import DCKit
import Alamofire
import Gloss

class PaymentViewController: UIViewController ,CLLocationManagerDelegate , BluetoothSerialDelegate{
    
    
    @IBOutlet weak var paymentView: DCBorderedButton!
    
    @IBOutlet weak var paymentPriceText: UITextField!
    
    @IBOutlet weak var paymentButton: DCBorderedButton!
    
    @IBOutlet weak var paymentTitleText: UILabel!
    
    var myBTManager : CBPeripheralManager? = nil
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    let BEAN_NAME = "MyDevice"
    
    let locationManager = CLLocationManager()
    
    var payBeacon : CLBeacon? = nil
    
    var indexPay : Int = 0
    
    /// The peripherals that have been discovered (no duplicates and sorted by asc RSSI)
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    
    /// The peripheral the user has selected
    var selectedPeripheral: CBPeripheral?
    
    var selectedBeaconCode : String = ""
    
    public let `default2`: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return SessionManager(configuration: configuration)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        serial = BluetoothSerial(delegate: self)
        serial.delegate = self
        self.login()
//        manager = CBCentralManager(delegate: self, queue: nil)
    }

    func login(){
        
        let manager = default2
        
        manager.request( URLs.login , method: .post , parameters: LoginRequestModel.init().getParams() , encoding: JSONEncoding.default).responseJSON { response in
            
            if let JSON = response.result.value {
                
                print("JSON ----------LOGIN----------->>>> " ,JSON)
                //create my coupon response model
                
                if( LoginResponseModel.init(json: JSON as! JSON).code == "200"){
                    
                    GlobalFields.token = LoginResponseModel.init(json: JSON as! JSON).token!
                    
                    GlobalFields.user = LoginResponseModel.init(json: JSON as! JSON).user!
                    
                    manager.request( URLs.uuidListPayment , method: .post , parameters: GetUUIDListRequestModel.init().getParams() , encoding: JSONEncoding.default).responseJSON { response in
                        
                        if let JSON = response.result.value {
                            
                            print("JSON ----------uuidListPayment----------->>>> " ,JSON)
                            //create my coupon response model
                            
                            if( GetUUIDListResponseModel.init(json: JSON as! JSON).code == "200"){
                                GlobalFields.PAY_UUIDS = GetUUIDListResponseModel.init(json: JSON as! JSON).data?.uuid
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tap(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    
    
    @IBAction func searchBeaconPay(_ sender: Any) {
        
        if #available(iOS 10.0, *) {
            if(myBTManager?.state == CBManagerState.poweredOff){
                
                Notifys().notif(message: "لطفا جهت استفاده از دستگاه پرداخت بلوتوث خود را روشن کنید."){ alarm in
                    
                    self.present(alarm, animated: true, completion: nil)
                    
                }
                
                return
            }
        } else {
            // Fallback on earlier versions
        }
        
        firstAnimate()
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        if(GlobalFields.PAY_UUIDS == nil){
            
            return
            
        }
        
        self.indexPay = 0
        
        let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: GlobalFields.PAY_UUIDS![indexPay].lowercased())! as UUID, identifier: "iTik")
        
//        let myRegion = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "74278bda-b644-4520-8f0c-720eaf059935")! as UUID, identifier: "iTik")
        
        //changed
        self.locationManager.startRangingBeacons(in: region)
        
        locationManager.distanceFilter = 1
        
    }
    
    @IBAction func payment(_ sender: Any) {
        
        
        if(self.paymentPriceText.text == ""){
            return
        }
        
        if(Int(self.paymentPriceText.text!)! == 0){
            return
        }
            
        self.view.isUserInteractionEnabled = false
            
        self.paymentView.isUserInteractionEnabled = false
        
        var beaconCode : String = ""
        
        beaconCode.append(String(describing: (payBeacon?.proximityUUID)!).lowercased())
        
        beaconCode.append("-")
        
        beaconCode.append(String(describing: (payBeacon?.major)!).lowercased())
        
        beaconCode.append("-")
        
        beaconCode.append(String(describing: (payBeacon?.minor)!).lowercased())
        
        self.selectedBeaconCode = beaconCode
        
//        self.writeOnBLE(value: "true")
        
        let manager = default2

            manager.request(URLs.setPayment , method: .post , parameters: SetPaymentRequestModel.init(CODE: beaconCode, MONEY: self.paymentPriceText.text!).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()

                switch (response.result) {
                case .failure(let _):

                    self.view.isUserInteractionEnabled = true

                    return


                default: break

                }

                if let JSON = response.result.value {

                    print("JSON ----------Payment----------->>>> " ,JSON)
                    //create my coupon response model

                    self.view.isUserInteractionEnabled = true

                    if( SetPaymentResponseModel.init(json: JSON as! JSON).code == "200"){

                        request(URLs.verifyPayment , method: .post , parameters: VerifyPaymentRequestModel.init(CODE_FROM_SET_SERVICE:  SetPaymentResponseModel.init(json: JSON as! JSON).data?.code).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                            print()

                            if let JSON2 = response.result.value {

                                print("JSON ----------Payment Verify----------->>>> " ,JSON2)
                                //create my coupon response model

                                if( VerifyPaymentResponseModel.init(json: JSON2 as! JSON).code == "200"){


                                    if(VerifyPaymentResponseModel.init(json: JSON2 as! JSON).data?.url?.isEmpty)!{
                                        self.closePayment("")
                                        Notifys().notif(message: "پرداخت با موفقیت انجام شد"){ alarm in

                                            self.present(alarm, animated: true, completion: nil)

                                        }

                                        self.writeOnBLE(value: "true")

                                    }else{
                                        GlobalFields.goOnlinePay = true
                                        self.viewDidDisappear(true)
                                        UIApplication.shared.openURL(URL(string: (VerifyPaymentResponseModel.init(json: JSON2 as! JSON).data?.url)!)!)
                                    }

                                }else{

                                    Notifys().notif(message: "verify payment error"){ alarm in

                                        self.present(alarm, animated: true, completion: nil)

                                    }

                                }
                                self.closePayment("")

                            }

                        }

                    }else{

                        self.closePayment("")

                    }

                }

            }

        
    }
    
    @IBAction func closePayment(_ sender: Any) {
        
        paymentView.alpha = 0
        
    }
    
    ////////////////////////////////////////////
    
    func writeOnBLE(value : String){
        serial.startScan()
    }
    
    func sendData(){
        print("--->>> send data")
//        if(serial.isReady){
//            var msg : String = "SS" + self.paymentPriceText.text! + "SE"
//            serial.sendMessageToDevice(msg)
//        }
    }
    
    //MARK: BluetoothSerialDelegate
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
       
        for exisiting in peripherals {
            if exisiting.peripheral.identifier == peripheral.identifier { return }
        }

        var s : [Substring] = self.selectedBeaconCode.split(separator: "-")
        
        var res : String = s[1].description + s[2].description
        
        if(peripheral.name == res){
            serial.stopScan()
            serial.connectToPeripheral(peripheral)
        }
        
    }
    
    func serialDidReceiveString(_ message: String) {
        
        if(message != "no payment!"){
            Notifys().notif(message: "پرداخت با موفقیت ثبت شد"){ alarm in
                
                self.present(alarm, animated: true, completion: nil)
                
            }
            serial.disconnect()
        }
    }
    
    func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {
        
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        
    }
    
    func serialIsReady(_ peripheral: CBPeripheral) {
        print("its ready...")
//        if(peripheral.name == res){
            self.sendData()
//        }

    }
    
    func serialDidChangeState() {

        if serial.centralManager.state != .poweredOn {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadStartViewController"), object: self)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: -Util Functions
    
    func showPayPopup(payTitle : String!){
    
        paymentView.alpha = 1
        
        self.paymentTitleText.text = payTitle
    
    }
 
    
    
    func firstAnimate(){
        
        self.view.isUserInteractionEnabled = false

    }
    
    func secondAnimate(){
        
        self.view.isUserInteractionEnabled = true
        
    }
    
    // MARK: - LocationManager
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if(beacons.count == 0){
            
            if(indexPay + 1 <= (GlobalFields.PAY_UUIDS?.count)! - 1){
                indexPay += 1
                let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: GlobalFields.PAY_UUIDS![indexPay].lowercased())! as UUID, identifier: "Bding")
                
                self.locationManager.startRangingBeacons(in: region)
                
                return
            }else{
                
                Notifys().notif(message: "دستگاه پرداختی یافت نشد!"){ alarm in
                    
                    self.present(alarm, animated: true, completion: nil)
                    
                }
                
                self.secondAnimate()
                
                locationManager.stopRangingBeacons(in: region)
                
                return
                
            }
        }
        
        var payBeacons : [CLBeacon] = [CLBeacon]()
        
        for b in beacons {
            
            let beaconString = String(describing: b.proximityUUID)
            
            if(GlobalFields.PAY_UUIDS?.contains(beaconString.lowercased()))!{
                
                payBeacons.append(b)
                
            }
            
        }
        
        payBeacons.sort(by: {(b1 , b2) -> Bool in
            var d1 : Double = 0.0
            var d2 : Double = 0.0
            d1 = b1.accuracy
            d2 = b2.accuracy
            if(d1 == -1){
                d1 = 100
            }
            if(d2 == -1){
                d2 = 100
            }
            return d1 > d2
        })

        
        if(payBeacons.count == 0){
            if(indexPay + 1 <= (GlobalFields.PAY_UUIDS?.count)! - 1){
                indexPay += 1
                let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: GlobalFields.PAY_UUIDS![indexPay].lowercased())! as UUID, identifier: "Bding")
                
                self.locationManager.startRangingBeacons(in: region)
                
                return
            }else{
                Notifys().notif(message: "دستگاه پرداختی یافت نشد!"){ alarm in
                    
                    self.present(alarm, animated: true, completion: nil)
                    
                    self.secondAnimate()
                    
                }
            }
        }else{
            
            popupRequestFor(beacons: payBeacons)
            
        }
        
        locationManager.stopRangingBeacons(in: region)
        
        
    }
    
    
    
    func popupRequestFor(beacons : [CLBeacon]){
        
        var payBeacons : [CLBeacon] = beacons
        
        let b = payBeacons.popLast()
        
        var beaconCode : String = ""
        
        beaconCode.append(String(describing: (b?.proximityUUID)!).lowercased())
        
        beaconCode.append("-")
        
        beaconCode.append(String(describing: (b?.major)!).lowercased())
        
        beaconCode.append("-")
        
        beaconCode.append(String(describing: (b?.minor)!).lowercased())
        
        
        
        print("requeste pay : " , beaconCode)
        
        let manager = default2
        
        manager.request( URLs.getPayment , method: .post , parameters: GetPaymentRequestModel.init(CODE: beaconCode).getParams() , encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            switch (response.result) {
            case .failure(let _):
                
                self.secondAnimate()
                
                return
                
            default: break
                
            }
            
            if let JSON = response.result.value {
                
                print("JSON ----------GET PAY TITLE----------->>>> " ,JSON)
                //create my coupon response model
                
                if( GetPaymentResponseModel.init(json: JSON as! JSON).code == "200"){
                    
                    self.secondAnimate()
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                        
                        self.showPayPopup(payTitle: GetPaymentResponseModel.init(json: JSON as! JSON).data?.title)
                        
                        self.payBeacon = b
                        
                    },completion : nil)
                    
                    
                }else{
                    
                    if(payBeacons.count == 0){
                        
                        if(self.indexPay + 1 <= (GlobalFields.PAY_UUIDS?.count)! - 1){
                            self.indexPay += 1
                            let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: GlobalFields.PAY_UUIDS![self.indexPay].lowercased())! as UUID, identifier: "Bding")
                            
                            self.locationManager.startRangingBeacons(in: region)
                            
                            return
                        }else{
                            Notifys().notif(message: "دستگاه پرداختی یافت نشد!"){ alarm in
                                
                                self.present(alarm, animated: true, completion: nil)
                                
                                self.secondAnimate()
                                
                            }
                        }
                    }else{
                        
                        self.popupRequestFor(beacons: payBeacons)
                        
                    }
                    
                }
                
                
            }
            
        }
        
    }
    
}

