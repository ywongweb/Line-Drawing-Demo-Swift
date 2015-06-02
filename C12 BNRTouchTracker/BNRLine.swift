import Foundation
import UIKit

//
// cannot be a struct because this object is used in a dictionary, when retriving from a dictionary, a stuct is copied, therefor any changes will not be apply to object in the dictionary.
class BNRLine {
    var begin: CGPoint
    var end: CGPoint
    
    init(begin: CGPoint, end: CGPoint) {
        self.begin = begin
        self.end = end
    }
}