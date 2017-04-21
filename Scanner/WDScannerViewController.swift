//
//  WDScannerViewController.swift
//  xmksBg
//
//  Created by apple on 2017/1/16.
//  Copyright © 2017年 zhoutai. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import SnapKit
typealias scannerSuccess = (_ mailNo:[WDModel4Scanner], _ index:Int)->Void

class WDScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource{

    var scannerLineTop:Constraint? = nil
    var scanRectView:UIView!
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!
    var tableView:UITableView?
    var index:Int?
    var scannerResult:scannerSuccess?
    var isBackNow:Bool?
    var mailNoArr:[WDModel4Scanner] = {
        var array:[WDModel4Scanner] = [WDModel4Scanner]()
        return array
    }()
    var isFlashOpen:Bool? = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "运单扫描"
        if self.isBackNow == nil {
            self.isBackNow = false
        }
        self.view.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "Back-Arrow"), style: UIBarButtonItemStyle.done, target: self, action: #selector(WDScannerViewController.pop))
        var title = "开启闪光灯"
        if UserDefaults.standard.value(forKey: "isFlashOpen") != nil {
            let isOpen = UserDefaults.standard.value(forKey: "isFlashOpen") as! Bool
            if isOpen {
                title = "关闭闪光灯"
                self.isFlashOpen = true
            }
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title, style: UIBarButtonItemStyle.done, target: self, action: #selector(WDScannerViewController.isOpenFlash))
        if self.index == nil {
            self.index = 0
        }
        fromCamera()
        configTableView()
    }
    
    func isOpenFlash() {
        self.isFlashOpen = !self.isFlashOpen!
        UserDefaults.standard.set(self.isFlashOpen, forKey: "isFlashOpen")
        UserDefaults.standard.synchronize()
        var title = "开启闪光灯"
        if self.device.hasTorch && self.device.hasFlash {
            try! self.device.lockForConfiguration()
            if self.isFlashOpen! {
                self.device.torchMode = AVCaptureTorchMode.on
                title = "关闭闪光灯"
            }else{
                self.device.torchMode = AVCaptureTorchMode.off
                title = "开启闪光灯"
            }
            self.device.unlockForConfiguration()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title, style: UIBarButtonItemStyle.done, target: self, action: #selector(WDScannerViewController.isOpenFlash))
    }
    
    //通过摄像头扫描
    func fromCamera() {
        do{
            self.device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            self.input = try AVCaptureDeviceInput(device: device)
            
            if self.device.hasTorch && self.device.hasFlash {
                try! self.device.lockForConfiguration()
                if self.isFlashOpen! {
                    self.device.torchMode = AVCaptureTorchMode.on
                }else{
                    self.device.torchMode = AVCaptureTorchMode.off
                }
                self.device.unlockForConfiguration()
            }
            
            self.output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            self.session = AVCaptureSession()
            if UIScreen.main.bounds.size.height<500 {
                self.session.sessionPreset = AVCaptureSessionPreset640x480
            }else{
                self.session.sessionPreset = AVCaptureSessionPresetHigh
            }
            
            self.session.addInput(self.input)
            self.session.addOutput(self.output)
            
            self.output.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code,
                                               AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,
                                               AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code]
            
            //设置可探测区域
            self.output.rectOfInterest = CGRect.init(x: 0.1, y: 0, width: 0.2, height: 1)
            
            self.preview = AVCaptureVideoPreviewLayer(session:self.session)
            self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.preview.frame = UIScreen.main.bounds
            self.view.layer.insertSublayer(self.preview, at:0)
            
            //添加中间的探测区域绿框
            self.scanRectView = UIView();
            self.view.addSubview(self.scanRectView)
            self.scanRectView.frame = CGRect.init(x: 20, y: 74, width: (WDW - 40), height: 180)
            
            self.scanRectView.addSubview(scannerLine)
            scannerLine.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(3)
                self.scannerLineTop = make.top.equalTo(10).constraint
            })
            animationWithSelectedItem(btn: scannerLine)
            
            self.scanRectView.addSubview(zuoshangBtn)
            zuoshangBtn.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
                make.top.equalTo(0)
                make.width.equalTo(34)
                make.height.equalTo(34)
            })
            zuoshangBtn.setImage(UIImage.init(named: "zuoshang"), for: UIControlState.normal)
            
            
            self.scanRectView.addSubview(zuoxiaBtn)
            zuoxiaBtn.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
                make.bottom.equalTo(0)
                make.width.equalTo(34)
                make.height.equalTo(34)
            })
            zuoxiaBtn.setImage(UIImage.init(named: "zuoxia"), for: UIControlState.normal)
            
            self.scanRectView.addSubview(youshangBtn)
            youshangBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(0)
                make.top.equalTo(0)
                make.width.equalTo(34)
                make.height.equalTo(34)
            })
            youshangBtn.setImage(UIImage.init(named: "youshang"), for: UIControlState.normal)
            
            self.scanRectView.addSubview(youxiaBtn)
            youxiaBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(0)
                make.bottom.equalTo(0)
                make.width.equalTo(34)
                make.height.equalTo(34)
            })
            youxiaBtn.setImage(UIImage.init(named: "youxia"), for: UIControlState.normal)
            
            
            self.view.addSubview(noticeInfo)
            noticeInfo.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(50)
                make.top.equalTo(self.scanRectView.snp.bottom).offset(5)
            })
            
            self.view.addSubview(bottomInput)
            bottomInput.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
                make.width.equalTo(WDW * 0.5)
                make.height.equalTo(40)
                make.bottom.equalTo(0)
            })
            bottomInput.addTarget(self, action: #selector(WDScannerViewController.inputYundan), for: UIControlEvents.touchUpInside)
            
            self.view.addSubview(sureBtn)
            sureBtn.snp.makeConstraints({ (make) in
                make.left.equalTo(bottomInput.snp.right)
                make.right.equalTo(0)
                make.height.equalTo(bottomInput)
                make.bottom.equalTo(0)
            })
            sureBtn.addTarget(self, action: #selector(WDScannerViewController.endScannerBack), for: UIControlEvents.touchUpInside)
            //开始捕获
            self.session.startRunning()
            
            //放大
            do {
                try self.device!.lockForConfiguration()
            } catch _ {
                NSLog("Error: lockForConfiguration.");
            }
            if self.device.activeFormat.videoMaxZoomFactor < 1.5 {
                self.device.videoZoomFactor = self.device.activeFormat.videoMaxZoomFactor
            }else{
                self.device.videoZoomFactor = 1.5
            }
            self.device!.unlockForConfiguration()
            
        }catch _ as NSError{
            //打印错误消息
            let errorAlert = UIAlertView(title: "提醒",
                                         message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机",
                                         delegate: self,
                                         cancelButtonTitle: "确定")
            errorAlert.show()
        }
    }
    
    func inputYundan() {
        LTAlertView.showConfigBlock({ (alertView) in
            alertView?.alertViewStyle = UIAlertViewStyle.plainTextInput
            alertView?.backgroundColor = WDThemeColor
        }, title: "运单号", message: "请手动输入运单号", buttonTitles: ["确定", "取消"]) { (alert, num) in
            let accountStr:String = (alert?.textField(at: 0)?.text)!
            if num == 0{
                self.addYundan(accountStr)
            }
        }
    }
    
    func fromCamera4Mobile() {
        
    }
    
    func addYundan(_ mailNo:String) {
        var index = 0
        let count:Int = self.mailNoArr.count
        if count < 1 {
            index = 0
        }else{
            index = count
        }
        let dict:NSDictionary = ["mailNo":mailNo, "index":"\(index)"]
        let model = WDModel4Scanner.init(dict: dict as! [String : String])
        if !verifyIsExist(mailNo: mailNo) {
            mailNoArr.append(model)
            self.tableView?.reloadData()
        }else{
            ProgressHUD.showError("运单号重复哦")
        }
        if self.device.hasTorch && self.device.hasFlash {
            try! self.device.lockForConfiguration()
            if self.isFlashOpen! {
                self.device.torchMode = AVCaptureTorchMode.on
            }
        }
    }
    
    func animationWithSelectedItem(btn:UIButton) {
        
        let animation:CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "position")
        animation.duration = 3.0
