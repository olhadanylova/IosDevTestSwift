//
//  ProductDetailsViewController.swift
//  IosDevTestSwift
//
//  Created by Olha Danylova on 29.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var productDescriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    var product: Product? {
        didSet {
            self.configureView()
        }
    }
    
    
    /**
     Configures product details view with product's data.
     */
    func configureView() {
        if let product = self.product {
            self.title = "\(product.productName!)\(" Details")"
            
            if let imgView = self.imgView {
                // If product image hasn't been loaded yet it's image sets to "noimage.png".
                if (product.image == nil) {
                    imgView.image = UIImage(named:"noimage.png")
                }
                    // If product image has already been loaded.
                else {
                    imgView.image = product.image
                }
            }
            
            if let productNameLabel = self.productNameLabel {
                productNameLabel.text = product.productName
            }
            
            if let priceLabel = self.priceLabel {
                priceLabel.text = String(format: "%.2f", product.price)
            }
            
            if let productDescriptionTextView = self.productDescriptionTextView {
                productDescriptionTextView.text = product.productDescription
            }
        }
    }
}
