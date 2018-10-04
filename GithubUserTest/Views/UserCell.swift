//
//  UserCell.swift
//  GithubUserTest
//
//  Created by Chris Ferdian on 04/10/18.
//  Copyright © 2018 Chris Ferdian. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {

    @IBOutlet weak var labelUsername:UILabel!
    @IBOutlet weak var imageV:UIImageView!
    
    func bind(user:User) {
        
        imageV.layer.borderWidth = 1.0
        imageV.layer.masksToBounds = false
        imageV.layer.borderColor = UIColor.white.cgColor
        imageV.layer.cornerRadius = imageV.frame.size.width / 2
        imageV.clipsToBounds = true
        
        labelUsername.text = user.login
        imageV.sd_setImage(with: URL(string: user.avatar_url!), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
