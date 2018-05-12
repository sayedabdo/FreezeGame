//
//  ViewController.swift
//  Freeze Game
//
//  Created by Yasmine Ghazy on 5/1/18.
//  Copyright © 2018 Yasmine Ghazy. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    
    var level : Int = 0
    var moves : Int = 50
    override func viewDidLoad() {
        super.viewDidLoad()
        print(level)
        print("///////")
        print(moves)
        
    }

    @IBAction func playAction(_ sender: Any) {
        
        performSegue(withIdentifier: "toGame", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toGame"{            
            let vc = segue.destination as! GameVC
            vc.level = level
            vc.moves = moves
        }
        
    }



    @IBAction func quitGame(_ sender: Any) {
        exit(0);
    }

}

