//
//  Datasource.swift
//  WhatsNewKitWithRealm
//
//  Created by Josh R on 10/12/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation
import WhatsNewKit

struct WhatsNewData {
    let title: String
    let assetImgName: String
    let description: String
    let versionNumber: String
}

struct WhatsNewFeatures {
    static var newestVersion: String {
        return allVersions.last ?? "1.3"
    }
    
    static var retrieveUserVersion: String {
        let realm = MyRealm.getConfig()
        return realm?.objects(UserSettings.self).first?.userOnVersion ?? "1.3"
    }
    
    static let allVersions = ["1.4", "1.5"]
    
    static let allFeatures = [
        //1.4
        distanceFromLocation,
        iconsSearch,
        seeParentAmount,
        
        //1.5
        csvExporter,
        defaultAccount,
        historicalBudgets,
        hapticFeedback,
    ]
    
    //MARK: 1.4 Features
    static let distanceFromLocation = WhatsNewData(title: "Location Distance", assetImgName: "location", description: "See how far away a search location is to your current location.", versionNumber: "1.4")
    static let iconsSearch = WhatsNewData(title: "Search Category Icons", assetImgName: "account", description: "Quickly search for category icons using key words.", versionNumber: "1.4")
    static let seeParentAmount = WhatsNewData(title: "View Parent Category Amount", assetImgName: "category", description: "Now see statistics about parent categories.", versionNumber: "1.4")
    
    //MARK: 1.5 Features
    static let csvExporter = WhatsNewData(title: "CSV Exporter", assetImgName: "apple watch smart device wearable", description: "Export all you transactions to a csv file for further analysis.", versionNumber: "1.5")
    static let defaultAccount = WhatsNewData(title: "Set Default Account", assetImgName: "account", description: "Set a default account for new transactions.", versionNumber: "1.5")
    static let historicalBudgets = WhatsNewData(title: "See Historical Budgets", assetImgName: "budget", description: "View all the past budgets of a specific budget.", versionNumber: "1.5")
    static let hapticFeedback = WhatsNewData(title: "Haptic Feedback", assetImgName: "finger", description: "Haptic feedback when entering a transaction amount, marking a transaction as cleared, and more.", versionNumber: "1.5")
    
    
    //Retrieve features by version #
    static func retrieveFeatures(for version: String) -> [WhatsNewData] {
        return allFeatures.filter({ $0.versionNumber == version })
    }
    
    //Used to retrieve all versions greater than the user's current version
    static func retrieveVersions(startingAt version: String) -> [String] {
        return allVersions.filter({ $0 > version })
    }
}

//MARK: What's New VC Setup
struct WhatsNewManager {
    
    //Creates the first WhatsNewVC with a navigation controller
    static func createInitialWhatsNewVC(in vc: UIViewController, whatsNewVC: WhatsNewViewController) {
        let navigationVC = UINavigationController(rootViewController: whatsNewVC)
        navigationVC.navigationBar.backgroundColor = .white
        navigationVC.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationVC.navigationBar.shadowImage = UIImage()
        navigationVC.navigationBar.layoutIfNeeded()
        vc.present(navigationVC, animated: true)
    }
    
    //Called Recursively
    static func createWhatsNewVC() -> WhatsNewViewController {
        let realm = MyRealm.getConfig()
        let userVersionNumber = WhatsNewFeatures.retrieveUserVersion
        
        let featuresToDisplayVersion = WhatsNewFeatures.retrieveVersions(startingAt: userVersionNumber)
        let features = WhatsNewFeatures.retrieveFeatures(for: featuresToDisplayVersion.first ?? "1.3")
        
        var newItems = [WhatsNewKit.WhatsNew.Item]()
        
        //MARK: add new features to WhatsNew.Item
        for feature in features {
            let whatsNewItem = WhatsNewKit.WhatsNew.Item(
                title: feature.title,
                subtitle: feature.description,
                image: UIImage(named: feature.assetImgName)?.withTintColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
            )
            
            newItems.append(whatsNewItem)
        }
        
        let newFeatureItem = WhatsNewKit.WhatsNew(title: "\(featuresToDisplayVersion.first ?? "1.3") New Features", items: newItems)
        
        //MARK: WhatsNew Config
        var configuration = WhatsNewViewController.Configuration()
        
        // Customize Configuration to your needs
        configuration.backgroundColor = .white
        configuration.titleView.titleColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        configuration.itemsView.titleFont = .systemFont(ofSize: 17, weight: .bold)
        configuration.itemsView.subtitleFont = .systemFont(ofSize: 16, weight: .regular)
        //        configuration.itemsView.contentMode = .center
        configuration.detailButton?.titleColor = .white
        configuration.completionButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        configuration.itemsView.animation = .slideRight
        configuration.itemsView.imageSize = .original
//        configuration.apply(theme: .darkGreen)
        
        let completionButton = WhatsNewViewController.CompletionButton(
            title: featuresToDisplayVersion.count > 1 ? "Next" : "OK",
            action: .custom(action: { whatsNewViewController in   //from doc: [weak self] whatsNewViewController
                //Use a navigation controller to present more than one page of new Features
                
                try! realm?.write {
                    let userSettings = realm?.objects(UserSettings.self).first!
                    userSettings?.userOnVersion = featuresToDisplayVersion[0]
                }
                
                if featuresToDisplayVersion.count > 1 {
                    //reg vc, no nav control, push onto
                    let nextWhatsNewVC = WhatsNewManager.createWhatsNewVC()
                    nextWhatsNewVC.push(on: whatsNewViewController.navigationController, animated: true)
                } else {
                    whatsNewViewController.dismiss(animated: true, completion: nil)
                }
            })
        )
        
        configuration.completionButton = completionButton
        
        let whatsNewViewController = WhatsNewViewController(
            whatsNew: newFeatureItem,
            configuration: configuration
        )
        
        return whatsNewViewController
        
    }
}

