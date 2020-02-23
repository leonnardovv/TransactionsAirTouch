//
//  TransactionDetailsVC.swift
//  AirTouch Exercise
//
//  Created by Leonard on 2/23/20.
//  Copyright © 2020 Leonard. All rights reserved.
//

import UIKit

class TransactionDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var transactions_table_view: UITableView!
    @IBOutlet weak var product_title: UILabel!
    @IBOutlet weak var currency_picker: UIPickerView!
    @IBOutlet weak var number_of_transactions: UILabel!
    @IBOutlet weak var total_sum_amount: UILabel!
    
    var product_name = String()
    var transactions = [Transaction]()
    var rates = [Rate]()
    var picker_currencies = [String]()
    var currency_selected = String()
    var currency_changed = Bool()
    var final_amount = String()
    
    let adjacencyList = AdjacencyList<String>()

    var a =  Vertex<String>(data: "")
    var b = Vertex<String>(data: "")
    var list_from = String()
    var list_to = String()
    var list = String()
    var total_sum_eur = Float()

    var list_of_vertexes = [Vertex<String>]()

    override func viewDidLoad() {
        super.viewDidLoad()
                
            getRates {
                self.currency_picker.reloadAllComponents()
                self.transactions_table_view.reloadData()
                self.createAdjacencyList()
                self.calculateSumEUR()
                self.number_of_transactions.text = String(self.transactions.count)
            }
              
            product_title.text = product_name
            
            for transaction in transactions{
                print("TRANSACTION: \(transaction)")

            }
        
        
        
        }
            
            func convert(amount: String, rate: Rate) -> Float{
                let a = (amount as NSString).floatValue
                let rate_obj = rate
                
                
                return a / (rate_obj.rate as NSString).floatValue
            }
            
            func getRates(completed: @escaping () -> ()){
                   let url = URL(string: "http://gnb.dev.airtouchmedia.com/rates.json" )!
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
                               self.rates = try JSONDecoder().decode([Rate].self, from: data)
                                self.picker_currencies.append("DEFAULT")
                                print("RATES NOW")
                                print(self.rates)
                                for rate in self.rates{
                                    if !self.picker_currencies.contains(rate.from){
                                        self.picker_currencies.append(rate.from)
                                    }
                                    if !self.picker_currencies.contains(rate.to){
                                        self.picker_currencies.append(rate.to)
                                    }
                                }
                                
                                print("CURERNCIES IN PICKER ----------")
                                print(self.picker_currencies)
                                
                                print("CURRENCIES: \(self.picker_currencies)")
                                
                            
                            
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
    
    func createAdjacencyList() {

        for r in rates{

            a = adjacencyList.createVertex(data: r.from)
            b = adjacencyList.createVertex(data: r.to)
            adjacencyList.add(.directed, from: a, to: b, weight: (r.rate as NSString).floatValue)
            list_of_vertexes.append(a)
            list_of_vertexes.append(b)
            list.append(r.from)
            list.append(r.to)

        }

        print(list)
        print("------------")
        print(list_to)
        print("LIST OF VERTEX: \(list_of_vertexes)")

        //adjacencyList.description
    
    }

    func depthFirstSearch(amount: inout String, from start: Vertex<String>, to end: Vertex<String>, graph: AdjacencyList<String>) -> Stack<Vertex<String>>{
        var visited = Set<Vertex<String>>() // here we keep all the vertices that have been visited
        var stack = Stack<Vertex<String>>() // here we store potential paths from the start to end vertex
            
        stack.push(start)
        visited.insert(start)
            
        outer: while let vertex = stack.peek(), vertex != end { // while the stack is not empty, the full path has not been found

            guard let neighbors = graph.edges(from: vertex), neighbors.count > 0 else { // check if the current vertex has any neighbors and if there are none it means we reached a dead                                                                           end and we backtrack by popping the current vertex of the stack
                print("backtrack from \(vertex)")
                stack.pop()
                continue
            }
              
            for edge in neighbors { // if the vertex has any edges, we will loop through each edge
                if !visited.contains(edge.destination) {  // as long as the neighbour vertex has not been visited
                    print(edge.weight)
                    print("Calculating: \((amount as NSString).floatValue) / \(edge.weight!)")
                    amount = String((amount as NSString).floatValue / edge.weight!)
                    
                    visited.insert(edge.destination)  // mark the vertex as visited
                    stack.push(edge.destination)     // push the vertex on the stack, meaning that this vertex is a potential candidat for the final stack
                    print(stack.description)         // printing the current path
                    print("Amount now: \(amount)")

                    final_amount = amount
                    
                    continue outer   //
                }
            }
              
            print("backtrack from \(vertex)") //
            stack.pop()
        }
            
            return stack  // this will contain the path
    }
    
        
    func calculateSumEUR(){
        for t in transactions{
            if t.default_currency != "EUR"{
                var amount_to_eur = t.amount
                var stack_result = depthFirstSearch(amount: &amount_to_eur, from: list_of_vertexes.first(where: {$0.description == t.default_currency})!, to: list_of_vertexes.first(where: {$0.description == "EUR"})!, graph: adjacencyList)
                total_sum_eur += (amount_to_eur as NSString).floatValue
                print("eur amount: \(self.total_sum_eur)")
                
                let rounded = round(self.total_sum_eur * 100) / 100
                self.total_sum_amount.text = String(rounded)
            }
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
               
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = transactions_table_view.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let transaction_default_currency = transactions[indexPath.row].default_currency
        let transaction_default_amount = transactions[indexPath.row].amount
        
        cell.textLabel?.text = "Currency: \(transaction_default_currency) and amount: \(transaction_default_amount)"
        
        if currency_changed{
            if currency_selected != "DEFAULT"{
                if transaction_default_currency == currency_selected{
                    cell.textLabel?.text = "Currency: \(transaction_default_currency) and amount: \(transaction_default_amount)"
                }else{
                    for rate_elem in rates{
                        if rate_elem.to == currency_selected{
                            let r = Rate(from: transaction_default_currency, to: rate_elem.to , rate: rate_elem.rate)
                            let converted = convert(amount: transaction_default_amount, rate: r)

//                            cell.textLabel?.text = "Currency: \(currency_selected) and amount: \(converted)"
                            
                            let rounded_amount_calculated =  round(converted * 100) / 100
                            cell.textLabel?.text =  "Currency: \(currency_selected) and amount:  \(rounded_amount_calculated)"

                        } else {
                            
                            var amount_calculated = transaction_default_amount
                            let stack_result = depthFirstSearch(amount: &amount_calculated, from: list_of_vertexes.first(where: {$0.description == transaction_default_currency})!, to: list_of_vertexes.first(where: {$0.description == currency_selected})!, graph: adjacencyList)
                            
                            let rounded_amount_calculated =  round((amount_calculated as NSString).floatValue * 100) / 100
                            cell.textLabel?.text =  "Currency: \(currency_selected) and amount:  \(rounded_amount_calculated)"
                            
                        }
                    }
                }
            }else{
                cell.textLabel?.text = "Currency: \(transaction_default_currency) and amount: \(transaction_default_amount)"
            }
        }

               return cell
    }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return picker_currencies.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return picker_currencies[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.currency_changed = true
            self.currency_selected = self.picker_currencies[row]

            self.transactions_table_view.reloadData()
        }


}
