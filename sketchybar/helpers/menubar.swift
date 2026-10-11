// Opens native macOS menus from SketchyBar via the Accessibility API.
// Needs Accessibility permission; it inherits AeroSpace's when SketchyBar is started by AeroSpace.
//
//   menubar extras <bundle-id>                  list an app's status items (debug)
//   menubar press-extra <bundle-id> [ident]     open an app's status item menu (first, or AXIdentifier containing ident)
//   menubar menus                               print the frontmost app's menu titles, one per line
//   menubar press-menu <index>                  open the frontmost app's menu at that index (0 = Apple menu)
import AppKit

func attr(_ el: AXUIElement, _ name: String) -> CFTypeRef? {
    var v: CFTypeRef?
    return AXUIElementCopyAttributeValue(el, name as CFString, &v) == .success ? v : nil
}

func children(_ el: AXUIElement?) -> [AXUIElement] {
    guard let el else { return [] }
    return attr(el, kAXChildrenAttribute) as? [AXUIElement] ?? []
}

func app(bundle: String) -> AXUIElement? {
    guard let a = NSRunningApplication.runningApplications(withBundleIdentifier: bundle).first else { return nil }
    return AXUIElementCreateApplication(a.processIdentifier)
}

func frontmost() -> AXUIElement? {
    guard let a = NSWorkspace.shared.frontmostApplication else { return nil }
    return AXUIElementCreateApplication(a.processIdentifier)
}

func fail(_ msg: String) -> Never {
    FileHandle.standardError.write((msg + "\n").data(using: .utf8)!)
    exit(1)
}

// With the menu bar auto-hidden, its items sit off-screen and AXPress does nothing.
// Like FelixKratz's SketchyBar menus helper: force the menu bar "visible" but fully transparent,
// give it time to slide in (status items only respond once on-screen), click, then restore.
// Menus and Control Center panels stay open after the bar hides again. Private SkyLight calls, loaded at runtime.
typealias MainConnFn = @convention(c) () -> Int32
typealias VisOverrideFn = @convention(c) (Int32, Int32, Bool) -> Void
typealias InsetAlphaFn = @convention(c) (Int32, Double, Double, Float) -> Void
let skylight = dlopen("/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight", RTLD_LAZY)
func sym<T>(_ name: String, _: T.Type) -> T? {
    guard let skylight, let p = dlsym(skylight, name) else { return nil }
    return unsafeBitCast(p, to: T.self)
}

func click(_ el: AXUIElement) {
    let cid = sym("SLSMainConnectionID", MainConnFn.self)?() ?? 0
    let override = sym("SLSSetMenuBarVisibilityOverrideOnDisplay", VisOverrideFn.self)
    let insetAlpha = sym("SLSSetMenuBarInsetAndAlpha", InsetAlphaFn.self)
    insetAlpha?(cid, 0, 1, 0)
    override?(cid, 0, true)
    insetAlpha?(cid, 0, 1, 0)
    usleep(400_000)
    AXUIElementPerformAction(el, kAXPressAction as CFString)
    usleep(300_000)
    override?(cid, 0, false)
    insetAlpha?(cid, 0, 1, 1)
}

guard AXIsProcessTrusted() else { fail("menubar: no Accessibility permission") }
let args = CommandLine.arguments.dropFirst()

switch args.first {
case "extras":
    guard args.count == 2, let a = app(bundle: args[args.startIndex + 1]) else { fail("usage: menubar extras <bundle-id>") }
    for item in children(attr(a, "AXExtrasMenuBar") as! AXUIElement?) {
        let id = attr(item, "AXIdentifier") as? String ?? ""
        let desc = attr(item, kAXDescriptionAttribute) as? String ?? ""
        let title = attr(item, kAXTitleAttribute) as? String ?? ""
        print("\(id)\t\(desc)\t\(title)")
    }
case "press-extra":
    guard args.count >= 2, let a = app(bundle: args[args.startIndex + 1]) else { fail("usage: menubar press-extra <bundle-id> [ident]") }
    let items = children(attr(a, "AXExtrasMenuBar") as! AXUIElement?)
    let target: AXUIElement?
    if args.count >= 3 {
        let want = args[args.startIndex + 2]
        target = items.first { (attr($0, "AXIdentifier") as? String ?? "").contains(want) }
    } else {
        target = items.first
    }
    guard let target else { fail("menubar: status item not found") }
    click(target)
case "menus":
    guard let a = frontmost() else { fail("menubar: no frontmost app") }
    for item in children(attr(a, kAXMenuBarAttribute) as! AXUIElement?) {
        print(attr(item, kAXTitleAttribute) as? String ?? "")
    }
case "press-menu":
    guard args.count == 2, let i = Int(args[args.startIndex + 1]), let a = frontmost() else { fail("usage: menubar press-menu <index>") }
    let items = children(attr(a, kAXMenuBarAttribute) as! AXUIElement?)
    guard i >= 0, i < items.count else { fail("menubar: no menu at \(i)") }
    click(items[i])
default:
    fail("usage: menubar extras|press-extra|menus|press-menu ...")
}
