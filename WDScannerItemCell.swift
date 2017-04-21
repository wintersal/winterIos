//
//  WDScannerItemCell.swift
//  xmksBg
//
//  Created by apple on 2017/1/16.
//  Copyright © 2017年 zhoutai. All rights reserved.
//

import UIKit
import SnapKit
typealias delCell = (_ model:WDModel4Scanner)->Void
class WDScannerItemCell: UITableViewCell {
    var delBtn:UIButton?
    var indexIcon:UIButton?
    var floatLayerCenterX:Constraint? = nil
    var delCellHandle:delCell?
    var model:WDModel4Scanner?{
        didSet{
            mailNo.text = "运单号 : " + (model?.mailNo)!
            let index:Int = Int((model?.index)!)! + 1
            self.indexIcon?.setTitle("\(index)", for: UIControlState.normal)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(50)
        }
        
        let indexIcon:UIButton = UIButton.init()
        self.indexIcon = indexIcon
        indexIcon.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(indexIcon)
        indexIcon.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.centerY.equalTo(bgView)
        }
        
//        indexIcon.setImage(UIImage.init(named: "circle"), for: UIControlState.normal)
        indexIcon.setBackgroundImage(UIImage.init(named: "circle"), for: UIControlState.normal)
        indexIcon.setTitle("1", for: UIControlState.normal)
        indexIcon.setTitleColor(UIColor.blue, for: UIControlState.normal)
        
        let delBtn:UIButton = UIButton.init()
        self.delBtn = delBtn
        delBtn.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(delBtn)
        delBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalTo(bgView)
        }
//        delBtn.setTitle("删除", for: UIControlState.normal)
        delBtn.setImage(UIImage.init(named: "chacha1"), for: UIControlState.normal)
        delBtn.addTarget(self, action: #selector(WDScannerItemCell.delMailNo), for: UIControlEvents.touchUpInside)
        
        bgView.addSubview(floatLayer)
        floatLayer.snp.makeConstraints { (make) in
            make.left.equalTo(indexIcon.snp.right).offset(10)
            make.right.equalTo(delBtn.snp.left).offset(-10)
            make.top.equalTo(0)
            make.height.equalTo(bgView)
        }
        
        floatLayer.addSubview(mailNo)
        mailNo.snp.makeConstraints { (make) in
            make.left.equalTo(indexIcon.snp.right).offset(10)
            make.right.equalTo(delBtn.snp.left).offset(-10)
            make.height.equalTo(bgView)
            make.centerY.equalTo(bgView)
        }
    }
    
    func delMailNo() {
        self.delCellHandle!(model!)
    }
    
    func swipeLeft() {
        UIView.animate(withDuration: 2.0, animations: { 
            self.floatLayerCenterX?.update(offset: -100)
        }) { (finished) in
            self.layoutIfNeeded()
        }
    }
    
    func swipeRight() {
        
        UIView.animate(withDuration: 2.0, animations: {
            self.floatLayerCenterX?.update(offset: 0)
        }) { (finished) in
            self.layoutIfNeeded()
        }
    }
    
    private lazy var floatLayer:UIView = {
        let floatLayer:UIView = UIView.init()
        floatLayer.backgroundColor = UIColor.white
        floatLayer.translatesAutoresizingMaskIntoConstraints = false
        return floatLayer
    }()
    
    private lazy var mailNo:UILabel = {
        let mailNo:UILabel = UILabel.init()
        mailNo.translatesAutoresizingMaskIntoConstraints = false
        return mailNo
    }()

    private lazy var bgView:UIView = {
        let bgView:UIView = UIView.init()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        return bgView
    }()
}
