//
//  ShortcutsRowStackView.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/10/24.
//

import UIKit

class ShortcutsRowStackView: UIStackView {
    init(_ buttons: [ShortcutsButton]) {
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
