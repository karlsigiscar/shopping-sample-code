//
//  User.swift
//  ECommerceSampleApp
//
//  Created by Writer on 18/01/2026.
//

import Foundation

struct User: Identifiable, Sendable, Decodable {
    public var id: Int
    public var token: String
    public var isClubMember: Bool
}
