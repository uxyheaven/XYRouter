# XYRouter
XYRouter是通过url routing来解决UIViewController跳转依赖的类.
* 本类才用ARC

## Installation
* 本库基于ARC
* 拷贝XYQuick到项目里
* 在需要用的文件或者pch里 `#import "XYRouter.h"

### Podfile

## Usage
### Creating viewController map
```
[[XYRouter sharedInstance] mapKey:@"aaa" toControllerClassName:@"UIViewController"];
```
### Getting viewController for key
```
[[XYRouter sharedInstance] viewControllerForKey:@"aaa"];
```

### Maping a viewController instance
```
[[XYRouter sharedInstance] mapKey:@"bbb" toControllerInstance:[[UIViewController alloc] init]];
```