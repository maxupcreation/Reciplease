//
//  ResultSearchControllerViewController.swift
//  Reciplease
//
//  Created by Maxime on 08/01/2021.
//  Copyright © 2021 Maxime. All rights reserved.
//

import UIKit

class ResultSearchControllerViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var tableViewSearchResult: UITableView!
    
    var dataRecipe : RecipeSearchDataStruct!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomCell()
        setTableViewDataSourceAndDelegate()
        
        tableViewSearchResult.reloadData()
    }
}
extension ResultSearchControllerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let recipeCell =
            tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)  as? RecipeCelllTableViewCell
        DispatchQueue.main.async {
            guard let title = self.dataRecipe.hits.first?.recipe.label else { return}
            let ingredients = self.dataRecipe.hits.first?.recipe.ingredients[0].text ?? "noData"
            
            let recipeImage = self.dataRecipe?.hits.first?.recipe.image!
            // let like ?
            let time = self.dataRecipe.hits.first?.recipe.totalTime! ?? 0
            
            recipeCell?.configure(title:title,ingredients: ingredients , recipeImage: recipeImage!, time:time)
        }
        
        return recipeCell!
        
    }
    
    private func setupCustomCell() {
        let nib = UINib(nibName: "RecipeCelllTableViewCell", bundle: nil)
        tableViewSearchResult.register(nib, forCellReuseIdentifier: "tableViewCell")
    }
    
    private func setTableViewDataSourceAndDelegate() {
        tableViewSearchResult.dataSource = self
        tableViewSearchResult.delegate = self
    }
}
