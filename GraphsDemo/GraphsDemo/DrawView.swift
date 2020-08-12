//
//  DrawView.swift
//  GraphsDemo
//
//  Created by Rajat Tyagi on 06/08/20.
//  Copyright © 2020 Rajat Tyagi. All rights reserved.
//

import UIKit

enum Shape {
    case circle
    case filledCircle
    case rectangle
    case filledRectange
}

enum GraphType {
    case bar
}

extension FloatingPoint {
    var degreeToRadians: Self { return self * .pi / 180 }
}

class DrawView: UIView {
    
    var currentShape: Shape?
    var color: UIColor?
    var graphType: GraphType?
    var graphCoordinates: [CGFloat]?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        print("Drawing")
        
        guard let currentContext = UIGraphicsGetCurrentContext() else { print("Could not get current context")
            return }
//        guard let  currentShape = currentShape else {print("Could not get current shape")
//            return }
//        guard let color = color else{ print("Could not get color")
//            return }
        guard let graphType = graphType else { print("Could not get graph type")
            return }
        guard let graphCoordinates = graphCoordinates  else {
            print("Could not get coordinates")
            return
        }
        
        switch currentShape {
        case .circle:
            drawCircle(using: currentContext, isFilled: false,color: color ?? UIColor.black)
        case .filledCircle:
            drawCircle(using: currentContext, isFilled: true,color: color ?? UIColor.black)
        case .rectangle:
            drawRectangle(using: currentContext, isFilled: false,color: color ?? UIColor.black)
        case .filledRectange:
            drawRectangle(using: currentContext, isFilled: true,color: color ?? UIColor.black)
        case .none:
            print("None")
        }
        
        switch graphType {
        case .bar:
            drawBarGraph(using: currentContext, coordinates: graphCoordinates)
        }
        
    }
    
    private func drawBarGraph(using context: CGContext, coordinates: [CGFloat]) {
        var highestX : CGFloat = 0.0
        var highestY: CGFloat = 0.0
        
        for coordinate in coordinates {
//            if(coordinate.x >= highestX ) {
//                highestX = coordinate.x
//            }
            if(coordinate >= highestY) {
                highestY = coordinate
            }
        }
        
        let containerHeight = bounds.size.height
        
        let graphHeight : CGFloat = (containerHeight - 40) * 0.9
        let heightScaleFactor = graphHeight / highestY
        

        
        //MARK:- Creating Bars in Bar Graph
        var i: CGFloat = 20 + bounds.width/15
        let barWidth: CGFloat = bounds.width/15
        
        for coordinate in coordinates {
            context.move(to: CGPoint(x: i, y: bounds.height - 20))
            context.addLine(to: CGPoint(x: i, y: bounds.height - 20))
            context.addLine(to: CGPoint(x: i, y: bounds.height - 20 - coordinate * heightScaleFactor))
            context.addLine(to: CGPoint(x: i + barWidth, y: bounds.height - 20 - coordinate * heightScaleFactor))
            context.addLine(to: CGPoint(x: i + barWidth, y: bounds.height - 20))
            
            context.setLineCap(.round)
            context.setLineWidth(3.0)
            
            context.setFillColor(UIColor.red.cgColor)
            context.fillPath()
            
            i = i + barWidth + bounds.width/20
            
        }
        
        
        //MARK:- Creating Graph Edges
        let bottomRightCorner = CGPoint(x: bounds.width - 20, y: bounds.height - 20)
        let bottomLeftCorner = CGPoint(x: 20, y: bounds.height - 20)
        let topLeftCorner = CGPoint(x: 20, y: 20)
        
        context.move(to: topLeftCorner)
        context.addLine(to: topLeftCorner)
        context.addLine(to: bottomLeftCorner)
        context.addLine(to: bottomRightCorner)
        
        context.setLineCap(.round)
        context.setLineWidth(6.0)
        
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
        
    }
     
    private func drawCircle(using context: CGContext, isFilled: Bool, color: UIColor) {
        
        let centerPoint = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        let radius = bounds.size.width/2 - 20
        context.addArc(center: centerPoint, radius: radius, startAngle: CGFloat(0).degreeToRadians, endAngle: CGFloat(360).degreeToRadians, clockwise: true)
        
        if isFilled {
            context.setFillColor(color.cgColor)
            context.fillPath()
        } else {
            context.setStrokeColor(color.cgColor)
            context.strokePath()
            
        }
        
    }
    
    private func drawRectangle(using context: CGContext, isFilled: Bool, color: UIColor) {
        
        let strokeDistance: CGFloat = bounds.size.height/5
        
        let centerPoint = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        
        let lowerLeftCorner = CGPoint(x: centerPoint.x - strokeDistance, y: centerPoint.y + strokeDistance * 2)
        let lowerRightCorner = CGPoint(x: centerPoint.x + strokeDistance, y: centerPoint.y + strokeDistance * 2)
        let upperLeftCorner = CGPoint(x: centerPoint.x - strokeDistance, y: centerPoint.y - strokeDistance * 2)
        let upperRightCorner = CGPoint(x: centerPoint.x + strokeDistance, y: centerPoint.y - strokeDistance * 2)
        
        context.move(to: lowerLeftCorner)
        context.addLine(to: lowerLeftCorner)
        context.addLine(to: lowerRightCorner)
        context.addLine(to: upperRightCorner)
        context.addLine(to: upperLeftCorner)
        context.addLine(to: lowerLeftCorner)
        
        context.setLineCap(.round)
        context.setLineWidth(6.0)
        
        if isFilled {
            context.setFillColor(color.cgColor)
            context.fillPath()
            
        } else {
            context.setStrokeColor(color.cgColor)
            context.strokePath()
        }
    }
    
    func drawShape(selectedShape: Shape, color: UIColor) {
        currentShape = selectedShape
        self.color = color
        setNeedsDisplay()
    }
    
    func drawGraph(selectedGraph: GraphType, graphCoordinates: [CGFloat]) {
        self.graphType = selectedGraph
        self.graphCoordinates = graphCoordinates
        setNeedsDisplay()
    }
    

}
