//
//  ViewController.swift
//  Reciplease
//
//  Created by Maxime on 28/12/2020.
//  Copyright © 2020 Maxime. All rights reserved.
//
import UIKit

class SearchViewController: UIViewController,UITextFieldDelegate {
    
    
    
    //MARK:- OutLet 🔗
    
    @IBOutlet weak var ingredientsTextField: UITextField!
    
    @IBOutlet weak var appNameLabel: UILabel!
    
    @IBOutlet weak var addIngredientsButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var SearchButton: UIButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    //MARK:- Propreties 📦
    
    var coreDataManager: CoreDataManager?
    
    private let service: RequestService = RequestService()
    
    var dataRecipe : RecipeSearchDataStruct?
    
    //— 💡 Food Array for passing strings in request
    var serviceIngredientsFridge : ServiceIngredientsFridge?
    
    
    //MARK:- View Cycle ♻️
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        
        cornerRadiusEffect()
        
        //— ❗ Allows to update ingredients
        
        serviceIngredientsFridge = ServiceIngredientsFridge()
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        coreDataManager = CoreDataManager(coreDataStack: appDelegate.coreDataStack)
        
        //X
        
        ingredientsTableView.reloadData()
        
    }
    
    //MARK:- Button Action 🔴
    
    @IBAction func addIngredientsAction(_ sender: Any) {
        addIngredientInTableViewIfValidCharacters()
    }
    
    @IBAction func tappedDeleteButton(_ sender: Any) {
        //coreDataManager?.deleteAllIgredient()
       // serviceIngredientsFridge.ingredientsFridge.removeAll()
        ingredientsTableView.reloadData()
    }
    
    
    @IBAction func tappedSearchButton(_ sender: Any) {
        
        //— 💡 We join all the strings (ingredients) in the table
        
        let foodJoined = serviceIngredientsFridge?.ingredientsFridge.joined(separator: ",") ?? "no food data"
        
        //X
        
        self.service.getData(food: foodJoined) { result in
            
            
            switch result {
            case .success(let data):
                
                if self.serviceIngredientsFridge?.ingredientsFridge.count ?? 0 > 0 {
                    self.dataRecipe = data
                    self.performSegue(withIdentifier: "searchSegue", sender: (Any).self)
                } else {
                    self.displayNeedIngredientsAlert()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //— 💡 Data segue passing
    //- Self -> ResultSearchViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesVC = segue.destination as? ResultSearchViewController, let dataRecipe = dataRecipe {
            recipesVC.dataRecipe = dataRecipe
        }
    }
    
    
    //MARK:- Conditions☝🏻
    
    func addIngredientInTableViewIfValidCharacters() {
        
        let ingredients = ingredientsTextField.text ?? ""
        if ingredients != "" {
            if ingredients.containsValidCharacter == true {
                //coreDataManager?.createIngredients(ingredient: ingredients)
                
                serviceIngredientsFridge?.addIngredients(ingredients: ingredients)
        
                ingredientsTableView.reloadData()
                ingredientsTextField.text = ""
            }
        }
    }
    
    func displayNeedIngredientsAlert() {
        let alertController = UIAlertController(title: "Add ingredients to find recipes", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Ok", style: .default)
        
        
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:- KeyBoard Gestion ⌨️
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        ingredientsTextField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientsTextField.resignFirstResponder()
        return true
    }
    
    
    //MARK:- Animate ⚡️
    
    func cornerRadiusEffect(){
        let cornerRadiusInt = 7
        
        addIngredientsButton.layer.cornerRadius = CGFloat(cornerRadiusInt)
        
        clearButton.layer.cornerRadius = CGFloat(cornerRadiusInt)
        clearButton.layer.masksToBounds = true
        
        SearchButton.layer.cornerRadius = CGFloat(cornerRadiusInt)
        SearchButton.layer.masksToBounds = true
        
        ingredientsTableView.layer.cornerRadius = CGFloat(cornerRadiusInt)
        ingredientsTableView.layer.masksToBounds = true
        
    }
}


//MARK:- Extension ↔️

extension SearchViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  serviceIngredientsFridge?.ingredientsFridge.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let taskCell =
            tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)
        
        taskCell.textLabel?.text = serviceIngredientsFridge!.ingredientsFridge[indexPath.row]
        
        return taskCell
    }
    
    //— 💡 Stylish animation to the cell display.
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let translationMovement = CATransform3DTranslate(CATransform3DIdentity, 0, 20, 0)
        cell.layer.transform = translationMovement
        cell.alpha = 0
        UIView.animate(withDuration: 0.20) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
        
        cell.selectionStyle = .none
    }
}


//— 💡 Add a text center in tableView if is nil.

extension SearchViewController {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Add some ingredients in the list"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  serviceIngredientsFridge?.ingredientsFridge.isEmpty ?? true ? 230 : 0
    }
}


extension SearchViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            //ingredientsData?.ingredients(indexPath: indexPath)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
        }
    }
}

extension String {
    
    var containsValidCharacter: Bool {
        guard self != "" else { return true }
        let hexSet = CharacterSet(charactersIn: "abdcdefghijklmnopqrstuvwxyz")
        let newSet = CharacterSet(charactersIn: self)
        return hexSet.isSuperset(of: newSet)
    }
}


