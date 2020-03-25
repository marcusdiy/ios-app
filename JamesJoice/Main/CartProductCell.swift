//
//  CartProductCell.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 15/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

class CartProductCell : UITableViewCell{
    
    @IBOutlet weak var mCardView: UIView!
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mButtonAdd: UIButton!
    @IBOutlet weak var mCountLabel: UILabel!
    @IBOutlet weak var mButtonRemove: UIButton!
    @IBOutlet weak var mPriceLabel: UILabel!
    
    var updateCount : (() -> ())?
    var product : Product?{
        didSet{
            populate()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mCardView.clipsToBounds = true;
               mCardView.layer.cornerRadius = corners;
        
        mButtonAdd.clipsToBounds = true;
                    mButtonAdd.layer.cornerRadius = corners;
        
        mCountLabel.clipsToBounds = true;
                    mCountLabel.layer.cornerRadius = corners;
        
        mButtonRemove.clipsToBounds = true;
                    mButtonRemove.layer.cornerRadius = corners;
        
        
        
        
    }
    
    private func populate(){
        guard let product = self.product, let name = product.name else { return }
        mTitle.attributedText = NSAttributedString.init(string: name)
        Utils.setup(label: mTitle)
        
        let q = prefs?.integer(forKey: PRODUCT_Q + "\(String(describing: product.id))") ?? 0
               mCountLabel.attributedText = NSAttributedString.init(string: "\(String(describing: q))")
               Utils.setup(label: mCountLabel)
        
        populatePrice(q)
    }
    
    private func populatePrice(_ q: Int){
        guard let product = self.product else { return }
        if let price = product.regular_price, let double = Float.init(price){
           // let formatter = NumberFormatter()
            let format = String(format: "€ %.2f", double * Float.init(q))
            mPriceLabel.attributedText = NSAttributedString.init(string: format)
            Utils.setup(label: mPriceLabel)
        }
    }
    
    @IBAction func actionRemove(_ sender: Any) {
        guard let product = self.product else { return }
               
               var q = prefs?.integer(forKey: PRODUCT_Q + "\(String(describing: product.id))") ?? 0
               q = q > 0 ? q - 1 : 0
               prefs?.set(q, forKey: PRODUCT_Q + "\(String(describing: product.id))")
               mCountLabel.attributedText = NSAttributedString.init(string: "\(q)")
                      Utils.setup(label: mCountLabel)
        populatePrice(q)
        updateCount?()
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        guard let product = self.product else { return }
        
          var q = prefs?.integer(forKey: PRODUCT_Q + "\(String(describing: product.id))") ?? 0
          q += 1
          prefs?.set(q, forKey: PRODUCT_Q + "\(String(describing: product.id))")
          mCountLabel.attributedText = NSAttributedString.init(string: "\(q)")
                 Utils.setup(label: mCountLabel)
        populatePrice(q)
        updateCount?()
    }
}
