# XYRouter
XYRouter是通过url routing来解决UIViewController跳转依赖的类.
* 本类采用ARC

## Installation
* 本库基于ARC
* 拷贝XYQuick到项目里
* 在需要用的文件或者pch里 `#import "XYRouter.h"`

### Podfile

## Usage
### Creating viewController map
可以通过key和NSString来映射一个UIViewController

```
[[XYRouter sharedInstance] mapKey:@"aaa" toControllerClassName:@"UIViewController"];
```
### Getting viewController for key
当取出ViewController的时候, 如果有单例[ViewController sharedInstance], 默认返回单例, 如果没有, 返回[[ViewController alloc] init].

```
UIViewController *vc = [[XYRouter sharedInstance] viewControllerForKey:@"aaa"];
```

### Maping a viewController instance
如果不想每次都创建对象, 也可以直接映射一个实例

```
[[XYRouter sharedInstance] mapKey:@"bbb" toControllerInstance:[[UIViewController alloc] init]];
```

### Maping a viewController instance with a block
如果想在需要的时候才创建对象, 以及更好的定制对象, 可以用block

```
[[XYRouter sharedInstance] mapKey:@"nvc_TableVC" toBlock:^UIViewController *{
        TableViewController *vc = [[TableViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        return nvc;
    }];
```



