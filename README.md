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
如果想更好的定制对象, 可以用block

```
[[XYRouter sharedInstance] mapKey:@"nvc_TableVC" toBlock:^UIViewController *{
        TableViewController *vc = [[TableViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        return nvc;
    }];
```

### Opening path
你可以使用key去push出一个viewController

```
[[XYRouter sharedInstance] openPath:@"aaa"];
```
path还支持相对路径, 如下面的代码可以在当前目录下push出一个TableVC后, 再push出TestVC1.

```
[[XYRouter sharedInstance] openPath:@"./TableVC/TestVC1"];

```

目前支持这些描述:

* 在当前目录push  `./`
* 在上一个目录push `../`
*  在根目录根push ` /`

### Assigning parameters
在跳转的时候还可以传递参数

```
@interface TestVC1 : UIViewController
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, copy) NSString *str1;
@property (nonatomic, copy) NSString *str2;
@end

[[XYRouter sharedInstance] openPath:@"TestVC1?str1=a&str2=2&i=1"];
```

#### Changing rootViewController
可以用完整的路径替换windows.rootViewController

```
// rootViewController : nvc_TableVC
[[XYRouter sharedInstance] openPath:@"router://nvc_TableVC/TestVC1"];
```


