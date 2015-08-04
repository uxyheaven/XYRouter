//
//  TableViewController.m
//  XYRouter
//
//  Created by heaven on 15/5/22.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "TableViewController.h"
#import "XYRouter.h"

@interface TableViewController ()
@property (nonatomic, strong) NSArray *list;
@end

@implementation TableViewController
/*
+ (instancetype)sharedInstance
{
    static TableViewController *vc = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!vc) {
            vc = [[self alloc] init];
        }
    });
    return vc;
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self registerViewControllers];
    
    self.title = @"tableView";
    
    _list = @[
              @{@"title" : @"./TableVC"},
              @{@"title" : @"../TableVC"},
              @{@"title" : @"/TableVC"},
              @{@"title" : @"TableVC"},
              @{@"title" : @"./TableVC/TestVC1"},
              @{@"title" : @"./TestVC1/TableVC"},
              @{@"title" : @"../"},
              @{@"title" : @"/"},
              @{@"title" : @"TestVC1/TableVC/TestVC1"},
              @{@"title" : @"TestVC1?str1=a&str2=2&i=1"},
              @{@"title" : @"router://TestVC2"},
              @{@"title" : @"router://TestVC2/TestVC1"},
              @{@"title" : @"router://TableVC/TestVC1?str1=a&str2=2&i=1"}
              ];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = _list[indexPath.row][@"title"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = _list[indexPath.row][@"url"] ?: _list[indexPath.row][@"title"];
    if (url.length > 0)
    {
        [[XYRouter sharedInstance] openPath:url];
    }
    
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
#pragma mark-
- (void)registerViewControllers
{
    [[XYRouter sharedInstance] mapKey:@"aa" toControllerClassName:@"TableVC"];
    [[XYRouter sharedInstance] mapKey:@"bb" toControllerClassName:@"TableVC"];
}
@end
