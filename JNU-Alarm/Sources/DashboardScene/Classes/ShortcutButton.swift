//
//  ShortcutButton.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/10/24.
//

import UIKit

class ShortcutButton: UIButton {
    var shortcutLink: String?
    var isModal: Bool = true
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private lazy var shortcutImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = false
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 35)
        ])
        return image
    }()
    
    private lazy var shortcutLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(15)
        return label
    }()
    
    init(name: String, imageNmae: String, imageColor: UIColor, link: String?, isModal: Bool = true) {
        super.init(frame: .zero)
        [shortcutImage, shortcutLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        shortcutImage.image = UIImage(systemName: imageNmae)
        shortcutImage.tintColor = imageColor
        shortcutLabel.text = name
        self.shortcutLink = link
        self.isModal = isModal
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        fatalError("init(coder:) has not been implemented")
    }
}
