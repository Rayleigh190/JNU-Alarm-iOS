//
//  ShortcutsButton.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/10/24.
//

import UIKit

class ShortcutsButton: UIView {
    var link: String? = nil
    
    private lazy var shortcutsImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 35)
        ])
        return image
    }()
    
    private lazy var shortcutsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = label.font.withSize(15)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        [shortcutsImage, shortcutsLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    init(name: String, imageNmae: String, imageColor: UIColor, link: String?) {
        super.init(frame: .zero)
        shortcutsImage.image = UIImage(systemName: imageNmae)
        shortcutsImage.tintColor = imageColor
        shortcutsLabel.text = name
        setupSubVies()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubVies() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: stackView.topAnchor),
            button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
}
