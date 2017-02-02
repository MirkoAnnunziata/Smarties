//
//  TopInfoView.swift
//  SPark
//
//  Created by Mirko Annunziata on 02/02/2017.
//  Copyright © 2017 Giovanni Iannace. All rights reserved.
//

import UIKit

class TopInfoView: UIView {
    
    var distance:UILabel!
    var currentStreetName:UILabel!
    var nextStreetName:UILabel!
    
    override init(frame: CGRect) {
        // Drawing code
        super.init(frame: frame)
        let viewWidth = frame.width
        let viewHeight = frame.height
        self.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        self.distance = UILabel(frame: CGRect(x: 0, y: viewHeight*0.75, width: viewWidth*0.25, height: viewHeight*0*25))
        self.currentStreetName = UILabel(frame: CGRect(x: viewWidth/4, y: 0, width: viewWidth*0.75, height: viewHeight/2))
        self.nextStreetName = UILabel(frame: CGRect(x: viewWidth/4, y: viewHeight/2, width: viewWidth*0.75, height: viewHeight/2))
        self.addSubview(distance)
        self.addSubview(currentStreetName)
        self.addSubview(nextStreetName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//
//    }


}
