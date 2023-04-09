//
//  GoalCell.swift
//  goalpost-app
//
//  Created by robot on 5/4/21.
//  Copyright © 2021 robot. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {
    
    
    @IBOutlet weak var goalDescriptionLbl: UILabel!;
    
    @IBOutlet weak var goalTypeLbl: UILabel!;
    @IBOutlet weak var goalProgressLbl: UILabel!;
    
    func configureCell(message: String) {
        //self.goalDescriptionLbl.text = goal.goalDescription;
        //self.goalTypeLbl.text = goal.goalType;
        //self.goalProgressLbl.text = String(describing: goal.goalProgress);
    }
    
}
