//
//  ViewController.m
//  tableView联动
//
//  Created by jf on 17/1/16.
//  Copyright © 2017年 王明星. All rights reserved.
//

#import "ViewController.h"

#define leftTableWidth  [UIScreen mainScreen].bounds.size.width * 0.3
#define rightTableWidth [UIScreen mainScreen].bounds.size.width * 0.7
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height

#define leftCellIdentifier  @"leftCellIdentifier"
#define rightCellIdentifier @"rightCellIdentifier"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *leftTableView;

@property (nonatomic, weak) UITableView *rightTableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
    
}
#pragma mark - 懒加载 tableView -
// MARK: - 左边的 tableView
- (UITableView *)leftTableView {
    
    if (!_leftTableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, leftTableWidth, ScreenHeight)];
        
        [self.view addSubview:tableView];
        
        _leftTableView = tableView;
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:leftCellIdentifier];
        tableView.backgroundColor = [UIColor redColor];
        tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _leftTableView;
}

// MARK: - 右边的 tableView
- (UITableView *)rightTableView {
    
    if (!_rightTableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(leftTableWidth, 0, rightTableWidth, ScreenHeight)];
        
        [self.view addSubview:tableView];
        
        _rightTableView = tableView;
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:rightCellIdentifier];
        tableView.backgroundColor = [UIColor cyanColor];
        tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _rightTableView;
}
#pragma mark --UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return 20;
    }
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTableView) {
        return 1;
    }
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    //左边的tableview
    if (tableView == self.leftTableView ) {
        cell = [tableView dequeueReusableCellWithIdentifier:leftCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:rightCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组-第%ld行", indexPath.section, indexPath.row];
    }
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.rightTableView) return [NSString stringWithFormat:@"第 %ld 组", section];
    
    return nil;
}
#pragma mark --UITableViewDelegate
//MARK: - 点击 cell 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 选中 左侧 的 tableView
    if (tableView == self.leftTableView) {
        //                  把这个0改为NSNotFound就可以了，避免右边tableview只有标题没有数据时奔溃问题
        NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:NSNotFound inSection:indexPath.row];
        
//        // 将右侧 tableView 移动到指定位置
//        [self.rightTableView selectRowAtIndexPath:moveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//        // 取消选中效果
//        [self.rightTableView deselectRowAtIndexPath:moveToIndexPath animated:YES];
        
        //这个方法可以代替上面的两行代码
         [self.rightTableView scrollToRowAtIndexPath:moveToIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    
        
    }
    
}
//MARK: - 一个方法就能搞定 右边滑动时跟左边的联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 如果是 左侧的 tableView 直接return
    if (scrollView == self.leftTableView || !self.rightTableView.dragging) return;
    
    // 取出显示在 视图 且最靠上 的 cell 的 indexPath
    NSIndexPath *topHeaderViewIndexpath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
    
    // 左侧 talbelView 移动的 indexPath
    NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
    
    // 移动 左侧 tableView 到 指定 indexPath 居中显示
    [self.leftTableView selectRowAtIndexPath:moveToIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
     NSLog(@"所有的 cell 的indexpath == %@",[self.rightTableView indexPathsForVisibleRows]);
    NSLog(@"最靠上 cell 的indexpath == %@",topHeaderViewIndexpath);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
