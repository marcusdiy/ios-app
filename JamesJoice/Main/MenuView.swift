//
//  MenuView.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 11/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

class MenuView : UIView{
    
    @IBOutlet weak var mLogoBackground: UIView!
    @IBOutlet weak var mCounterLabel: UILabel!
    @IBOutlet weak var mCartButtonBack: UIImageView!
    @IBOutlet weak var mCartButton: UIButton!
    //  @IBOutlet weak var mTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mImageView: UIImageView!
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var mHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var mTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mLogoBackground.clipsToBounds = true;
                mLogoBackground.layer.cornerRadius = mLogoBackground.frame.size.height/2;
        
        mCounterLabel.clipsToBounds = true;
           mCounterLabel.layer.cornerRadius = mCounterLabel.frame.size.height/2;
        
        mCartButton.clipsToBounds = true;
        mCartButton.layer.cornerRadius = mCartButton.frame.size.height/2;
        
        mCartButtonBack.clipsToBounds = true;
        mCartButtonBack.layer.cornerRadius = mCartButtonBack.frame.size.height/2;
        
        if let image = mCartButton.image(for: .normal){
            mCartButton.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        mCartButton.transform = CGAffineTransform(rotationAngle: CGFloat(-8.0 * .pi / 180))
        mCartButton.tintColor = UIColor.white
    }
}
