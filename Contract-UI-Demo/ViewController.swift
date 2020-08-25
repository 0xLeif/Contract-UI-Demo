import UIKit
import Later
import SwiftUIKit

struct LabelViewModel {
    var text: String
    var color: UIColor
    var alignment: NSTextAlignment
}

class ViewController: UIViewController {
    let textContract = Contract<String>()
    let label = Label("❗️👀")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textContract
            .onChange { value in
                Later.main { [weak self] in
                    self?.label.text = value
                }
        }
        .onResign { lastValue in
            Later.main { [weak self] in
                self?.label.text = "Contract was Resigned\nLast Value: \(lastValue ?? "-1")"
            }
        }
        
        textContract.value = "Hello World"
        
        let labelContractView = ContractView(view: Label("❗️👀")) { labelView in
            Contract(initialValue: LabelViewModel(text: "Fetching...",
                                                  color: .green,
                                                  alignment: .center)) { vm in
                Later.main {
                    labelView
                        .text(alignment: vm?.alignment ?? .left)
                        .text(color: vm?.color ?? .black)
                    
                    labelView.text = vm?.text ?? "-1"
                }
            }
        }
        
        Later.do(withDelay: 4) {
            var vm = labelContractView.contract?.value
            
            vm?.text = "Hello...?"
            vm?.alignment = .right
            
            labelContractView.contract?.value = vm
        }
        
        view.embed {
            VStack(distribution: .fillEqually) {
                [
                    labelContractView,
                    label
                        .text(alignment: .center)
                        .number(ofLines: 3),
                    LoadingImage(URL(string: "https://avatars0.githubusercontent.com/u/8268288?s=460&u=2cb09673ea7f5230fa929b9b14a438cb2a65751c&v=4")!),
                    Spacer()
                ]
            }
            .configure { stack in
                Later.main(withDelay: 3) {
                    stack.views.value?.append(HStack(distribution: .fillEqually) {
                        [
                            Button("Resign Contract") { [weak self] in
                                self?.textContract.resign()
                            },
                            Button("Update Text") { [weak self] in
                                self?.textContract.value = "Now: \(Date().timeIntervalSince1970)"
                            }
                        ]
                    }
                    .padding())
                }
            }
        }
    }
}

