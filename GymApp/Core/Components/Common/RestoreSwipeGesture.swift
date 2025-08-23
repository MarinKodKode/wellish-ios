//
//  RestoreSwipeGesture.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation
import SwiftUI
import UIKit

struct RestoreSwipeGesture: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            if let navigationController = uiViewController.navigationController {
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
                navigationController.interactivePopGestureRecognizer?.delegate = nil
            }
        }
    }
}
