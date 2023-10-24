//
//  MovieListTableView.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 19/10/23.
//

import UIKit
import SnapKit
import SDWebImage

public class CustomCollectionViewCell: UICollectionViewCell {
    
    public static var reusableIdentifier = "CustomCollectionViewCellIdentifier"
    
    var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()

    static var id: String {
        get {
            return String.init(describing: self)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    private func setupSubviews() {
        addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }

    
    public func configure(with imageURL: URL?, title: String) {

        if let imageURL = imageURL {
            imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholderImage"))
        } else {
            // Handle the case when imageURL is nil or loading fails
            imageView.image = UIImage(named: "placeholderImage")
        }
    }

}

