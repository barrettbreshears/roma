//
//  Card.swift
//  MastodonKit
//
//  Created by Ornithologist Coder on 4/9/17.
//  Copyright © 2017 MastodonKit. All rights reserved.
//

import Foundation

public class Card: Codable {
    /// The url associated with the card.
    public let url: URL
    /// The title of the card.
    public let title: String
    /// The card description.
    public let description: String
    /// The image associated with the card, if any.
    public let image: URL?
    /// The type of card.
    public let type: CardType
    /// The author's name.
    public let authorName: String?
    /// The author's url.
    public let authorUrl: String?
    /// The provider's name.
    public let providerName: String?
    /// The provider's url.
    public let providerUrl: String?
    /// The card HTML.
    public let html: String?
    /// The card's width.
    public let width: Int?
    /// The card's height.
    public let height: Int?
    
    private enum CodingKeys: String, CodingKey {
        case url
        case title
        case description
        case image
        case type
        case authorName = "author_name"
        case authorUrl = "author_url"
        case providerName = "provider_name"
        case providerUrl = "provider_url"
        case html
        case width
        case height
    }
}
