import UIKit

public enum Kern {
    public static func fromFigmaToIOS(figmaLetterSpasing: Double) -> Double {
        let kernInPixels = figmaLetterSpasing
        let kernInPoints = kernInPixels * UIScreen.main.scale
        return kernInPoints
    }
}

