//
//  RemovableHashtagCollectionViewCell.swift
//  Hashtags
//
//  Created by Oscar Götting on 6/8/18.
//  Copyright © 2018 Oscar Götting. All rights reserved.
//

import Foundation
import UIKit

fileprivate extension Selector {
    static let removeButtonClicked: Selector = #selector(RemovableHashtagCollectionViewCell.onRemoveButtonClicked(_:))
}

public protocol RemovableHashtagDelegate: class {
    func onRemoveHashtag(hashtag: HashTag)
}

open class RemovableHashtagCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RemovableHashtagCollectionViewCell"

    var paddingLeftConstraint: NSLayoutConstraint?
    var paddingRightConstraint: NSLayoutConstraint?
    var paddingTopConstraint: NSLayoutConstraint?
    var paddingBottomConstraint: NSLayoutConstraint?
    var removeButtonHeightConstraint: NSLayoutConstraint?
    var removeButtonWidthConstraint: NSLayoutConstraint?
    var removeButtonSpacingConstraint: NSLayoutConstraint?
    
    lazy var wordLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var removeButton : UIButton = {
        let btn = UIButton()
        let bundle = Bundle(for: RemovableHashtagCollectionViewCell.self)
        let removeIcon = UIImage(named: "close", in: bundle, compatibleWith: nil)!
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = UIColor.white
        
        if let removeIcon = UIImage(named: "close", in: bundle, compatibleWith: nil) {
            let tintableImage = removeIcon.withRenderingMode(.alwaysTemplate)
            btn.setImage(removeIcon, for: .normal)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageView?.tintColor = UIColor.white.withAlphaComponent(0.9)
        } else {
            btn.setTitle("X", for: UIControl.State.normal)
        }
        
       
        return btn
    }()
    
    open weak var delegate: RemovableHashtagDelegate?
    
    open var hashtag: HashTag?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.clipsToBounds = true
        
        self.addSubview(wordLabel)
        self.addSubview(removeButton)
        
        // Padding left
        self.paddingLeftConstraint = self.wordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        self.paddingLeftConstraint!.isActive = true
        // Padding top
        self.paddingTopConstraint = self.wordLabel.topAnchor.constraint(equalTo: self.topAnchor)
        self.paddingTopConstraint!.isActive = true
        // Padding bottom
        self.paddingBottomConstraint = self.wordLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        self.paddingBottomConstraint!.isActive = true
        // Remove button spacing
        self.removeButtonSpacingConstraint = self.removeButton.leadingAnchor.constraint(equalTo: self.wordLabel.trailingAnchor)
        self.removeButtonSpacingConstraint!.isActive = true
        // Remove button width
        self.removeButtonWidthConstraint = self.removeButton.widthAnchor.constraint(equalToConstant: 0.0)
        self.removeButtonWidthConstraint!.isActive = true
        // Remove button height
        self.removeButtonHeightConstraint = self.removeButton.heightAnchor.constraint(equalTo: self.wordLabel.heightAnchor)
        self.removeButtonHeightConstraint!.isActive = true
        // Remove button Y alignment
        self.removeButton.centerYAnchor.constraint(equalTo: self.wordLabel.centerYAnchor).isActive = true
        self.removeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5).isActive = true
        // Remove button target
        self.removeButton.addTarget(self, action: Selector.removeButtonClicked, for: .touchUpInside)
    }
    
    open override func prepareForInterfaceBuilder() {
        self.wordLabel.text = ""
        super.prepareForInterfaceBuilder()
    }
    
    @objc
    func onRemoveButtonClicked(_ sender: UIButton) {
        guard let hashtag = self.hashtag else {
            return
        }
        self.delegate?.onRemoveHashtag(hashtag: hashtag)
    }
}

extension RemovableHashtagCollectionViewCell {
    open func configureWithTag(tag: HashTag, configuration: HashtagConfiguration) {
        self.hashtag = tag
        self.wordLabel.text = tag.text
        self.wordLabel.font = configuration.hashtagFont
        self.paddingLeftConstraint!.constant = configuration.paddingLeft
        self.paddingTopConstraint!.constant = configuration.paddingTop
        self.paddingBottomConstraint!.constant = -1 * configuration.paddingBottom
        self.removeButtonWidthConstraint!.constant = configuration.removeButtonSize
        self.backgroundColor = configuration.backgroundColor
        self.wordLabel.textColor = tag.isGoldTag ? configuration.goldTagColor : configuration.textColor
        self.wordLabel.layoutSubviews()
    }
}
