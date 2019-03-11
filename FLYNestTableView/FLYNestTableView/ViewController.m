//
//  ViewController.m
//  FLYNestTableView
//
//  Created by Fly on 2019/3/11.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FLYBaseScrollView.h"
#import "FLYTopView.h"
#import "FLYBottomView.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) FLYBaseScrollView *baseScrollView;
@property (nonatomic, strong) FLYTopView *topView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@property (nonatomic, assign) BOOL isCanMoveTopTabView;
@property (nonatomic, assign) BOOL isCanMoveTopTabViewPre;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) CGFloat screen_height;

@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataSource = @[@{@"title":@"分类1",@"num":@"50"},@{@"title":@"分类2",@"num":@"10"},@{@"title":@"分类3",@"num":@"30"}];
    
    if (SCREEN_STATUS_HEIGHT == 20) {
        self.screen_height = SCREEN_VIEW_HEIGHT;
    } else {
        self.screen_height = SCREEN_VIEW_HEIGHT-34;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"goBottom" object:nil];
    
    [self.view addSubview:self.baseScrollView];
    self.topView = [[FLYTopView alloc] init];
    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.screen_height);
    [self.topView renderUIWithInfo:@[] Model:@{}];
    [self.baseScrollView addSubview:self.topView];
    [self performSelector:@selector(addBottomView) withObject:nil afterDelay:0.5];
}

- (void)addBottomView {
    CGFloat contentSizeheight = self.topView.contentSizeHeight;
    if (contentSizeheight > self.screen_height) {
        self.baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.screen_height*2);
        FLYBottomView *view = [[FLYBottomView alloc] initWithFrame:CGRectMake(0, self.screen_height, SCREEN_WIDTH, self.screen_height) ConfigArray:self.dataSource];
        [self.baseScrollView addSubview:view];
    } else {
        self.baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentSizeheight + self.screen_height);
        FLYBottomView *view = [[FLYBottomView alloc] initWithFrame:CGRectMake(0, contentSizeheight, SCREEN_WIDTH, self.screen_height) ConfigArray:self.dataSource];
        [self.baseScrollView addSubview:view];
    }
}

- (void)acceptMsg:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

- (FLYBaseScrollView *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[FLYBaseScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_STATUS_HEIGHT+44, SCREEN_WIDTH, self.screen_height)];
        _baseScrollView.delegate = self;
        _baseScrollView.showsVerticalScrollIndicator = NO;
    }
    return _baseScrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat tabOffsetY;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    _isCanMoveTopTabViewPre = _isCanMoveTopTabView;
    
    if (self.topView.contentSizeHeight > self.screen_height) {
        tabOffsetY = self.screen_height;
    } else {
        tabOffsetY = self.topView.contentSizeHeight;
        _isCanMoveTopTabView = NO;
    }
    
    if (offsetY >= tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
        _isCanMoveTopTabView = NO;
    } else {
        _isTopIsCanNotMoveTabView = NO;
        int temp = self.topView.contentSizeHeight-self.screen_height;
        if (temp > 0) {
            if (self.topView.contentOffsetY >= temp) {
                if (offsetY <= 0) {
                    scrollView.contentOffset = CGPointMake(0, 0);
                    _isCanMoveTopTabView = YES;
                } else {
                    _isCanMoveTopTabView = NO;
                }
            } else if (self.topView.contentOffsetY == 0) {
                if (offsetY > 0) {
                    _isCanMoveTopTabView = YES;
                } else {
                    _isCanMoveTopTabView = NO;
                }
            }
            else {
                scrollView.contentOffset = CGPointMake(0, 0);
                _isCanMoveTopTabView = YES;
            }
        }
    }
    
    
    if (_isCanMoveTopTabView != _isCanMoveTopTabViewPre) {
        if (!_isCanMoveTopTabViewPre && _isCanMoveTopTabView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveHeaderBottom" object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
            
        }
        if(_isCanMoveTopTabViewPre && !_isCanMoveTopTabView) {
            if (!_canScroll) {
            }
        }
    }
    
    
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}

@end
