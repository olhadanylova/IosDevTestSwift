//
//  ProductDetailsViewController.swift
//  IosDevTestSwift
//
//  Created by Olha Danylova on 29.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let product = self.product {
            if let label = self.detailDescriptionLabel {
                label.text = product.description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var product: Product? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
}
