//
//  File.swift
//  
//
//  Created by Mazen Amr on 03/07/2026.
//

import Foundation
import SwiftUI
import Observation

public enum AuthRoute: Hashable {
    case login
    case register
    case forgotPassword
    case setPassword(email: String, displayName: String?)
}
