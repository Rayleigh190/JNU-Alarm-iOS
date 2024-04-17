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
        stackView.spacing = 3
        stackView.axis = .vertical
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이틀"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2024.0.0"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    private let topLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "바디"
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(labelStackView)
        topLabelStackView.addArrangedSubview(titleLabel)
        topLabelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(topLabelStackView)
        labelStackView.addArrangedSubview(bodyLabel)

        accessoryType = .disclosureIndicator
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // labelStackView의 leading과 trailing constraint 설정
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17), // 왼쪽 inset
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
        dateLabel.text = nil
    }
    
    public func configure(title: String, body: String, date: String) {
        titleLabel.text = title
        bodyLabel.text = body
        dateLabel.text = date
    }

}
