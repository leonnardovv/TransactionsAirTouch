//
//  ProductsViewController.swift
//  AirTouch Exercise
//
//  Created by Leonard on 2/23/20.
//  Copyright © 2020 Leonard. All rights reserved.
//

import UIKit

class ProductsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var products_table_view: UITableView!
   
    var products = [String]()
    var transactions = [Transaction]()
    var filtered_transactions = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getTransactions(){
            self.products_table_view.reloadData()
        }
    }
    

    
    func getTransactions(completed: @escaping () -> ()){
           let url = URL(string: "http://gnb.dev.airtouchmedia.com/transactions.json" )!
           let session = URLSession.shared
           let task = session.dataTask(with: url) { (data, response, error) in
               guard error == nil else{
                   print("Error: \(String(describing: error))")
                   debugPrint()
                   return
               }
               guard let data = data else {
                   print("No data returned")
                   return
                   
               }
               if error == nil {
                   do {
                       self.transactions = try JSONDecoder().decode([Transaction].self, from: data)
                       
                       for transaction in self.transactions{
                           if !self.products.contains(transaction.product_name){
                               self.products.append(transaction.product_name)
                           }
                           
                           
                       }
                       DispatchQueue.main.async {
                           completed()
                       }
                   } catch {
                       print("JSON ERR")
                   }
               } else {
                   debugPrint(error!)
               }
               
           }
           task.resume()

    
       }
    
    func filterTransactions(product_name: String){  // filtering the transactions for each product
        for transaction in transactions{
            if product_name == transaction.product_name{
                filtered_transactions.append(transaction)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = products_table_view.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = products[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let transactionsController = storyboard.instantiateViewController(withIdentifier: "TransactionDetailsVC") as! TransactionDetailsVC
        
        
        transactionsController.product_name = products[indexPath.row] // sending the name (optional because it will be sent below with the entire array
        filtered_transactions.removeAll()
        filterTransactions(product_name: products[indexPath.row]) // filtering
        transactionsController.transactions = filtered_transactions //sending only the transactions for the selected product
        
        self.navigationController?.pushViewController(transactionsController, animated: true)

        
    }
   

}
