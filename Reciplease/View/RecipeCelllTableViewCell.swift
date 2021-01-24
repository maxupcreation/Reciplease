//
//  RecipeCelllTableViewCell.swift
//  Reciplease
//
//  Created by Maxime on 08/01/2021.
//  Copyright © 2021 Maxime. All rights reserved.
//

import UIKit
import SDWebImage

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
        
        
        //— 💡 Calorie Formated
        
        let calorie = dataRecipe.calories
        let formated = String(format: "%.1f cal", calorie)
        calorieLabel.text = formated
        
        //X
        
        let time = dataRecipe.totalTime ?? 0
        
        titleLabel.text = title
        
        ingredientsLabel.text = ingredients
        
        timeLabel.text = String(time) + " min"
        
        //— 💡 Load Image
        
        let recipeImage = dataRecipe.image!
        recipeImageView.sd_setImage(with: URL(string:recipeImage))
        //rajouter une image par défaut
        
        //X
    }
    
    func configureCoreData(coreDataRecipe: FavoriteRecipe) {
        
        titleLabel.text = coreDataRecipe.label
        timeLabel.text = coreDataRecipe.totalTime
        
        let ingredientsJoined = coreDataRecipe.ingredients?.joined(separator: "\n - ") ?? "no data ingredients"
        ingredientsLabel.text = "-" + " " + ingredientsJoined
        calorieLabel.text = coreDataRecipe.calories
        recipeImageView.image = UIImage(data: coreDataRecipe.image!)
        recipeImageView.contentMode = .scaleAspectFill
        
    }
    
    
    
    
}

////— 💡 extension for load image with Url
//
//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}
