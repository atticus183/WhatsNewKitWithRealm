//
//  ViewController.swift
//  WhatsNewKitWithRealm
//
//  Created by Josh R on 10/12/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

//Source: https://github.com/SvenTiigi/WhatsNewKit

import UIKit
import WhatsNewKit

class MainVC: UIViewController {
    
    let realm = MyRealm.getConfig()
    var userVersion = "1.3"
    
    @IBOutlet weak var startOverBtnOutlet: UIButton!
    @IBAction func startOverBtn(_ sender: UIButton) {
        try! realm?.write {
            if let userSetting = realm?.objects(UserSettings.self).first {
                userSetting.userOnVersion = "1.3"
            }
        }
        
         WhatsNewManager.launchWhatsNew(in: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let realm = realm {
            if realm.objects(UserSettings.self).count == 0 {
                try! realm.write {
                    let userSettings = UserSettings()
                    
                    realm.add(userSettings)
                }
            }
            //Retrieve on-disk realm url
            print(realm.configuration.fileURL)
        }
        
        startOverBtnOutlet.giveRoundCorners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        WhatsNewManager.launchWhatsNew(in: self)
    }

}


