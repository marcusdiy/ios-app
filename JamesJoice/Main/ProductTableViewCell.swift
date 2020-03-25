//
//  ProductTableViewCell.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 12/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let PRODUCT_Q = "product_quantity"
let prefs : UserDefaults? = UserDefaults.standard//init(suiteName: PRODUCT_Q)

class ProductTableViewCell : UITableViewCell{
    
     
    
    @IBOutlet weak var mLabelPrice: UILabel!
    @IBOutlet weak var mRemoveButton: UIButton!
    @IBOutlet weak var mButtonAdd: UIButton!
    @IBOutlet weak var mLabelCount: UILabel!
    @IBOutlet weak var mImageHeight: NSLayoutConstraint!
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mContent: UILabel!
    var product : Product?{
        didSet{
            populate()
        }
    }
    
    var imageRequest : DataRequest?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mLabelCount.clipsToBounds = true;
               mLabelCount.layer.cornerRadius = corners;
        
        mRemoveButton.clipsToBounds = true;
                     mRemoveButton.layer.cornerRadius = corners;
        
        mButtonAdd.clipsToBounds = true;
                     mButtonAdd.layer.cornerRadius = corners;
        
        mImage.clipsToBounds = true;
                     mImage.layer.cornerRadius = corners;
        
        setup(label: mTitle)
        setup(label: mContent)
        setup(label: mLabelCount)
        setup(label: mLabelPrice)
        
        setupButtonTitle(button: mButtonAdd)
        setupButtonTitle(button: mRemoveButton)
        
        mButtonAdd.addTarget(self, action: #selector(self.add), for: .touchUpInside)
        mRemoveButton.addTarget(self, action: #selector(self.remove), for: .touchUpInside)
    }
    
    func populate(){
        guard let product = self.product else { return }
        
        mTitle.text = product.name
        mContent.text = product.content
        
        mLabelPrice.text = "\(product.regular_price ?? "") €"
        
        mImage.image = nil
        mImageHeight.constant = 0;
        self.imageRequest?.cancel()
        if let url = product.image?.first?.full?.url{
                               let request =  AF.request(url, method: .get)
            self.imageRequest = request
                                request.response{response in
                                     switch response.result {
                                     case let .success(value):
                                         guard let data = value else { break }
                                         self.mImage.image = UIImage.init(data: data, scale: 1)
                                         break
                                     case let .failure(error):
                                                             // Handle the error, a 404 for example.
                                         print(error)
                                         break
                                     }
                                 }
                             }
        
        if let image = product.image?.first?.full, let height = image.height, let width = image.width{
            let aspectRatio = Float.init(width) / Float.init(height)
            mImageHeight.constant = self.mImage.frame.size.width / CGFloat(aspectRatio)
        }
        
        
      
        let q = prefs?.integer(forKey: PRODUCT_Q + "\(String(describing: product.id))") ?? 0
        mLabelCount.attributedText = NSAttributedString.init(string: "\(String(describing: q))")
        Utils.setup(label: mLabelCount)
    }
    
    private func setupButtonTitle(button : UIButton){
       if let attributedTitle = button.attributedTitle(for: .normal) {
                  let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
                  mutableAttributedTitle.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSMakeRange(0, attributedTitle.length))
                 
                  button.setAttributedTitle(mutableAttributedTitle, for: .normal)
              }
       }
    
    private func setup(label: UILabel){
        if let attributedTitle = label.attributedText {
                          let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
                          mutableAttributedTitle.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSMakeRange(0, attributedTitle.length))
                         label.attributedText = mutableAttributedTitle
                      }
    }
    
    @objc func add(){
        guard let product = self.product else { return }
      
        var q = prefs?.integer(forKey: PRODUCT_Q + "\(String(describing: product.id))") ?? 0
        q += 1
        prefs?.set(q, forKey: PRODUCT_Q + "\(String(describing: product.id))")
        mLabelCount.attributedText = NSAttributedString.init(string: "\(q)")
               Utils.setup(label: mLabelCount)
    }
    
    @objc func remove(){
        guard let product = self.product else { return }
        
        var q = prefs?.integer(forKey: PRODUCT_Q + "\(String(describing: product.id))") ?? 0
        q = q > 0 ? q - 1 : 0
        prefs?.set(q, forKey: PRODUCT_Q + "\(String(describing: product.id))")
        mLabelCount.attributedText = NSAttributedString.init(string: "\(q)")
               Utils.setup(label: mLabelCount)
    }
}
