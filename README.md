# CMIndexBar.swift

CMIndexBar allows you to modify the colors, font, and size of UITableView's index bar.
 
This is a Swift port of the original (CMIndexBar)[https://github.com/CraigMerchant/CMIndexBar] library

<img src="https://s3.amazonaws.com/cmindexbar.swift/CMIndexBar.png"/>

### Usage

#### Initialization

```swift
let rect = CGRect(x: view.frame.size.width - 35,
                  y: 10.0,
                  width: 28.0,
                  height: view.frame.size.height - 20)
indexBar = CMIndexBar(frame: rect)
indexBar.textColor = UIColor.darkGray
indexBar.highlightedBackgroundColor = UIColor.lightGray
indexBar.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 12.0)        
indexBar.delegate = self
indexBar.setIndexes(["A", "B", "C", ...])
view.addSubview(indexBar)
```

#### Delegate

```swift
func indexSelectionDidChange(_ indexBar: CMIndexBar, index: Int, title: String) {
  let indexPath = IndexPath(row: 0, section: index)
  table.scrollToRow(at: indexPath, at: .top, animated: false)
}
```

## License
MIT © 2018 [Alex Pepper](https://alexpepper.us)
