//
//  ProductsViewController.swift
//  IosDevTestSwift
//
//  Created by Olha Danylova on 29.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

import UIKit

class ProductsViewController: UITableViewController {
    
    let APP_ID = "7272A465-A10C-B8FC-FFFC-EC6FAB58BA00"
    let SECRET_KEY = "5FED2132-3B26-38D4-FF91-8B08B265B600"
    let VERSION_NUM = "v1"
    
    let PAGESIZE = 10;
    let backendless = Backendless.sharedInstance()!
    let query = BackendlessDataQuery()
    
    var offset = 0
    var loadedProducts: NSMutableArray!
    var totalDataCount: CLong!
    
    var detailViewController: ProductDetailsViewController? = nil
    @IBOutlet var buttonLoadMore: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Backendless application initialization.
        backendless.initApp(APP_ID, secret: SECRET_KEY, version: VERSION_NUM)
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ProductDetailsViewController
        }
        
        loadedProducts = NSMutableArray();
        totalDataCount = backendless.persistenceService.of(Product.ofClass()).find().data.count
        self.getFirstPageAsync()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Paging
    
    func getFirstPageAsync() {
        query.queryOptions.pageSize = PAGESIZE as NSNumber!
        backendless.persistenceService.of(Product.ofClass()).find(
            query,
            response: { (products: BackendlessCollection?) -> (Void) in
                self.getPageAsync(products: products!)
        },
            error: { (fault: Fault?) -> () in
                print("Server reported an error: \(fault)")
        }
        )
    }
    
    
    func getNextPageAsync() {
        self.offset += PAGESIZE
        
        backendless.persistenceService.of(Product.ofClass()).find(query).getPage(
            self.offset,
            pageSize: Int(PAGESIZE),
            response: { (products: BackendlessCollection?) -> (Void) in
                self.getPageAsync(products: products!)
        },
            error: { (fault: Fault?) -> (Void) in
                print("Server reported an error: \(fault)")
        }
        )
    }
    
    
    func getPageAsync(products: BackendlessCollection) {
        //print("Loaded \(products.data.count) products in the current page")
        
        for product in products.getCurrentPage() {
            loadedProducts.add(product);
        }
        
        self.loadImagesAsync()
        self.tableView.reloadSections([0], with: .fade)
        
        // Scroll to the last cell.
        if (loadedProducts.count > 0) {
            let indexPath = IndexPath(row: loadedProducts.count - 1, section: (0))
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
        // Make "Load More" buton disabled if all data is loaded.
        if (loadedProducts.count == totalDataCount) {
            self.buttonLoadMore.isEnabled = false
            self.buttonLoadMore.title = "All data loaded";
        }
        else {
            self.buttonLoadMore.isEnabled = true;
            self.buttonLoadMore.title = "Load More";
        }
    }
    
    
    func loadImagesAsync() {
        for i in 0 ..< loadedProducts.count {
            let product = loadedProducts[i] as! Product
            if (product.image == nil && product.imageURL != nil) {
                
                
                let url = URL(string: product.imageURL!)
                
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        product.image = UIImage(data: data!)
                        
                        // Reload product cell to show image.
                        let indexPath = IndexPath(row: i, section: (0))
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
                
            }
            
        }
    }
    
    
    // MARK: - Table view data sourcee
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedProducts.count
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: CustomCell! = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? CustomCell
        
        let product = loadedProducts[indexPath.row] as! Product
        
        // If product image hasn't been loaded yet it's image sets to "noimage.png".
        if (product.image == nil) {
            cell.imgView.image = UIImage(named:"noimage.png")
        }
            // If product image has already been loaded.
        else {
            cell.imgView.image = product.image
        }
        
        cell.productNameLabel.text = product.productName
        cell.productDescriptionLabel.text = product.productDescription
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Buttons Actions
    
    @IBAction func pressedLoadMore(_ sender: UIBarButtonItem) {
        self.getNextPageAsync()
    }
}
