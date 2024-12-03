//
//  RatingView.swift
//  Movies-app
//
//  Created by Oleh on 01.12.2024.
//

import UIKit

final class RatingView: UIView {
    
    // MARK: UI Elements

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = -2
        return stackView
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var votesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 8)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var diagramLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 5
        return layer
    }()

    // MARK: Properties

    private let maxRating: CGFloat = 10.0
    private let decimalStringFormat = "%.1f"
    private var circlePath: UIBezierPath {
        UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                     radius: (bounds.width - diagramLayer.lineWidth) / 2,
                     startAngle: -CGFloat.pi / 2,
                     endAngle: 1.5 * CGFloat.pi, clockwise: true)
    }

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayerAttributes()
    }

    // MARK: Configuration

    func configure(withRating rating: CGFloat, votes: Int) {
        guard rating >= 0, rating <= maxRating else { return }
        ratingLabel.text = String(format: decimalStringFormat, rating)
        diagramLayer.strokeColor = getColor(for: rating).cgColor
        if rating > 0 {
            diagramLayer.strokeEnd = rating / maxRating
            votesLabel.text = "\(votes)"
        } else {
            diagramLayer.strokeEnd = 1
            votesLabel.text = ""
        }
    }

    // MARK: Setup

    private func setupViews() {
        backgroundColor = .black
        layer.addSublayer(diagramLayer)
        setupStackView()
    }

    private func setupStackView() {
        addSubview(stackView)
        stackView.center(inView: self)
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(votesLabel)
    }

    private func setupLayerAttributes() {
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        diagramLayer.path = circlePath.cgPath
    }

    // MARK: Helpers

    private func getColor(for rating: CGFloat) -> UIColor {
        guard rating > 0 else { return .systemRed }
        return RatingColor(rating: rating).color
    }
}
