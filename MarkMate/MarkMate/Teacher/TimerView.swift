//
//  TimerView.swift
//  MarkMate
//
//  Created by Abdur Rafae on 01/12/2023.
//

import UIKit

class TimerView: UIView {

}

extension TimerView {
    func addDashedCircle() {

        let circleLayer = CAShapeLayer()
        
        

        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2),
                                    radius: min(frame.size.height,frame.size.width)/2,
                                    startAngle: 0,
                                    endAngle: .pi * 2,
                                    clockwise: true).cgPath
        circleLayer.lineWidth = 5.0
        circleLayer.strokeColor = UIColor.systemOrange.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineJoin = .round
        circleLayer.lineDashPattern = [10, 20]
        layer.addSublayer(circleLayer)
        
        let dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
            dashAnimation.fromValue = 0
            dashAnimation.toValue = circleLayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
            dashAnimation.duration = 1.0
            dashAnimation.repeatCount = .infinity

            // Apply dash animation to the layer
            circleLayer.add(dashAnimation, forKey: "dashAnimation")
    }
}
