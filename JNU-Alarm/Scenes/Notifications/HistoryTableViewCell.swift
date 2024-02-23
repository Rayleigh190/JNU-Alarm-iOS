//
//  HistoryTableViewCell.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/21/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    static let indentifier = "HistoryTableViewCell"
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이틀"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "바디"
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(bodyLabel)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(bodyLabel)
        accessoryType = .disclosureIndicator
//        labelStackView.frame = bounds
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // labelStackView의 leading과 trailing constraint 설정
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10), // 왼쪽 inset
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35), // 오른쪽 inset
            labelStackView.topAnchor.constraint(equalTo:topAnchor, constant: 10),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        bodyLabel.text = nil
    }
    
    public func configure(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }

}
