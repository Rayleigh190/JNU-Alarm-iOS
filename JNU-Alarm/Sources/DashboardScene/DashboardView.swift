//
//  DashboardView.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/10/24.
//

import UIKit

class DashboardView: UIView {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // 날씨 Start
    private lazy var yonbongLabel: UILabel = {
        let label = UILabel()
        label.text = "용봉캠"
        label.textAlignment = .center
        label.font = label.font.withSize(15)
        return label
    }()
    
    private lazy var yonbongImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "cloud.sun")!)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 50)
        ])
        return image
    }()
    
    private lazy var yonbongWeatherLabel: UILabel = {
        let label = UILabel()
        label.text = "24.6 / 맑음"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var yongbongStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
//        stackView.backgroundColor = .red
        stackView.addArrangedSubview(yonbongLabel)
        stackView.addArrangedSubview(yonbongImage)
        stackView.addArrangedSubview(yonbongWeatherLabel)
        return stackView
    }()
    
    private lazy var yeosuLabel: UILabel = {
        let label = UILabel()
        label.text = "여수캠"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var yeosuImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "cloud.sun")!)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 50)
        ])
        return image
    }()
    
    private lazy var yeosuWeatherLabel: UILabel = {
        let label = UILabel()
        label.text = "24.6 / 맑음"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var yeosuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
//        stackView.backgroundColor = .green
        stackView.addArrangedSubview(yeosuLabel)
        stackView.addArrangedSubview(yeosuImage)
        stackView.addArrangedSubview(yeosuWeatherLabel)
        return stackView
    }()
    
    private lazy var hagdongLabel: UILabel = {
        let label = UILabel()
        label.text = "학동캠"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var hagdongImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "cloud.sun")!)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 50)
        ])
        return image
    }()
    
    private lazy var hagdongWeatherLabel: UILabel = {
        let label = UILabel()
        label.text = "24.6 / 맑음"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var hagdongStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
//        stackView.backgroundColor = .blue
        stackView.addArrangedSubview(hagdongLabel)
        stackView.addArrangedSubview(hagdongImage)
        stackView.addArrangedSubview(hagdongWeatherLabel)
        return stackView
    }()
    
    private lazy var weatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        [yongbongStackView, yeosuStackView, hagdongStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    // 날씨 End
    
    private lazy var shortcutLabel: UILabel = {
        let label = UILabel()
        label.text = "  바로가기"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        
        return label
    }()
    
    lazy var academicCalendarShortcutButton = ShortcutButton(name: "학사 일정", imageNmae: "calendar", imageColor: .systemGreen, link: "https://www.jnu.ac.kr/WebApp/web/HOM/TOP/Schedule300.aspx")
    
    lazy var schoolMenuShortcutButton = ShortcutButton(name: "학식 메뉴", imageNmae: "fork.knife", imageColor: .systemOrange, link: "https://today.jnu.ac.kr/Program/MealPlan.aspx")
   
    lazy var dormitoryMenuShortcutButton = ShortcutButton(name: "긱식 메뉴", imageNmae: "fork.knife", imageColor: .systemOrange, link: nil)
    
    lazy var restaurantRecommendationsButton = ShortcutButton(name: "식당 추천", imageNmae: "takeoutbag.and.cup.and.straw.fill", imageColor: .systemIndigo, link: nil)
    
    private lazy var shortcutButtonFirstRow = ShortcutRowStackView([
        academicCalendarShortcutButton,
        schoolMenuShortcutButton,
        dormitoryMenuShortcutButton,
        restaurantRecommendationsButton,
    ])
    
    lazy var shortcutButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        [shortcutButtonFirstRow].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private lazy var shortcutStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        stackView.axis = .vertical
        stackView.spacing = 12
//        stackView.backgroundColor = .lightGray
        [shortcutLabel, shortcutButtonStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        [adImageView, shortcutStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()


    init(isEditable: Bool = true) {
        super.init(frame: .zero)
        setupSubViews()
        backgroundColor = .systemBackground
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setupSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(backgroundStackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        adImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adImageView.heightAnchor.constraint(equalTo: adImageView.widthAnchor, multiplier: 3.0/4.0)
        ])
        
        backgroundStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            backgroundStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

}
