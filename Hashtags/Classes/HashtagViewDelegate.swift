//
//  HashtagViewDelegate.swift
//  Hashtags
//
//  Created by Oscar Götting on 6/9/18.
//

import Foundation

@objc public protocol HashtagViewDelegate: class {
    func hashtagRemoved(hashtag: HashTag)
    @objc optional func hashtagViewTapped(hashtag: HashTag)
    func viewShouldResizeTo(size: CGSize)
}
