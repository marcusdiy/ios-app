//
//  AlignedIconButton.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 06/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class AlignedIconButton: UIButton {
     override func layoutSubviews() {
           super.layoutSubviews()
           contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)
           let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
           titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 2, bottom: 0, right: 0)
      }
}