//        animation.values = [-5, 0, 5]
        
        let fromValue:NSValue = NSValue.init(cgPoint: CGPoint.init(x: WDW * 0.5 - 20, y: 10))
        let endValue:NSValue = NSValue.init(cgPoint: CGPoint.init(x: WDW * 0.5 - 20, y: 170))
        animation.values = [fromValue, endValue, fromValue]
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        btn.layer.add(animation, forKey: "scanner")
    }
    
    
    func configTableView() {
        let tableView:UITableView = UITableView.init()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.width.equalTo(self.view)
            make.top.equalTo(noticeInfo.snp.bottom).offset(10)
            make.bottom.equalTo(-50)
        }
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(WDScannerItemCell.self, forCellReuseIdentifier: "scannerCell")
        tableView.backgroundColor = UIColor.clear
    }
    
    func pop() {
        if self.device.hasTorch && self.device.hasFlash {
            try! self.device.lockForConfiguration()
            self.device.torchMode = AVCaptureTorchMode.off
            self.device.unlockForConfiguration()
        }
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0]
                as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            if stringValue != nil{
                self.session.stopRunning()
            }
        }
        self.session.stopRunning()
        //输出结果
//        let alertView = UIAlertView(title: "二维码", message: stringValue,
//                                    delegate: self, cancelButtonTitle: "确定")
//        alertView.show()
        if self.device.hasTorch && self.device.hasFlash {
            try! self.device.lockForConfiguration()
            if self.isFlashOpen! {
                self.device.torchMode = AVCaptureTorchMode.on
            }
        }
        var index = 0
        let count:Int = self.mailNoArr.count
        if count < 1 {
            index = 0
        }else{
            index = count
        }
        let dict:NSDictionary = ["mailNo":stringValue!, "index":"\(index)"]
        let model = WDModel4Scanner.init(dict: dict as! [String : String])
        if !verifyIsExist(mailNo: stringValue!) {
            mailNoArr.append(model)
        }else{
            ProgressHUD.showError("运单号重复哦")
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        if self.isBackNow! {
            self.session.stopRunning()
            endScannerBack()
        }else{
            self.tableView?.reloadData()
            self.session.startRunning()
        }
    }
    
    //消息框确认后消失
    func alertView(_ alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
        //继续扫描
        self.session.startRunning()
        if self.device.hasTorch && self.device.hasFlash {
            try! self.device.lockForConfiguration()
            if self.isFlashOpen! {
                self.device.torchMode = AVCaptureTorchMode.on
            }
        }
    }
    
    func verifyIsExist(mailNo:String)->Bool{
        for item in self.mailNoArr {
            if mailNo == item.mailNo {
                return true
            }
        }
        return false
    }
    
    func endScannerBack() {
        scannerResult!(self.mailNoArr, self.index!)
        pop()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private lazy var zuoshangBtn:UIButton = {
        let btn:UIButton = UIButton.init()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var zuoxiaBtn:UIButton = {
        let btn:UIButton = UIButton.init()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private lazy var youshangBtn:UIButton = {
        let btn:UIButton = UIButton.init()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private lazy var youxiaBtn:UIButton = {
        let btn:UIButton = UIButton.init()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var scannerLine:UIButton = {
        let btn:UIButton = UIButton.init()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage.init(named: "saomiao"), for: UIControlState.normal)
        return btn
    }()
    
    
    private lazy var sureBtn:UIButton = {
        let sureBtn:UIButton = UIButton.init()
        sureBtn.translatesAutoresizingMaskIntoConstraints = false
        sureBtn.setTitle("确定", for: UIControlState.normal)
        sureBtn.backgroundColor = WDThemeColor
        return sureBtn
    }()
    
    private lazy var bottomInput:UIButton = {
        let input:UIButton = UIButton.init()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.setTitle("手动输入", for: UIControlState.normal)
        input.backgroundColor = WDThemeColor
        return input
    }()
    
    private lazy var noticeInfo:UILabel = {
        let notice:UILabel = UILabel.init()
        notice.translatesAutoresizingMaskIntoConstraints = false
        notice.text = "将条形码放入取景框内,即可自动识别"
        notice.textColor = UIColor.white
        notice.textAlignment = NSTextAlignment.center
        return notice
    }()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mailNoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WDScannerItemCell = tableView.dequeueReusableCell(withIdentifier: "scannerCell", for: indexPath) as! WDScannerItemCell
        cell.delCellHandle = delCellWith
        cell.model = (mailNoArr[indexPath.row])
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func delCellWith(_ model:WDModel4Scanner)->Void {
        self.mailNoArr.remove(at: Int(model.index)!)
        if self.mailNoArr.count > 0 {
            var index = 0
            for item:WDModel4Scanner in self.mailNoArr {
                item.index = "\(index)"
                index = index + 1
            }
        }
        self.tableView?.reloadData()
    }
    
}

