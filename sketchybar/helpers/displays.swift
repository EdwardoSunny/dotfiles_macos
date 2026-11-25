import AppKit

// AeroSpace uses 1-based NSScreen indices; UUIDs identify the displays across reconnects.
for (index, screen) in NSScreen.screens.enumerated() {
    if let number = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber,
       let uuid = CGDisplayCreateUUIDFromDisplayID(number.uint32Value)?.takeRetainedValue() {
        print("\(index + 1) \(number.uint32Value) \(CFUUIDCreateString(nil, uuid)!)")
    }
}
