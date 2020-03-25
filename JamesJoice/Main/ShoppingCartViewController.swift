//
//  ShoppingCartViewController.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 15/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Stripe

class ShoppingCartViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var mProducts : Array<Product>?{
        didSet{
            DispatchQueue.main.async {
                 self.mTable?.reloadData()
            }
        }
    }
    var mCheckoutData : CheckoutData?
    var mTable : UITableView?
    var shippingSelected = false{
        didSet{
            if !oldValue{
                sectionCount += 1
            }
        }
    }
    
    var fields = NSMutableSet()
    
    var dictionary = NSMutableDictionary()
    var dictionaryA = NSMutableDictionary()
    
    var mTotal: UILabel?
    var mTotalString: String = ""
    var footer : UIView?
    var mPaymentMetod : PaymentMethod?
    
    private var sectionCount : Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mTable = view.viewWithTag(1) as? UITableView
        self.mTable?.dataSource = self
        self.mTable?.delegate = self
        self.mTable?.register(UINib.init(nibName: "CartProductCell", bundle: Bundle.main), forCellReuseIdentifier: "id")
        self.mTable?.register(UINib.init(nibName: "ShoppingCartFormCell", bundle: Bundle.main), forCellReuseIdentifier: "payment")
         self.mTable?.register(UINib.init(nibName: "ShippingMethodCell", bundle: Bundle.main), forCellReuseIdentifier: "shipping")
         self.mTable?.register(UINib.init(nibName: "ShopCartUserDataCell", bundle: Bundle.main), forCellReuseIdentifier: "user")
        
        let logo = view.viewWithTag(2) as! UIView
        logo.clipsToBounds = true;
                      logo.layer.cornerRadius = logo.frame.size.height/2;
        
        let logoBack = view.viewWithTag(3) as! UIView
             logoBack.clipsToBounds = true;
                           logoBack.layer.cornerRadius = logoBack.frame.size.height/2;
        if let products = self.mProducts{
            self.mTable?.reloadData()
            
            var cart = [Int64 : Int]()
            for item in products{
                let q = prefs?.integer(forKey: PRODUCT_Q + "\(String(describing: item.id))") ?? 0
                if q > 0, let id = item.id{
                    cart[id] = q
                }
            }
            ShoppingCartWorker().checkout(handler: self.handleCheckout(response:), cart: cart as NSDictionary)
            updateTotal()
        }
        
        
    }
    
    override func loadView() {
        super.loadView()
        if let view = Bundle.main.loadNibNamed("ShoppingCartView", owner: self, options: nil)?[0] as? UIView{
            self.view = view
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail", let data = sender as? OrderDataResponse{
            let controller = segue.destination as? OrderDetailController
            controller?.mData = data
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
            case 0:
                guard let products = self.mProducts else { return 0 }
                return products.count
            case 1:
                return 1
            case 2:
                guard let items = self.mCheckoutData?.shippingMethod else { return 0 }
                return items.count
            case 3:
                return shippingSelected ? 1 : 0
            default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! CartProductCell
                cell.product = self.mProducts?[indexPath.row]
                cell.updateCount = self.updateTotal
                return cell
        case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "shipping", for: indexPath) as! ShippingMethodCell
                let item = self.mCheckoutData?.shippingMethod?[indexPath.row]
                cell.fields = self.fields 
                cell.item = item
                
            //    cell.dictionary = self.dictionary
                cell.action = {
                    self.shippingSelected = true
                   
                    if let array = self.mCheckoutData?.shippingMethod{
                        for sm in array{
                            if item != sm{
                                sm.selected = false
                            }
                        }
                    }
                    self.mTable?.reloadSections([3,2], with: .automatic)
                }
                cell.setNeedsUpdateConstraints()
                cell.updateConstraints()
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                return cell
        case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "payment", for: indexPath) as! PaymentMethodCell
                cell.arrayModel = self.mCheckoutData?.paymentMethods
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                cell.select = { item in
                    self.mPaymentMetod = item
               
                }
                let stack = cell.viewWithTag(3) as! UIStackView
                for view in stack.arrangedSubviews{
                    view.removeFromSuperview()
                }
                if let paymentMethod = self.mCheckoutData?.paymentMethods?[indexPath.row]{
                    
                    let subView = Bundle.main.loadNibNamed("PaymentMethodView", owner: self, options: nil)![0] as! UIView
                }
                   
                
                
                return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! ShopCartUserDataCell
            cell.dictionaryA = self.dictionaryA
            cell.dictionary = self.dictionary
            cell.fields = self.mCheckoutData?.fields
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell
        default:
                return UITableViewCell.init(frame: CGRect.init())
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let view = Bundle.main.loadNibNamed("CartHeader", owner: self, options: nil)?[0] as? UIView
             let lable = view?.viewWithTag(1) as! UILabel
        
        switch section {
        case 0:
            lable.attributedText = NSAttributedString.init(string: "Carrello")
            break
            case 1:
            lable.attributedText = NSAttributedString.init(string: "Dati Personali")
            break
        case 2:
            lable.attributedText = NSAttributedString.init(string: "Metodo d'Ordine")
            break
        case 3:
            lable.attributedText = NSAttributedString.init(string: "Metodo di Pagamento")
             Utils.setup(label: lable)
            return shippingSelected ? view : nil
           
        default:
            break
        }
                Utils.setup(label: lable)
            
                
                return view
            
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         if section == (shippingSelected ? 3 : 2){
            return UITableView.automaticDimension
         }else{
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 137
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == (shippingSelected ? 3 : 2){
         /*   if let _ = self.footer{
                return self.footer
            }*/
            let view = Bundle.main.loadNibNamed("ShoppingCartFooter", owner: tableView, options: nil)![0] as! UIView
            self.mTotal = view.viewWithTag(2) as! UILabel
            self.mTotal?.text = self.mTotalString
            let button = view.viewWithTag(3) as! UIButton
            button.addTarget(self, action: #selector(submitAction_), for: .touchUpInside)
            self.footer = view
            return view
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section <= (shippingSelected ? 3 : 2){
            return UITableView.automaticDimension
        }else{
            return 0.01
        }
       
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func handleCheckout(response: AFDataResponse<String>){
          switch response.result {
                          case let .success(value):
           // if let json =  value as? [String: Any] {
                            if let data = value.data(using: .utf8) {
                                do {
                                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]{
                               
                                            print("JSON: \(json)") // serialized json response
                                            let dict = NSDictionary.init(dictionary: json)
                                            let model = JSendResponse<CheckoutData>.init(dictionary: dict)
                                          guard let checkoutData = model?.data else { return  }
                                        self.mCheckoutData = checkoutData
                                    }
                                    
                                    } catch {
                                                                       print(error.localizedDescription)
                                                                   }
                                                               }
                
                DispatchQueue.main.async {
                    self.mTable?.reloadData()
                }
             break
          case let .failure(error):
            print(error)
        }
           
         
        }
    
    
    func updateTotal(){
        guard let products = self.mProducts else { return }
        var sum : Float = 0
        for item in products{
            guard let priceStr = item.regular_price, let price = Float.init(priceStr) else { continue }
            let q = prefs?.integer(forKey: PRODUCT_Q + "\(String(describing: item.id))") ?? 0
            sum += Float.init(q) * price
        }
        
        let format = String(format: "%.2f", sum)
        self.mTotal?.text = "€ \(format)"
        self.mTotalString = "€ \(format)"
    }
    
    @objc func submitAction_(){
        let params = [String: String].init()
           self.submitAction( params)
       // guard let paymentMethod = self.mPaymentMetod, let key = paymentMethod.settings?["public_key"] else { return }
       // Stripe.setDefaultPublishableKey(key)
    
    }
    
    
    
    @objc func submitAction(_ additionalParams : [String: String]){
        guard let fields = self.mCheckoutData?.fields,
            let smArray = self.mCheckoutData?.shippingMethod,
            let pmArray = self.mCheckoutData?.paymentMethods else { return }
       var list = Array<CheckoutField>()
        let enumerator = dictionary.keyEnumerator()
        while let key = enumerator.nextObject() {
            print(key)
            guard let field = key as? CheckoutField,
            let component = dictionary[field] as? UITextField,
            let text = component.attributedText?.string else { continue }
            field.values.insert(text)
            list.append(field)
        }
   /*
         for item in dictionary{
            guard let field = item.key as? CheckoutField,
                let component = item.value as? UITextField,
                let text = component.attributedText?.string else { continue }
            field.values.insert(text)
        }
 */
        
        let enumeratorA = dictionaryA.keyEnumerator()
        while let key = enumeratorA.nextObject() {
            print(key)
            guard let field = key as? CheckoutField,
            let component = dictionaryA[key] as? UITextView,
            let text = component.text  else { continue }
            field.values.insert(text)
            list.append(field)
        }
        
       // list.append(contentsOf: self.fields as! Array<CheckoutField>)
        /*
        for item in dictionaryA{
             guard let field = item.key as? CheckoutField,
                let component = item.value as? UITextView,
                let text = component.text else { continue }
             field.values.insert(text)
        }
        */
        list.append(contentsOf: self.fields.filter{!($0 as! CheckoutField).values.isEmpty} as! Array<CheckoutField>)
        list.append(contentsOf: fields.filter{!$0.values.isEmpty})
        let shippingMethod = smArray.filter{ $0.selected }.first
        let paymentMethod = pmArray.filter{ $0.selected}.first
        print("submit order")
        
        
        
        guard let products = self.mProducts, let sm = shippingMethod , let pm = paymentMethod else { return }
        var cart = [Int64 : Int]()
                   for item in products{
                       let q = prefs?.integer(forKey: PRODUCT_Q + "\(String(describing: item.id))") ?? 0
                       if q > 0, let id = item.id{
                           cart[id] = q
                       }
                   }
        
        ShoppingCartWorker.init().submitOrder( cart: cart as NSDictionary, shippingMethod: sm, paymentMethod: pm, params: list, id: 5){ response in
            switch response.result {
                                case let .success(value):
                  if let json =  value as? [String: Any] {
                                                  print("JSON: \(json)") // serialized json response
                                                  let dict = NSDictionary.init(dictionary: json)
                                                  let model = JSendResponse<OrderDataResponse>.init(dictionary: dict)
                    
                    if let status = model?.status, status == "success"{
                                                guard let orderDataResponse = model?.data else { return  }
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "toDetail", sender: orderDataResponse)
                                                   
                        }
                                              print("order success")
                    }else{
                        
                    }
                      
                      
                  }
                  break
                case let .failure(error):
                  print(error)
                  break
              }
        }
        
    }
}
/*
 SharedPreferences prefs = getSharedPreferences(PRODUCT_Q, Context.MODE_PRIVATE);
       double sum = 0;
       try {
           for (Product p : mProducts) {
               int q = prefs.getInt(MenuActivity.getProductQuantityKey(p), 0);


                   Double price = Double.parseDouble(p.getRegular_price());
                   sum += price * q;

           }
           NumberFormat format = new DecimalFormat("#.##");

           format.setMinimumFractionDigits(2);
           this.mSumLabel.setText("\u20ac" + format.format(sum));
 */
