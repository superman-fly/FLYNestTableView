//
//  FLYBottomView.m
//  FLYNestTableView
//
//  Created by Fly on 2019/3/11.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FLYBottomView.h"
#import "FLYGroupsItemView.h"
#import "FLY_TitleButtonsScrollView.h"

@interface FLYBottomView()<UIScrollViewDelegate,FLY_TitleButtonsScrollViewDelegate>

@property (nonatomic, strong) FLY_TitleButtonsScrollView *tabTitleView;
@property (nonatomic, strong) UIScrollView *tabScrollView;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation FLYBottomView

- (instancetype)initWithFrame:(CGRect)frame ConfigArray:(NSArray *)tabConfigArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        self.titleArray = [NSMutableArray array];
        for (int i=0; i<tabConfigArray.count; i++) {
            NSDictionary *itemDic = tabConfigArray[i];
            [self.titleArray addObject:itemDic[@"title"]];
        }
        
        [self addSubview:self.tabTitleView];
        [self addSubview:self.tabScrollView];
        
        for (int i=0; i<tabConfigArray.count; i++) {
            FLYGroupsItemView *itemBaseView = [[FLYGroupsItemView alloc] init];
            itemBaseView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, frame.size.height-58);
            [itemBaseView renderUIWithInfo:tabConfigArray[i]];
            [_tabScrollView addSubview:itemBaseView];
        }
    }
    return self;
}

- (FLY_TitleButtonsScrollView *)tabTitleView {
    if (!_tabTitleView) {
        _tabTitleView = [FLY_TitleButtonsScrollView segmentedControlWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58) delegate:self childVcTitle:self.titleArray];
        _tabTitleView.btn_fondOfSize = 18;
        _tabTitleView.titleColor = [UIColor blackColor];
        _tabTitleView.titleSelectedColor = [UIColor blackColor];
        _tabTitleView.indicatorViewColor = [UIColor redColor];
        _tabTitleView.indicatorViewHeight = 3;
        _tabTitleView.isLeftAligned = YES;
        _tabTitleView.backgroundColor = [UIColor grayColor];
        [_tabTitleView setupSubviews];
    }
    return _tabTitleView;
}

- (UIScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 58, SCREEN_WIDTH, CGRectGetHeight(self.frame) - 58)];
        _tabScrollView.contentSize = CGSizeMake(CGRectGetWidth(_tabScrollView.frame)*self.titleArray.count, CGRectGetHeight(_tabScrollView.frame));
        _tabScrollView.pagingEnabled = YES;
        _tabScrollView.bounces = NO;
        _tabScrollView.showsHorizontalScrollIndicator = NO;
        _tabScrollView.delegate = self;
    }
    return _tabScrollView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pageNum = offsetX/SCREEN_WIDTH;
    [_tabTitleView changeTheIndexOfTheSelectedBtn:pageNum];
}

- (void)FLY_TitlesBtnControlDefault:(FLY_TitleButtonsScrollView *)segmentedControlDefault didSelectTitleAtIndex:(NSInteger)index {
    [self.tabScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
