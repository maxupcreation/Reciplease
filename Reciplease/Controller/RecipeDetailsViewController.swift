//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by Maxime on 12/01/2021.
//  Copyright © 2021 Maxime. All rights reserved.
//

import UIKit
import SDWebImage

class RecipeDetailsViewController: UIViewController {
    
    //MARK:- OutLet 🔗
    
    @IBOutlet weak var infosStackView: UIStackView!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var calorieLabel: UILabel!
    
    @IBOutlet weak var nameRecipeLabel: UILabel!
    
    @IBOutlet weak var ingredientsTextView: UITextView!
    
    @IBOutlet weak var favoriteItemButton: UIBarButtonItem!
    
    @IBOutlet weak var getDirectionButton: UIButton!
    
    //MARK:- Propreties 📦
    
    //— 💡 Passing of data between segues.
    // self <- ResultSearchController
    
    var dataRecipeIndexPath : Recipe?
    
    var favoriteCoreIndex : FavoriteRecipe?
    
    //— 💡 *UrlGetDirectionButton
    
    var urlRecipeString : String?
    
    //X
    
   private var calorieForCoreData: String?
    
    var nameCoreArray : [String]?
    
    //— 💡 Manage CoreData Entity
    
    var coreDataManager: CoreDataManager?
    
    
    
    //MARK:- View Cycle ♻️
    
    override func viewDidLoad() {
        
        
        infosStackView.layer.cornerRadius = CGFloat(7)
        infosStackView.layer.masksToBounds = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        
        //— ❗ Allows to update CoreData
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        coreDataManager = CoreDataManager(coreDataStack: appDelegate.coreDataStack)
        
        //X
        
        if coreDataManager?.isRecipeRegistered(name: favoriteCoreIndex?.label ?? "no data") == false {
            
            configureWithApi()
            
        } else {
            
            configureWithCoreData()
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if coreDataManager?.isRecipeRegistered(name: nameRecipeLabel.text!) == true {
            
            favoriteItemButton.image = UIImage(systemName: "star.fill")
        } else {  favoriteItemButton.image = UIImage(systemName: "star") }
        
        
    }
    
    //MARK:- Button Action 🔴
    
    @IBAction func tapedStarButton(_ sender: Any) {
        
        
        //— 💡 If the button is selected, change the image then create the favorite in the database.
        
        if coreDataManager?.isRecipeRegistered(name: nameRecipeLabel.text! ) == false {
            
            favoriteItemButton.image = UIImage(systemName: "star.fill")
            
            var ingredientsArrayEmpty : [String] = []
            
            for ingredientArray in dataRecipeIndexPath!.ingredients {
                ingredientsArrayEmpty.append(ingredientArray.text)
            }
            
            coreDataManager?.createFavorite (
                label: dataRecipeIndexPath!.label,
                calories: calorieLabel.text!,
                image: recipeImageView.image!,
                ingredients: ingredientsArrayEmpty,
                totalTime: String(dataRecipeIndexPath?.totalTime ?? 0) + " min",
                yield: "",
                url: urlRecipeString!)
            
        }
        
        //— 💡 else change the image and delete the favorite from the database.
        
        else {
            
            favoriteItemButton.image = UIImage(systemName: "star")
            coreDataManager?.ifRecipeRegisteredThenDeleteFavorite(name: nameRecipeLabel.text!)
            
        }
    }
    
    @IBAction func tappedGetDirectionsButton(_ sender: Any) {
        
        //— 💡 Open the recipe url in a browser. *UrlGetDirectionButton
        
        if let url = URL(string: urlRecipeString ?? "") {
            UIApplication.shared.open(url)
        } else { return }
    }
    
    //MARK:- Interface Gestion 📱
    
    
    
    func configureWithApi() {
        
        nameRecipeLabel.text = dataRecipeIndexPath?.label
        
        let recipeImage = dataRecipeIndexPath?.image ?? ""
        
        recipeImageView.sd_setImage(with: URL(string:recipeImage))
        
        timeLabel.text = String(dataRecipeIndexPath?.totalTime ?? 0) + " min"
        
        //— 💡
        
        var ingredientsArrayEmpty : [String] = []
        
        for ingredientArray in dataRecipeIndexPath!.ingredients {
            ingredientsArrayEmpty.append(ingredientArray.text)
        }
        
        let ingredientsArrayConvertedToString = ingredientsArrayEmpty.joined(separator: "\n - ")
        
        let ingredients = "-" + " " + ingredientsArrayConvertedToString
        
        ingredientsTextView.text = ingredients
        
        //— 💡 Converted the data "calories" with a number 1 after the decimal point for CoreData.
        
        let calorie = dataRecipeIndexPath!.calories
        let formated = String(format: "%.1f cal", calorie)
        calorieForCoreData = formated
        calorieLabel.text = formated
        
        //X
        
        recipeImageView.contentMode = .scaleAspectFill
        
        //— 💡 The url for passenger the data to the button "Get direction". *UrlGetDirectionButton
        
        urlRecipeString = dataRecipeIndexPath?.url
        
        //X
        
    }
    
    func configureWithCoreData() {
        
        nameRecipeLabel.text = favoriteCoreIndex?.label
        
         let imageViewFavoriteCore = UIImage(data: (favoriteCoreIndex?.image)!)
        recipeImageView.image = imageViewFavoriteCore
        //Mettre une image ?? par défaut.
        recipeImageView.contentMode = .scaleAspectFill
        
        let ingredientsJoinged = favoriteCoreIndex?.ingredients?.joined(separator: "\n - ") ?? "no Data Ingredients"
        
        ingredientsTextView.text = "-" + " " + ingredientsJoinged
        
        timeLabel.text = favoriteCoreIndex?.totalTime ?? "No time Data"
        

        calorieLabel.text = favoriteCoreIndex?.calories
        
    }
    
    //MARK:- Conditions☝🏻
    
}
