//
//  UIColor+Extension.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 22/08/25.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    
    // MARK: - Primary Colors
    static let primaryFitnessBlue = UIColor(named: "PrimaryBlue")!
    static let fitnessSuccess = UIColor(named: "SuccessGreen")!
    static let energyFitnessOrange = UIColor(named: "EnergyOrange")!
    static let errorFitnessRed = UIColor(named: "ErrorRed")!
    static let premiumFitnessPurple = UIColor(named: "PremiumPurple")!
    static let infoFitnessCyan = UIColor(named: "InfoCyan")!
    
    // MARK: - Text Colors
    static let fitnessTextPrimary = UIColor(named: "PrimaryText")!
    static let fitnessTextSecondary = UIColor(named: "SecondaryText")!
    
    // MARK: - Background Colors
    static let fitnessBackgroundPrimary = UIColor(named: "BackgroundPrimary")!
    static let fitnessBackgroundSecondary = UIColor(named: "BackgroundSecondary")!
    
    // MARK: - Semantic Colors
    static let fitnessProgress = UIColor.successGreen
    static let fitnessWarning = UIColor.energyOrange
    static let fitnessError = UIColor.errorRed
    static let fitnessPrimary = UIColor.primaryBlue
    static let fitnessInfo = UIColor.infoCyan
    static let fitnessPremium = UIColor.premiumPurple
}

extension Color {
    
    // MARK: - Primary Colors
    static let primaryFitnessBlue = Color("PrimaryBlue")
    static let fitnessSuccess = Color("SuccessGreen")
    static let energyFitnessOrange = Color("EnergyOrange")
    static let errorFitnessRed = Color("ErrorRed")
    static let premiumFitnessPurple = Color("PremiumPurple")
    static let infoFitnessCyan = Color("InfoCyan")
    
    // MARK: - Text Colors
    static let fitnessTextPrimary = Color("PrimaryText")
    static let fitnessTextSecondary = Color("SecondaryText")
    
    // MARK: - Background Colors
    static let fitnessBackgroundPrimary = Color("BackgroundPrimary")
    static let fitnessBackgroundSecondary = Color("BackgroundSecondary")
    
    // MARK: - Semantic Colors
    static let fitnessProgress = Color.successGreen
    static let fitnessWarning = Color.energyOrange
    static let fitnessError = Color.errorRed
    static let fitnessPrimary = Color.primaryBlue
    static let fitnessInfo = Color.infoCyan
    static let fitnessPremium = Color.premiumPurple
}
