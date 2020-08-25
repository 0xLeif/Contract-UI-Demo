# Contract-UI-Demo

## Demo Video
![demo](.media/demo.gif)

## Example Code
```swift
import Later
import SwiftUIKit

class ViewController: UIViewController {
    var textContract: Contract<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = Label("❗️👀")
        
        view.embed {
            VStack(distribution: .fillEqually) {
                [
                    label
                        .text(alignment: .center)
                        .number(ofLines: 3),
                    Spacer(),
                    HStack(distribution: .fillEqually) {
                        [
                            Button("Resign Contract") { [weak self] in
                                self?.textContract?.resign()
                            },
                            Button("Update Text") { [weak self] in
                                self?.textContract?.value = "Now: \(Date().timeIntervalSince1970)"
                            }
                        ]
                    }
                    .padding()
                ]
            }
        }
        
        textContract = Contract(initialValue: "Hello, World!") { value in
            Later.main {
                label.text = value
            }
        }
        .onResign { lastValue in
            Later.main {
                label.text = "Contract was Resigned\nLast Value: \(lastValue ?? "-1")"
            }
        }
    }
}
```
