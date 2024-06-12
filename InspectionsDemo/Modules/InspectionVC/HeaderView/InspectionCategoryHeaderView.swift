//
//  InspectionCategoryHeaderView.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import UIKit

class InspectionCategoryHeaderView: UITableViewHeaderFooterView {
    let lblCategoryName = UILabel()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureContents() {
        
        lblCategoryName.translatesAutoresizingMaskIntoConstraints = false
        
        lblCategoryName.font = UIFont.boldSystemFont(ofSize: 24)
        
        lblCategoryName.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(lblCategoryName)
        
        contentView.addDashedBorder(strokeColor: .gray, lineWidth: 1)
        
        NSLayoutConstraint.activate([
            lblCategoryName.topAnchor.constraint(equalTo: contentView.topAnchor),
            lblCategoryName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lblCategoryName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20),
            lblCategoryName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -20)
        ])
        
        
    }
}
