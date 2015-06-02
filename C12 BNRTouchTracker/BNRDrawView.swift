import UIKit

class BNRDrawView: UIView {
    
    // keep track of all drawn lines and the current line
    var linesInProgress = [NSValue:BNRLine]()
    var finishedLines = [BNRLine]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        self.multipleTouchEnabled = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Draw line
    private func strokeLine(line: BNRLine) {
        let bp = UIBezierPath()
        bp.lineWidth = 10
        bp.lineCapStyle = kCGLineCapRound
        
        bp.moveToPoint(line.begin)
        bp.addLineToPoint(line.end)
        bp.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        // Draw finished lines in colors depending on thier angle
        for line in self.finishedLines {
            let angle = lineAngle(line)
            switch angle {
            case 0.0..<90.0:
                UIColor.blueColor().set()
            case 90.0..<180.0:
                UIColor.orangeColor().set()
            case let x where x < 0 && x > -90:
                UIColor.yellowColor().set()
            case let x where x <= -90 && x >= -180:
                UIColor.greenColor().set()
            default:
                break
            }
            
            self.strokeLine(line)
        }
        
        // draw current lines in red
        UIColor.redColor().set()
        for (key, line) in self.linesInProgress {
            self.strokeLine(line)
        }
    }
    
    private func lineAngle(line: BNRLine) -> Float {
        let x = line.begin.x
        let y = line.begin.y
        let dx = line.end.x - x
        let dy = line.end.y - y
        let radians = atan2(-dx,dy);        // in radians
        let degrees = radians * 180 / 3.14; // in degrees
        println("d: \(degrees)")
        return Float(degrees);
    }
    
    // MARK: Touch Events
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // let's put in a log statement to see the order of events
        println(__FUNCTION__)
        
        // “use fast enumeration to loop over all of the touches that began, because it is possible that more than one touch can begin at the same time. (Although typically touches begin at different times and BNRDrawView will receive multiple touchesBegan:withEvent: messages containing each touch.)”
        for t in touches {
            let touch = t as? UITouch
            let location: CGPoint = touch!.locationInView(self)
            let line = BNRLine(begin: location, end: location)
            
            // add an object to a collection but don’t want the collection to create a strong reference to it. This is because lines get destroy after touchEnded
            let key = NSValue(nonretainedObject: t)
            linesInProgress[key] = line
        }
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // let's put in a log statement to see the order of events
        println(__FUNCTION__)
        
        for t in touches {
            let touch = t as? UITouch
            let key = NSValue(nonretainedObject: t)
            var line = self.linesInProgress[key]
            line!.end = touch!.locationInView(self)
        }
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        // let's put in a log statement to see the order of events
        println(__FUNCTION__)
        
        for t in touches {
            let key = NSValue(nonretainedObject: t)
            let line = self.linesInProgress[key]
            finishedLines.append(line!)
            
            // remove current lines in array
            self.linesInProgress.removeValueForKey(key)
        }
        self.setNeedsDisplay()
    }

//    “When a touch is cancelled, any state it set up should be reverted. In this case, you should remove any lines in progress. ”
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        // let's put in a log statement to see the order of events
        println(__FUNCTION__)
        
        for t in touches {
            let key = NSValue(nonretainedObject: t)
            self.linesInProgress.removeValueForKey(key)
        }
        self.setNeedsDisplay()
    }
}
