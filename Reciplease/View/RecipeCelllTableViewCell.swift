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
    
    @IBOutlet weak var calorieLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configure(dataRecipe: Recipe) {
        
        let title = dataRecipe.label
        
        let ingredients = dataRecipe.ingredients[0].text
        
        let recipeImage = dataRecipe.image
        
        
        let calorie = dataRecipe.calories
        let formated = String(format: "%.1f k", calorie)
        calorieLabel.text = formated
        
        
        let time = dataRecipe.totalTime ?? 0
        
        titleLabel.text = title 
        ingredientsLabel.text = ingredients
        
        timeLabel.text = String(time) + "m"
        recipeImageView.load(url: URL(string:recipeImage!)!)
    }
    
    func configureCoreData(coreDataRecipe: FavoriteRecipe) {
        
        titleLabel.text = coreDataRecipe.label
        timeLabel.text = coreDataRecipe.totalTime
        ingredientsLabel.text = coreDataRecipe.ingredients
        calorieLabel.text = coreDataRecipe.calories
    }
    
    
    
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
