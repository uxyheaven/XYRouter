//
//  TableViewController.m
//  XYRouter
//
//  Created by heaven on 15/5/22.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "TableViewController.h"
#import "XYRouter.h"
#import "UIViewController+nvcItem.h"

@interface TableViewController ()
@property (nonatomic, strong) NSArray *list;
@end

@implementation TableViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self registerViewControllers];

    self.title = @"tableView";

    NSDictionary *dic = @{@"str": @"aaa",
                          @"你好": @"世界",
                          @"int": @1};
    NSData *JSONData     = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:nil];
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];

    _list = @[
        @{@"title": @"./TableVC"},
        @{@"title": @"../TableVC"},
        @{@"title": @"/TableVC"},
        @{@"title": @"TableVC"},
        @{@"title": @"./TableVC/TestVC1"},
        @{@"title": @"./TestVC1/TableVC"},
        @{@"title": @"/TableVC/TestVC1"},
        @{@"title": @"../"},
        @{@"title": @"/"},
        @{@"title": @"TestVC1/TableVC/TestVC1"},
        @{@"title": @"TestVC1?str1=a&str2=2&i=1"},
        @{@"title": @"window://TestVC2/"},
        @{@"title": @"window://nvc_TableVC/"},
        @{@"title": @"window://nvc_TableVC/TestVC1"},
        @{@"title": @"window://nvc_TableVC/TestVC1?str1=a&str2=2&i=1"},
        @{@"title": @"modal://TestModalVC/"},
        @{@"title": @"modal://TestModalVC/?str1=a&str2=2&i=1"},
        @{@"title": @"modal://nvc_TableVC/TestModalVC/?str1=a&str2=2&i=1"},
        @{@"title": @"TestVC1?str1=你好,&str2=世界!"},
        @{@"title": [NSString stringWithFormat:@"TestVC1?str1=%@", JSONString]},
        @{@"title": @"XYRouter://TableVC"},
        @{@"title": @"TestVC1#viewControllerWithStr1:str2:,你好,世界!"}
    ];

    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];

    [self addRightBarButtonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];

    // Configure the cell...
    cell.textLabel.text = _list[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = _list[indexPath.row][@"URL"] ? : _list[indexPath.row][@"title"];
    if (url.length == 0)
    {
        return;
    }

    if ([url hasPrefix:@"XYRouter"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }

    [[XYRouter sharedInstance] openURLString:url];

    // [self uxy_pushViewController:vc params:nil animated:YES completion:nil];
}

/*
   // Override to support conditional editing of the table view.
   - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
   }
 */

/*
   // Override to support editing the table view.
   - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
   }
 */

/*
   // Override to support rearranging the table view.
   - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
   }
 */

/*
   // Override to support conditional rearranging of the table view.
   - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
   }
 */

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */
#pragma mark -
- (void)registerViewControllers
{
    [[XYRouter sharedInstance] mapKey:@"nvc_TableVC"
                              toBlock:^UIViewController *{
        TableViewController *vc = [[TableViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        return nvc;
    }];
}

@end
