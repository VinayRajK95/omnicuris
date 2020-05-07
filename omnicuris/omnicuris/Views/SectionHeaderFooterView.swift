//
//  SectionHeaderFooterView.swift
//  omnicuris
//
//  Created by Vinay Raj K on 06/05/20.
//  Copyright © 2020 Vinay Raj K. All rights reserved.
//

import UIKit
import Foundation

public class SectionHeaderFooterView: UITableViewHeaderFooterView {

    var delegate : Expandabledelegate!
    
    let containerView : UIView = {
        let innerContainer = UIView(frame: CGRect.zero)
        innerContainer.translatesAutoresizingMaskIntoConstraints = false
        innerContainer.isUserInteractionEnabled = true
        return innerContainer
    }()
    
    var section : Int = 0
    
    let cityLabel : UILabel = {
        let innerLabel = UILabel(frame: CGRect.zero)
        innerLabel.translatesAutoresizingMaskIntoConstraints = false
        innerLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: CGFloat(20))
        return innerLabel
    }()
    
    let button : UIButton = {
        let innerButton = UIButton(frame: CGRect.zero)
        
        innerButton.translatesAutoresizingMaskIntoConstraints = false
        innerButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        innerButton.setTitle("+", for: .normal)
        innerButton.setTitle("x", for: .selected)
        innerButton.setTitleColor(.blue, for: .normal)
        innerButton.setTitleColor(.blue, for: .selected)
        return innerButton
    }()
    
    var isCelcius: Bool = true {
        didSet {
            let label = isCelcius ? temparature : tempInFah
            let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            UIView.transition(with: temperatureLabel, duration: 1.0, options: transitionOptions, animations: {
                self.temperatureLabel.text = label
            })
        }
    }
    
    var tempInFah: String = ""{
        didSet {
            tempInFah += "°F"
        }
    }
    
    @objc var temparature: String = "" {
        didSet{
            tempInFah = "\(((Float(temparature) ?? 0) * 9/5) + 32)"
            temparature += "°C"
            temperatureLabel.text = temparature
        }
    }
    
    let temperatureLabel : UILabel = {
       let innerLabel = UILabel(frame: CGRect.zero)
       innerLabel.translatesAutoresizingMaskIntoConstraints = false
        innerLabel.isUserInteractionEnabled = true
        innerLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: CGFloat(20))
       return innerLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
        let tempTapGesture = UITapGestureRecognizer(target: self, action: #selector(tempTapped(_:)))
        self.addSubview(containerView)
        containerView.addSubview(cityLabel)
        containerView.addSubview(button)
        containerView.addSubview(temperatureLabel)
        setupConstraints()
        containerView.addGestureRecognizer(tapGesture)
        temperatureLabel.addGestureRecognizer(tempTapGesture)
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func tempTapped( _ gesture: UITapGestureRecognizer) {
        self.isCelcius = !self.isCelcius
        delegate.updateCelcius(section: section,isCelcius: isCelcius)
    }
    
    @objc func headerTapped( _ gesture: UITapGestureRecognizer) {
        handleToggle()
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        handleToggle()
    }
    
    func handleToggle() {
        button.isSelected = !button.isSelected
        delegate.toggleSection(cell: self, section: section, isCelcius: isCelcius)
    }
    
    func setupConstraints() {
        let subviews = ["cityLabel":cityLabel,"button":button,"temperatureLabel":temperatureLabel]
        NSLayoutConstraint.activate(NSLayoutConstraint.createConstraint(format: "H:|[containerView]|", subViewDict: ["containerView":containerView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.createConstraint(format: "V:|[containerView]|", subViewDict: ["containerView":containerView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.createConstraint(format: "H:|-[cityLabel]-(>=16)-[temperatureLabel]-(16)-[button]-|", subViewDict: subviews))
        cityLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor).isActive = true
    }
    
    func getAttributedString(temp: String, nonBoldRange: NSRange?) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: temp, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: temp, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.blue]))
        return attributedText
    }
}

protocol Expandabledelegate {
    func toggleSection(cell: UITableViewHeaderFooterView, section: Int,isCelcius: Bool)
    func updateCelcius(section: Int,isCelcius: Bool)
}
