//
//  HashtagView.swift
//  Hashtags
//
//  Created by Oscar Götting on 6/6/18.
//  Copyright © 2018 Oscar Götting. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

// MARK: Class

@IBDesignable
@objc open class HashtagView: UIView {
    
    private var sizingLabel = UILabel(frame: .zero)
    
    private var lastDimension: CGSize?
    
    private var originalHeight: CGFloat?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        return view
    }()
    
    public var hashtags: [HashTag] = []

    @objc public var delegate: HashtagViewDelegate?

    @IBInspectable
    open var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    // MARK: Container padding (insets)
    
    @IBInspectable
    open var containerPaddingLeft: CGFloat = 0.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var containerPaddingRight: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var containerPaddingTop: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var containerPaddingBottom: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    // MARK: Hashtag cell padding
    
    @IBInspectable
    open var tagPaddingLeft: CGFloat = 8.0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var tagPaddingRight: CGFloat = 8.0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var tagPaddingTop: CGFloat = 8.0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var tagPaddingBottom: CGFloat = 8.0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var tagCornerRadius: CGFloat = 12.0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var textSize: CGFloat = 12.0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var tagBackgroundColor: UIColor = .lightGray {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var tagTextColor: UIColor = .white {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var goldTagTextColor: UIColor = .yellow {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var tagFont: UIFont = UIFont.systemFont(ofSize: 13.0) {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var removeButtonSize: CGFloat = 20.0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var removeButtonSpacing: CGFloat = 8.0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Hashtags cell margins
    
    @IBInspectable
    open var horizontalTagSpacing: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var verticalTagSpacing: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    // MARK: Constructors
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        self.addTag(tag: HashTag(word: "hashtag"))
    }

    open override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        
        var size = self.collectionView.collectionViewLayout.collectionViewContentSize
        
        size.width = size.width + self.containerPaddingLeft + self.containerPaddingRight
        size.height = size.height + self.containerPaddingTop + self.containerPaddingBottom

        if size.width == 0 || size.height == 0 {
            size = CGSize(width: 100, height:44)
        }
        return size
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
    

    func makeConfiguration() -> HashtagConfiguration {
        
        let configuration = HashtagConfiguration()
        
        configuration.paddingLeft = self.tagPaddingLeft
        configuration.paddingRight = self.tagPaddingRight
        configuration.paddingTop = self.tagPaddingTop
        configuration.paddingBottom = self.tagPaddingBottom
        configuration.removeButtonSize = self.removeButtonSize
        configuration.removeButtonSpacing = self.removeButtonSpacing
        configuration.backgroundColor = self.tagBackgroundColor
        configuration.cornerRadius = self.tagCornerRadius
        configuration.textSize = self.textSize
        configuration.textColor = self.tagTextColor
        configuration.hashtagFont = self.tagFont
        configuration.goldTagColor = self.goldTagTextColor
        
        return configuration
    }
    
    func setup() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.cornerRadius

        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        alignedFlowLayout.minimumLineSpacing = self.horizontalTagSpacing
        alignedFlowLayout.minimumInteritemSpacing = self.verticalTagSpacing
        alignedFlowLayout.sectionInset = UIEdgeInsets(top: self.containerPaddingTop,
                                                      left: self.containerPaddingLeft,
                                                      bottom: self.containerPaddingBottom,
                                                      right: self.containerPaddingRight)

        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.collectionViewLayout = alignedFlowLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.isScrollEnabled = false
        
        self.collectionView.register(HashtagCollectionViewCell.self,
                                     forCellWithReuseIdentifier: HashtagCollectionViewCell.cellIdentifier)
        self.collectionView.register(RemovableHashtagCollectionViewCell.self,
                                     forCellWithReuseIdentifier: RemovableHashtagCollectionViewCell.cellIdentifier)
       
        self.collectionView.removeFromSuperview()
        self.addSubview(self.collectionView)
    }
    
    @objc public func resize() {
        guard let delegate = self.delegate else {
            return
        }
        
        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
        
        if self.lastDimension != nil {
            if lastDimension!.height != contentSize.height {
               delegate.viewShouldResizeTo(size: contentSize)
            }
        } else {
            delegate.viewShouldResizeTo(size: contentSize)
        }
        self.lastDimension = contentSize
    }
}

extension HashtagView {

    @objc open func addTag(tag: HashTag) {
        self.hashtags.append(tag)
        self.collectionView.reloadData()
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()

        resize()
    }

    @objc open func addTags(tags: [HashTag]) {
        self.hashtags.append(contentsOf: tags)
        self.collectionView.reloadData()
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
        resize()
    }

    @objc open func removeTag(tag: HashTag) {
        self.hashtags.remove(object: tag)
        self.collectionView.reloadData()
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
        resize()
    }
    
    @objc open func removeTags() {
        self.hashtags.removeAll()
        self.collectionView.reloadData()
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
        resize()
    }

    @objc open func getTags() -> [HashTag] {
        return self.hashtags
    }
}

extension HashtagView: RemovableHashtagDelegate {
    public func onRemoveHashtag(hashtag: HashTag) {
        removeTag(tag: hashtag)
        self.delegate?.hashtagRemoved(hashtag: hashtag)
    }
}

extension HashtagView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hashtags.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hashtag: HashTag = self.hashtags[indexPath.item]
        if hashtag.isRemovable {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemovableHashtagCollectionViewCell.cellIdentifier,
                                                          for: indexPath) as! RemovableHashtagCollectionViewCell
            
            cell.delegate = self

            cell.layer.cornerRadius = cell.frame.height/2
            cell.configureWithTag(tag: hashtag, configuration: makeConfiguration())
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HashtagCollectionViewCell.cellIdentifier,
                                                      for: indexPath) as! HashtagCollectionViewCell

        cell.layer.cornerRadius = cell.frame.height/2
        cell.configureWithTag(tag: hashtag, configuration: makeConfiguration())
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hashtag: HashTag = self.hashtags[indexPath.item]
        if (self.delegate != nil) {
            self.delegate?.hashtagViewTapped?(hashtag: hashtag)
        }
    }
}

extension HashtagView: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hashtag: HashTag = self.hashtags[indexPath.item]
        let wordSize = hashtag.text.sizeOfString(usingFont: self.tagFont)
        
        var calculatedHeight = CGFloat()
        var calculatedWidth = CGFloat()
        
        calculatedHeight = self.tagPaddingTop + wordSize.height + self.tagPaddingBottom
        calculatedWidth = self.tagPaddingLeft + wordSize.width + self.tagPaddingRight + 1
        
        if hashtag.isRemovable {
            calculatedWidth += self.removeButtonSize + self.removeButtonSpacing
        }
        
        if (calculatedWidth > collectionView.frame.width) {
            calculatedWidth = collectionView.frame.width
            calculatedHeight = self.tagPaddingTop + hashtag.text.getLabelHeight(font: self.tagFont, width: calculatedWidth) + self.tagPaddingBottom
        }
        
        return CGSize(width: calculatedWidth, height: calculatedHeight)
    }
}
