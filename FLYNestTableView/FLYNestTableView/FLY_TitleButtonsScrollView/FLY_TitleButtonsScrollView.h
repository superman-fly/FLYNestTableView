//
//  FLY_TitleButtonsScrollView.h
//  Dragon_LCS
//
//  Created by 乔布斯 on 2019/3/8.
//  Copyright © 2019年 乔布斯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FLY_TitleButtonsScrollView;

@protocol FLY_TitleButtonsScrollViewDelegate <NSObject>
// delegate 方法
- (void)FLY_TitlesBtnControlDefault:(FLY_TitleButtonsScrollView *)segmentedControlDefault didSelectTitleAtIndex:(NSInteger)index;

@end

@interface FLY_TitleButtonsScrollView : UIScrollView
@property (nonatomic, weak) id<FLY_TitleButtonsScrollViewDelegate> delegate_TB;

/** 按钮字体的大小(字号) 默认15 */
@property (nonatomic, assign) CGFloat btn_fondOfSize;
/** 标题按钮文字的缩放倍数 默认0.14 */
@property (nonatomic, assign) CGFloat btn_scale;
/** 按钮之间的间距(滚动时按钮之间的间距) 默认15 */
@property (nonatomic, assign) CGFloat btn_Margin;
/** 指示器的高度(默认指示器) 默认2 */
@property (nonatomic, assign) CGFloat indicatorViewHeight;
/** 点击按钮时, 指示器的动画移动时间 默认0.15 */
@property (nonatomic, assign) CGFloat indicatorViewTimeOfAnimation;

/** 标题字体颜色 默认666 */
@property (nonatomic, strong) UIColor *titleColor;
/** 选中标题字体颜色 默认333 */
@property (nonatomic, strong) UIColor *titleSelectedColor;
/** 指示器颜色 默认fda014 */
@property (nonatomic, strong) UIColor *indicatorViewColor;

/** 是否开启文字缩放功能 默认NO */
@property (nonatomic, assign) BOOL isScaleText;

/** 标签不足一屏左对齐 默认NO */
@property (nonatomic, assign) BOOL isLeftAligned;

/** 标签宽度是否相等 默认YES */
@property (nonatomic, assign) BOOL isEqualityWidth;

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<FLY_TitleButtonsScrollViewDelegate>)delegate childVcTitle:(NSArray *)childVcTitle;

- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView;

- (void)changeTheIndexOfTheSelectedBtn:(NSInteger)index;

- (void)updateScrollView;

- (void)setupSubviews;
@end

NS_ASSUME_NONNULL_END
