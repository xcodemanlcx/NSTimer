//
//  BaseViewController.m
//  UI控件应用基础
//
//  Created by hx_leichunxiang on 14-9-18.
//  Copyright (c) 2014年 lcx. All rights reserved.
//  定时器的异步创建

#import "BaseViewController.h"

@interface BaseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    NSTimer *_timer;
    CFRunLoopRef _myRunLoop;//获取当前线程
    NSInteger _timerNumber;
}
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _dataSource = @[@"UIView",@"UIButton",@"UILabel",@"UITextField"];
    [self initData];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width,  [UIScreen mainScreen].applicationFrame.size.height)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor purpleColor];
    _tableView.separatorColor = [UIColor greenColor];
    [self.view addSubview:_tableView];
    
    
}

- (void)initData
{
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [_dataSource addObject:[NSString stringWithFormat:@"cell == %d",i]];
    }
}

#pragma mark - table view and dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    NSLog(@"cell=======%d",indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *str = cell.textLabel.text;
    if ((str||[str isEqualToString:@""])&&indexPath.row==4 ) {
        [_dataSource replaceObjectAtIndex:indexPath.row withObject:@"改变"];
    }
    cell.textLabel.text = _dataSource[indexPath.row];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - 定时器

- (void)timerAction
{
    NSLog(@"This is the %d time!",_timerNumber++);
}

//开启定时器
- (void)runTimer
{
    if (!_timer) {
        //        NSLog(@"=========================异步创建定时器");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            _myRunLoop = CFRunLoopGetCurrent();
            _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
            
        });
    }
}


//停止定时器
- (void)removeTimer
{
    //停止掉子线程中runloop
    if (_myRunLoop) {
        CFRunLoopStop(_myRunLoop);
        _myRunLoop = nil;
    }
    
    //返回上个视图
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        NSLog(@"定时器销毁");
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
