//
//  RecipeCelllTableViewCell.swift
//  Reciplease
//
//  Created by Maxime on 08/01/2021.
//  Copyright © 2021 Maxime. All rights reserved.
//

import UIKit

class RecipeCelllTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configure(dataRecipe: Recipe) {
        
        let title = dataRecipe.label
        
        let ingredients = dataRecipe.ingredients[0].text
        
        let recipeImage = dataRecipe.image
        // let like ?
        
        let time =
            dataRecipe.totalTime ?? 0
        
        titleLabel.text = title 
        ingredientsLabel.text = ingredients
        recipeImageView.image = UIImage(named:recipeImage)
        timeLabel.text = String(time)
    }
    
    
}
