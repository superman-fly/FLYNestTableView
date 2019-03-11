//
//  FLYTopView.m
//  FLYNestTableView
//
//  Created by Fly on 2019/3/11.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FLYTopView.h"

@interface FLYTopView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) NSArray *cellArray;
@property (nonatomic, strong) NSMutableArray *taskATypeArray;
@property (nonatomic, strong) NSMutableArray *typeAModelArray;

@property (nonatomic, strong) NSDictionary *taskIndexModel;
@end

@implementation FLYTopView

- (CGFloat)contentSizeHeight {
    _contentSizeHeight = self.mTableView.contentSize.height;
    return _contentSizeHeight;
}

- (CGFloat)contentOffsetY {
    _contentOffsetY = self.mTableView.contentOffset.y;
    return _contentOffsetY;
}

-(void)renderUIWithInfo:(NSArray *)info Model:(NSDictionary *)model {
    self.cellArray = info;
    self.taskIndexModel = model;
    [self addSubview:self.mTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"goBottom" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveHeaderBottom" object:nil];
}

- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _mTableView.frame = self.bounds;
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.backgroundColor = [UIColor whiteColor];
        _mTableView.tableFooterView = [[UIView alloc] init];
        _mTableView.rowHeight = UITableViewAutomaticDimension;
        _mTableView.bounces = NO;
        _mTableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}

- (void)acceptMsg:(NSNotification *)notification {
    //NSLog(@"%@",notification);
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:@"goBottom"]) {
        int temp = self.contentSizeHeight-self.bounds.size.height;
        self.mTableView.contentOffset = CGPointMake(0, temp);
        self.canScroll = NO;
    }
    else if([notificationName isEqualToString:@"leaveHeaderBottom"]){
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    int temp = self.contentSizeHeight-self.bounds.size.height;
    if (!self.canScroll) {
        if (offsetY >= 0) {
            [scrollView setContentOffset:CGPointMake(0, temp)];
        }
    }

    if (offsetY >= temp) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goBottom" object:nil userInfo:@{@"canScroll":@"1"}];
    }
}

#pragma mark --- tableViewDelegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor grayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 50)];
    label.text = @"标题";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"内容 %ld-%ld",indexPath.section,indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
