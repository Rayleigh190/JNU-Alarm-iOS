//
//  ShortcutRowStackView.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/10/24.
//

import UIKit

class ShortcutRowStackView: UIStackView {
    init(_ buttons: [ShortcutButton]) {
        super.init(frame: .zero)
        self.distribution = .fillEqually
        buttons.forEach {
            self.addArrangedSubview($0)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
