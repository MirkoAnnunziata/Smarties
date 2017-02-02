//
//  CalloutView.swift
//  SPark
//
//  Created by Mirko Annunziata on 02/02/2017.
//  Copyright © 2017 Giovanni Iannace. All rights reserved.
//

import UIKit
import SKMaps

class CalloutView: UIView {
    
    var availableLabel:UILabel!
    var priceLabel:UILabel!
    var navigationButton:UIButton!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.availableLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.navigationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.navigationButton.backgroundColor = UIColor.gray
        self.addSubview(self.availableLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.navigationButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate(annotation:SKAnnotation){
        UIView.animate(withDuration: 1, animations: {
            self.layer.position.x = -50
            self.frame = CGRect(x: 0, y: 0, width: 100, height: 75)
            let backgroundImage = UIImage(named: "calloutBorders")!
            self.backgroundColor = UIColor(patternImage: backgroundImage).withAlphaComponent(0.7)
            self.availableLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height/2)
            self.priceLabel.frame = CGRect(x: 0, y: self.frame.size.height/2, width: self.frame.size.width, height: self.frame.size.height/2)
            self.navigationButton.frame = CGRect(x: self.frame.size.width-40, y: self.frame.size.height-40, width: 40, height: 40)
            
            self.availableLabel.text = "Available: 50/70"
            self.priceLabel.text = "0,50€/hour"
        })
    }

}
