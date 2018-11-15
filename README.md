# SwiftVIPER (View, Interactor, Presenter, Entity, Router)

SwiftVIPER is an sample iOS App written in Swift using the [VIPER](https://cheesecakelabs.com/blog/ios-project-architecture-using-viper/) architecture.  
Also SwiftVIPER is not a strict [VIPER](https://cheesecakelabs.com/blog/ios-project-architecture-using-viper/) architecture.   
Part of the project is a unique way.

[![Language](https://img.shields.io/badge/language-Swift%204.2-orange.svg)](https://swift.org)

## Sample App

<img src="./READMEResources/SwiftVIPER-Demo.gif" width="50%"><img src="./READMEResources/ProjectTree.png" width="50%">

### Architecture
<img src="./READMEResources/diagram.jpg" width="100%">

### Run Sample 
1. Clone this repository.
    ```
    git clone git@github.com:yokurin/Swift-VIPER-iOS.git
    ```

2. Open `SwiftVIPER.xcodeproj` in Xcode. 

3. Run

## Description
  
SwiftVIPER is not a strict [VIPER](https://cheesecakelabs.com/blog/ios-project-architecture-using-viper/) architecture.   
Part of the project is a unique way. This is just a suggestion. 


### View (including UIViewController)
View must implement Viewable. Viewable has Default Extension.  
※ View is not just View like UIView etc in this case.

```swift

protocol Viewable: AnyObject {
    func push(_ vc: UIViewController, animated: Bool)
    func present(_ vc: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
    func dismiss(animated: Bool, completion: @escaping (() -> Void))
}

extension Viewable where Self: UIViewController {

    func push(_ vc: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }

    func present(_ vc: UIViewController, animated: Bool) {
        self.present(vc, animated: animated, completion: nil)
    }

    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }

    func dismiss(animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }

    func dismiss(animated: Bool, completion: @escaping (() -> Void)) {
        self.dismiss(animated: animated, completion: completion)
    }
}


```

Example

```swift

protocol ViewInputs: AnyObject {
    
}

protocol ViewOutputs: AnyObject {
    func viewDidLoad()
}

final class ListViewController: UIViewController {

    internal var presenter: ViewOutputs?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    ...

}

extension ListViewController: ListViewInputs {}

extension ListViewController: Viewable {}

```


### Interactor
Interactor must implement Interactorable. But Interactorable has no properties.  

```swift
protocol Interactorable {
    // nop
}

```

Example

```swift

protocol InteractorOutputs: AnyObject {

}

final class Interactor: Interactorable {

    weak var presenter: InteractorOutputs?
    
}


```

### Presenter
Presenter must implement Presenterable.

```swift
protocol Presenterable {
    associatedtype I: Interactorable
    associatedtype R: Routerable
    var dependencies: (interactor: I, router: R) { get }
}

```

Example

```swift

/// Must not import UIKit

typealias PresenterDependencies = (
    interactor: Interactor,
    router: RouterOutput
)

final class Presenter: Presenterable {
    
    ...
    
    internal var entities: Entities
    private weak var view: ViewInputs!
    let dependencies: PresenterDependencies

    init(entities: Entities,
         view: ViewInputs,
         dependencies: PresenterDependencies)
    {
        self.view = view
        self.entities = entities
        self.dependencies = dependencies
    }
    
    ...
}

```

### Entity
Entity has no protocol. 

Example

```swift

struct EntryEntity {}

final class Entities {
    let entryEntity: EntryEntity
    
    var entities: [SomeEntity] = []

    init(entryEntity: EntryEntity) {
        self.entryEntity = entryEntity
    }
}

```


### Router
Router must implement Routerable.


```swift
protocol Routerable {
    var view: Viewable! { get }

    func dismiss(animated: Bool)
    func dismiss(animated: Bool, completion: @escaping (() -> Void))
    func pop(animated: Bool)
}

extension Routerable {
    func dismiss(animated: Bool) {
        view.dismiss(animated: animated)
    }

    func dismiss(animated: Bool, completion: @escaping (() -> Void)) {
        view.dismiss(animated: animated, _completion: completion)
    }

    func pop(animated: Bool) {
        view.pop(animated: animated)
    }
}

```

Example

```swift

struct RouterInput {

    private func view(entryEntity: EntryEntity) -> ViewController {
        let view = ViewController()
        let interactor = Interactor()
        let dependencies = PresenterDependencies(interactor: interactor, router: RouterOutput(view))
        let presenter = Presenter(entities: Entities(entryEntity: entryEntity), view: view, dependencies: dependencies)
        view.presenter = presenter
        interactor.presenter = presenter
        return view
    }

    func push(from: Viewable, entryEntity: EntryEntity) {
        let view = self.view(entryEntity: entryEntity)
        from.push(view, animated: true)
    }

    func present(from: Viewable, entryEntity: EntryEntity) {
        let nav = UINavigationController(rootViewController: view(entryEntity: entryEntity))
        from.present(nav, animated: true)
    }
}

final class RouterOutput: Routerable {

    private(set) weak var view: Viewable!

    init(_ view: Viewable) {
        self.view = view
    }

    func transitionToOther() {
        OtherRouterInput().push(from: view, entryEntity: OtherEntryEntity())
    }
}

```

### Unit Test 

WIP ... 

### Xcode Template ( xctemplate )

WIP ...

## Requirements

- Xcode 10.0+
- Swift 4.2+

## Installation

```
git clone git@github.com:yokurin/Swift-VIPER-iOS.git
```

## Author

Tsubasa Hayashi, yoku.rin.99@gmail.com

## License

SwiftVIPER is available under the MIT license. See the LICENSE file for more info.
