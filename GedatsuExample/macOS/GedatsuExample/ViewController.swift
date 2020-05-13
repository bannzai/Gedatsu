import Cocoa
import Gedatsu

class ViewController: NSViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        Gedatsu.open()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        
    }

}


final class GedatsuView: NSView { }
