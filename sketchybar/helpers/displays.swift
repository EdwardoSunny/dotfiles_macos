import AppKit

// AeroSpace reports 1-based NSScreen indices; SketchyBar uses display arrangement IDs.
for (index, screen) in NSScreen.screens.enumerated() {
    if let number = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber {
        print("\(index + 1) \(number.uint32Value)")
    }
}
