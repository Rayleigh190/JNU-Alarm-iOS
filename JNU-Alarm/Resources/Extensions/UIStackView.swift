//
//  UIStackView.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/12/24.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviewsExceptFirst() {
        // 첫 번째 요소를 제외한 모든 요소를 배열로 만듦
        let viewsToRemove = Array(arrangedSubviews.dropFirst())
        
        // 스택 뷰에서 제거
        viewsToRemove.forEach { view in
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
