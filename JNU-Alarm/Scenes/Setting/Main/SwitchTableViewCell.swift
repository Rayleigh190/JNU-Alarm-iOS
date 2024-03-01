//
//  SwitchTableViewCell.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/14/24.
//

import UIKit
import FirebaseMessaging

class SwitchTableViewCell: UITableViewCell {
    static let indentifier = "SwitchTableViewCell"
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        return mySwitch
    }()
    
    var switchValueChanged: ((UISwitch) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        contentView.addSubview(mySwitch)
        iconContainer.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .none
        mySwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        switchValueChanged?(sender)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        let imageSize: CGFloat = size/1.5
        iconImageView.frame = CGRect(x: (size-imageSize)/2, y: (size-imageSize)/2, width: imageSize, height: imageSize)
        
        mySwitch.sizeToFit()
        mySwitch.frame = CGRect(
            x: contentView.frame.size.width - mySwitch.frame.size.width - 20,
            y: (contentView.frame.size.height - mySwitch.frame.size.height)/2,
            width: mySwitch.frame.size.width,
            height: mySwitch.frame.size.height)
        
        label.frame = CGRect(
            x: 25+iconContainer.frame.size.width,
            y: 0,
            width: contentView.frame.size.width-20-iconContainer.frame.size.width,
            height: contentView.frame.size.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
        mySwitch.isOn = false
        mySwitch.isEnabled = true
    }
    
    public func configure(with model: SettingsSwitchOption) {
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        mySwitch.isOn = model.isOn
        if !model.isEnabled {
            mySwitch.isEnabled = false
        }
    }
}

class SwitchButton {
    class func switchButtonTapped(sender: UISwitch, topic: String, completion: @escaping () -> ()) {
        if sender.isOn {
            // 주제 구독 요청
            Messaging.messaging().subscribe(toTopic: topic) { error in
                if let error = error {
                    print("Error subscribe: \(error)")
                    Alert.showAlert(title: "안내", message: "알림 구독 중 오류가 발생했습니다. 다시 시도해 주세요.")
                    sender.setOn(false, animated: true)
                } else {
                  print("Subscribed to \(topic) topic")
                  ConfigData.set(isOn: true, topic: topic)
                }
                completion()
            }
        } else {
            // 주제 구독 취소
            Messaging.messaging().unsubscribe(fromTopic: topic) { error in
                if let error = error {
                    print("Error unsubscribe: \(error)")
                    Alert.showAlert(title: "안내", message: "알림 구독 취소 중 오류가 발생했습니다. 다시 시도해 주세요.")
                    sender.setOn(true, animated: true)
                  } else {
                      print("Unsubscribed to \(topic) topic")
                      ConfigData.set(isOn: false, topic: topic)
                  }
                completion()
            }
        }
    }
}
