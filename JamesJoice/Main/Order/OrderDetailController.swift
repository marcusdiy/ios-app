//
//  OrderDetailController.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 18/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

class OrderDetailController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var mData : OrderDataResponse?{
        didSet{
            DispatchQueue.main.async {
                self.mTable?.reloadData()
            }
        }
    }
    
    var mTable : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTable?.delegate = self
        mTable?.dataSource = self
        
        mTable?.register(UINib.init(nibName: "OrderDetailCell", bundle: Bundle.main), forCellReuseIdentifier: "labels")
        
        if let data = self.mData{
            self.mTable?.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        if let view = Bundle.main.loadNibNamed("OrderDetailView", owner: self, options: nil)?[0] as? UIView{
            self.view = view
            mTable = view.viewWithTag(1) as! UITableView
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            guard let products = self.mData?.cart else { return 0 }
            return products.count
        case 1:
          
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labels", for: indexPath) as UITableViewCell
        let title = cell.viewWithTag(1) as! UILabel
        let value = cell.viewWithTag(2) as! UILabel
        let adds = cell.viewWithTag(3) as! UIStackView
        
        for view in adds.arrangedSubviews{
            view.removeFromSuperview()
        }
        if indexPath.section == 0{
            let product = self.mData?.cart?[indexPath.row]
            if let name = product?.name{
                let string = NSAttributedString.init(string: name)
                title.attributedText = string
                Utils.setup(label: title)
            }
            if let count = product?.qty{
                let string = NSAttributedString.init(string: "x\(count)")
                value.attributedText = string
                Utils.setup(label: value)
            }
            if let meta = product?.metadata{
                for item in meta{
                    if item.key == "addons"{
                        let view = Bundle.main.loadNibNamed("OrderAddView", owner: tableView, options: nil)![0] as! UIView
                        let label = view.viewWithTag(1) as! UILabel
                        let string = NSAttributedString.init(string: "+\( item.value ?? "")")
                        label.attributedText = string
                        Utils.setup(label: label)
                        adds.addArrangedSubview(view)
                        
                    }
                }
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }else if indexPath.section == 1{
            adds.frame.size.height = 0
            switch indexPath.row{
            case 0:
                let titleString = NSAttributedString.init(string: "Metodo")
                title.attributedText = titleString
                if let method = mData?.shipping?.method{
                    let valueString = NSAttributedString.init(string: method)
                    value.attributedText = valueString
                }
                break
            case 1:
                let titleString = NSAttributedString.init(string: "Indirizzo")
                               title.attributedText = titleString
                if let v = mData?.billing?.address1{
                                   let valueString = NSAttributedString.init(string: v)
                                   value.attributedText = valueString
                               }
                break
            case 2:
                let titleString = NSAttributedString.init(string: "Destinatario")
                                             title.attributedText = titleString
                if let name = mData?.billing?.firstName, let lastName = mData?.billing?.lastName{
                                                 let valueString = NSAttributedString.init(string: "\(name) \(lastName)")
                                                 value.attributedText = valueString
                                             }
                break
            default:
                break
            }
        }else if indexPath.section == 2{
             adds.frame.size.height = 0
            let titleString = NSAttributedString.init(string: "Metodo")
                          title.attributedText = titleString
                          if let method = mData?.payment?.name{
                              let valueString = NSAttributedString.init(string: method)
                              value.attributedText = valueString
                          }
        }
        Utils.setup(label: title)
        Utils.setup(label: value)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 407
            
        }else{
            return 74
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
                  return 407
                  
              }else{
                  return 74
              }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let view = Bundle.main.loadNibNamed("OrderDetailHeader", owner: tableView, options: nil)![0] as! UIView
            let progress = view.viewWithTag(1) as! UIProgressView
            progress.progress = Float.init(self.mData?.progress ?? 0)
            return view
        }else{
            let view = Bundle.main.loadNibNamed("CartHeader", owner: self, options: nil)?[0] as? UIView
            let lable = view?.viewWithTag(1) as! UILabel
            lable.attributedText = NSAttributedString.init(string: section == 1 ? "Indirizzo di Consegna" : "Metodo di Pagamento")
            Utils.setup(label: lable)
            return view
        }
    }
}
