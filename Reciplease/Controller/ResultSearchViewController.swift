//
//  ResultSearchControllerViewController.swift
//  Reciplease
//
//  Created by Maxime on 08/01/2021.
//  Copyright © 2021 Maxime. All rights reserved.
//

import UIKit

class ResultSearchViewController: UIViewController{
    
    //MARK:- OutLet 🔗
    
    @IBOutlet weak var tableViewSearchResult: UITableView!
    
    //MARK:- Propreties 📦
    
    var dataRecipe : RecipeSearchDataStruct?
    
    //— 💡 *DataSegues
    
    var dataRecipeIndexPath : Recipe?
    
    //X
    
    var coreDataManager : CoreDataManager?
    
    //MARK:- View Cycle ♻️
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //— 💡 Back button navigation bar gestion
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        
        //— ❗ Allows to update CoreData
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        coreDataManager = CoreDataManager(coreDataStack: appDelegate.coreDataStack)
        
        //X
        
        setupCustomCell()
        setTableViewDataSourceAndDelegate()
        
        tableViewSearchResult.reloadData()
    }
    
    //MARK:- Override 🧗
    
    //— 💡 *DataSegues : Passing of data between segues.
    // self -> RecipeDetailsViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesVC = segue.destination as? RecipeDetailsViewController {
            recipesVC.dataRecipeIndexPath = dataRecipeIndexPath
        }
    }
}

//MARK:- Extension ↔️

extension ResultSearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //— 💡 The tableView returns the results of the Recipe API, the data is contained in "Hit". (Look "RecipeSearchDataStruct")
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataRecipe!.hits.count
    }
    
    //X
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //— 💡 with the identifier, we retrieve the data contained in the Xib "RecipeCellTableViewCell" to access the "Configure" function and then we go to parameterize the API data with the index of the selected cell.
        
        let recipeCell =
            tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)  as? RecipeCelllTableViewCell
        
        let dataIndexPath = dataRecipe?.hits[indexPath.row].recipe
        
        recipeCell?.configure(dataRecipe: dataIndexPath!)
        
        return recipeCell!
        
        //X
        
    }
    
    //— 💡 Allows you to assign the custom cell (XIB) to the desired tableView.
    
    private func setupCustomCell() {
        let nib = UINib(nibName: "RecipeCelllTableViewCell", bundle: nil)
        tableViewSearchResult.register(nib, forCellReuseIdentifier: "tableViewCell")
    }
    
    private func setTableViewDataSourceAndDelegate() {
        tableViewSearchResult.dataSource = self
        tableViewSearchResult.delegate = self
    }
    
    //X
}

//MARK:- TableView Delegate

extension ResultSearchViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //— 💡 Variable to pass the index to the "RecipeDetailsViewController" controller to remove "FavoriteRecipe" data from CoreData.
        
        let dataIndexPath = dataRecipe?.hits[indexPath.row].recipe
        dataRecipeIndexPath = dataIndexPath
        
        //X
        
        self.performSegue(withIdentifier: "recipeResultCellToDetails", sender: (Any).self)
    }
    
    
    //MARK:- TableView Cell
    
    //— 💡 Stylish animation to the cell display.
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let translationMovement = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = translationMovement
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
        
        cell.selectionStyle = .none
    }
    
    //— 💡 Specifies the height of the cell images
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 2
    }
    
    //X
}
