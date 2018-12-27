# Rxswift Example showing Two Way Binding

This is the example playground repository proof of concept for this article:

[Medium article](https://medium.com/@dannylazarow/rxswift-reverse-observable-aka-two-way-binding-5027cbfdc6f0)

Usually when we use RxSwift, we setup things in a way that one part of the code emits events (for example: TextField onchange text) and other parts listen for it aka. observe changes (for example: UILable that shows text)

But how about passing events in both directions like so:

```
TextField <------> Observable <------> TextField
```

![Two way binding](https://cdn-images-1.medium.com/max/800/1*jUoFEq2ZB7u5YcpapuhT_g.gif)![Two way binding](https://cdn-images-1.medium.com/max/800/1*jUoFEq2ZB7u5YcpapuhT_g.gif)

We can do this by bind two RxSwif observables to listen for each other's changes

```swift
infix operator <->

func <-> (lhs: BehaviorRelay, rhs: BehaviorRelay) -> Disposable {
    typealias ItemType = (current: T, previous: T)
    
    return Observable.combineLatest(lhs.currentAndPrevious(), rhs.currentAndPrevious())
        .filter({ (first: ItemType, second: ItemType) -> Bool in
            return first.current != second.current
        })
        .subscribe(onNext: { (first: ItemType, second: ItemType) in
            if first.current != first.previous {
                rhs.accept(first.current)
            }
            else if (second.current != second.previous) {
                lhs.accept(second.current)
            }
        })
}
```

```swift
let textFirst = BehaviorRelay(value: nil)
let textSecond = BehaviorRelay(value: nil)
(textSecond <-> textFirst).disposed(by: disposeBag)
```

(You can check the BasicFormController.swift or FullFormController.swift for the full code)

# Instalation

This repository depends on `Carthage`package managed [Link](https://github.com/Carthage/Carthage), head there and install it first

then from the main directory run

```
carthage update --platform iOS
```
