//
//  ViewController.swift
//  Reciplease
//
//  Created by Maxime on 28/12/2020.
//  Copyright © 2020 Maxime. All rights reserved.
//
import CoreData
import UIKit

class SearchViewController: UIViewController,UITextFieldDelegate {
    
    //MARK:- VARIABLE 📦
    
    //Outlet
    
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var appNameLabel: UILabel!
    
    @IBOutlet weak var addIngredientsButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var SearchButton: UIButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    //--
    
    var coreDataManager: CoreDataManager?
    
    
    //MARK:- VIEW-CYCLE ♻️
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadiusEffect()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        coreDataManager = CoreDataManager(coreDataStack: appDelegate.coreDataStack)
        
        ingredientsTableView.reloadData()
        
    }
    
    @IBAction func tappedDeleteButton(_ sender: Any) {
        coreDataManager?.deleteAllTasks()
        ingredientsTableView.reloadData()
    }
    
    
    @IBAction func addIngredientsAction(_ sender: Any) {
        addIngredientInTableView()
        
    }
    
    //MARK:-CONDITION ☝🏻
    
    
    func addIngredientInTableView() {
        
        let ingredients = ingredientsTextField.text ?? ""
        
        if ingredients != "" {
            coreDataManager?.createIngredients(ingredient: ingredients)
            ingredientsTableView.reloadData()
            ingredientsTextField.text = ""
        }
        
        
    }
    
    //MARK:- KEYBOARD GESTION ⌨️
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        ingredientsTextField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientsTextField.resignFirstResponder()
        return true
    }
    
    
    //MARK:- ANIMATE ⚡️
    
    func cornerRadiusEffect(){
        let cornerRadiusInt = 7
        
        appNameLabel.layer.cornerRadius = CGFloat(cornerRadiusInt)
        appNameLabel.layer.masksToBounds = true
        
        addIngredientsButton.layer.cornerRadius = CGFloat(cornerRadiusInt)
        appNameLabel.layer.masksToBounds = true
        
        clearButton.layer.cornerRadius = CGFloat(cornerRadiusInt)
        clearButton.layer.masksToBounds = true
        
        SearchButton.layer.cornerRadius = CGFloat(cornerRadiusInt)
        SearchButton.layer.masksToBounds = true
        
        ingredientsTableView.layer.cornerRadius = CGFloat(cornerRadiusInt)
        ingredientsTableView.layer.masksToBounds = true
    }
    
}


//MARK:- EXTENSION ↔️

extension SearchViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager?.person.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let taskCell =
            tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)
        
        taskCell.textLabel?.text = coreDataManager?.person[indexPath.row].ingredients
        
        return taskCell
    }
}


extension SearchViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            coreDataManager?.deleteTasks(indexPath: indexPath)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
