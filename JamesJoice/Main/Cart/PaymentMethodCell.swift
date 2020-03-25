//
//  PaymentMethodCell.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 17/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

class PaymentMethodCell : UITableViewCell{
    
  //  @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mBody: UIStackView!
    @IBOutlet weak var mCard: UIView!
    
    static var buttons = [UIButton]()
    var shadow : UIView?
    var arrayModel : Array<PaymentMethod>?{
        didSet{
            populate()
        }
    }
    var wrappers = [PMViewWrapper]()
    var select : ((PaymentMethod) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mCard.clipsToBounds = true
        mCard.layer.cornerRadius = corners
        
        
        
  /*      mTitle.attributedText = NSAttributedString.init(string: "Metodo di Pagamento")
        Utils.setup(label: mTitle)
 */
    }
   
    
    
    func populate(){
        guard let model = self.arrayModel else { return }
        PaymentMethodCell.buttons.removeAll()
        for view in mBody.subviews{
            view.removeFromSuperview()
        }
        wrappers.removeAll()
        for item in model{
            if let view = Bundle.main.loadNibNamed("PaymentMethodView", owner: self, options: nil)?[0] as? UIView{
              
                let pmw = PMViewWrapper.init(view: view, item: item, items: model.filter{$0 != item}, cell: self)
                self.wrappers.append( pmw)
                mBody.addArrangedSubview(view)
            }
        }
    }
    
    
    
    class PMViewWrapper{
        
        var view : UIView
        var item : PaymentMethod
        var items : [PaymentMethod]
        var cell : PaymentMethodCell
        
        init(view : UIView, item : PaymentMethod, items : [PaymentMethod], cell : PaymentMethodCell){
            self.view = view
            self.item = item
            self.items = items
            self.cell = cell
            
            let button = view.viewWithTag(1) as! UIButton
                          let label = view.viewWithTag(2) as! UILabel
                          if let name = item.name{
                              label.attributedText = NSAttributedString.init(string: name)
                              Utils.setup(label: label)
                          }
                          button.setImage(UIImage.init(named: "checkbox"), for: .normal)
                          button.setImage(UIImage.init(named: "tick"), for: .selected)
                          button.isSelected = item.selected
                          button.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .touchUpInside)
                            buttons.append(button)
        }
        
        @objc func buttonPressed(sender: UIButton){
            sender.isSelected = !sender.isSelected
            if sender.isSelected{
                item.selected = sender.isSelected
                cell.select?(item)
            for item in buttons{
                if item != sender{
                    item.isSelected = false
                }
            }
                self.item.selected = true
                for item in items{
                    item.selected = false
                }
            }
        }
    }
}



class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
