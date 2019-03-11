//
//  FLY_TitleButtonsScrollView.m
//  Dragon_LCS
//
//  Created by 乔布斯 on 2019/3/8.
//  Copyright © 2019年 乔布斯. All rights reserved.
//

#import "FLY_TitleButtonsScrollView.h"
#import "UIView+FLYExtension.h"

@interface FLY_TitleButtonsScrollView()
/** 标题数组 */
@property (nonatomic, strong) NSArray *title_Arr;
/** 标题按钮 */
@property (nonatomic, strong) UIButton *title_btn;
/** 存入所有标题按钮 */
@property (nonatomic, strong) NSMutableArray *storageAlltitleBtn_mArr;

/** 临时button用来转换button的点击状态 */
@property (nonatomic, strong) UIButton *temp_btn;
/** 指示器 */
@property (nonatomic, strong) UIView *indicatorView;
/** 标记是否是一个button */
@property (nonatomic, assign) BOOL isFirstButton;
/** 按钮索引 */
@property (nonatomic, assign) NSInteger index;
/** 计算scrollView的宽度 */
@property (nonatomic, assign) CGFloat scrollViewWidth;

@end

@implementation FLY_TitleButtonsScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        self.bounces = NO;
        [self initialization];
    }
    return self;
}

- (void)initialization {
    /** 按钮字体的大小(字号) */
    self.btn_fondOfSize = 15;
    /** 标题按钮文字的缩放倍数 */
    self.btn_scale = 0.14;
    /** 按钮之间的间距(滚动时按钮之间的间距) */
    self.btn_Margin = 15;
    /** 指示器的高度(默认指示器) */
    self.indicatorViewHeight = 2;
    /** 点击按钮时, 指示器的动画移动时间 */
    self.indicatorViewTimeOfAnimation = 0.15;
    
    self.titleColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.titleSelectedColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.indicatorViewColor = [UIColor colorWithRed:253/255.0 green:160/255.0 blue:20/255.0 alpha:1];
    
    self.isScaleText = NO;
    self.isLeftAligned = NO;
    self.isEqualityWidth = YES;
}

- (NSMutableArray *)storageAlltitleBtn_mArr {
    if (!_storageAlltitleBtn_mArr) {
        _storageAlltitleBtn_mArr = [NSMutableArray array];
    }
    return _storageAlltitleBtn_mArr;
}

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<FLY_TitleButtonsScrollViewDelegate>)delegate childVcTitle:(NSArray *)childVcTitle {
    FLY_TitleButtonsScrollView *titleBtns = [[self alloc] initWithFrame:frame];
    titleBtns.delegate_TB = delegate;
    titleBtns.title_Arr = childVcTitle;
    return titleBtns;
}

- (void)setupSubviews {
    // 计算scrollView的宽度
    CGFloat button_X = 0;
    CGFloat button_Y = 0;
    CGFloat button_H = self.frame.size.height;
    
    for (NSUInteger i = 0; i < _title_Arr.count; i++) {
        /** 创建滚动时的标题button */
        self.title_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        _title_btn.titleLabel.font = [UIFont systemFontOfSize:self.btn_fondOfSize];
        _title_btn.tag = i;
        
        // 计算内容的Size
        CGSize buttonSize = [self sizeWithText:_title_Arr[i] font:[UIFont systemFontOfSize:self.btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, button_H)];
        
        // 计算内容的宽度
        CGFloat button_W = 2 * self.btn_Margin + buttonSize.width;
        _title_btn.frame = CGRectMake(button_X, button_Y, button_W, button_H);
        
        [_title_btn setTitle:_title_Arr[i] forState:(UIControlStateNormal)];
        [_title_btn setTitleColor:self.titleColor forState:(UIControlStateNormal)];
        [_title_btn setTitleColor:self.titleSelectedColor forState:(UIControlStateSelected)];
        
        // 计算每个button的X值
        button_X = button_X + button_W;
        
        // 点击事件
        [_title_btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // 存入所有的title_btn
        [self.storageAlltitleBtn_mArr addObject:_title_btn];
        [self addSubview:_title_btn];
    }
    
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
    self.scrollViewWidth = scrollViewWidth;
    self.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);
    
    // 取出第一个子控件
    UIButton *firstButton = self.subviews.firstObject;
    if (scrollViewWidth < self.frame.size.width) {
        [self selectedBtnCenter:firstButton];
    }
    if (firstButton) {
        self.isFirstButton = YES;
    }
    
#pragma mark - - - 为文字缩放增加的代码
    if (self.isScaleText) {
        //        firstButton.titleLabel.font = [UIFont systemFontOfSize:btn_fondOfSize * btn_scale + btn_fondOfSize];
    }
    
    // 添加指示器
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = self.indicatorViewColor;
    self.indicatorView.frameHeight = self.indicatorViewHeight;
    self.indicatorView.frameY = self.frame.size.height - 2 * self.indicatorViewHeight;
    [self addSubview:self.indicatorView];
    
    // 指示器默认在第一个选中位置
    // 计算Titlebutton内容的Size
    CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:self.btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    
#pragma mark - - - 判断是否开启文字缩放功能
    if (self.isScaleText) {
        _indicatorView.frameWidth = buttonSize.width + self.btn_scale * buttonSize.width;
    } else {
        _indicatorView.frameWidth = buttonSize.width;
    }
    
    _indicatorView.centerX = firstButton.centerX;
}

#pragma mark - 按钮的点击事件

- (void)buttonAction:(UIButton *)sender {
    // 1、代理方法实现
    self.index = sender.tag;
    if ([self.delegate_TB respondsToSelector:@selector(FLY_TitlesBtnControlDefault:didSelectTitleAtIndex:)]) {
        [self.delegate_TB FLY_TitlesBtnControlDefault:self didSelectTitleAtIndex:self.index];
    }
    
    // 2、改变选中的button的位置
    [self selectedBtnLocation:sender];
}

- (void)updateScrollView {
    UIButton *btn = [self viewWithTag:self.index];
    [self selectedBtnCenter:btn];
}

/** 标题选中颜色改变以及指示器位置变化 */
- (void)selectedBtnLocation:(UIButton *)button {
    
    // 1、选中的button
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.indicatorViewTimeOfAnimation * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_temp_btn == nil) {
            button.selected = YES;
            _temp_btn = button;
        }else if (_temp_btn != nil && _temp_btn == button){
            button.selected = YES;
        }else if (_temp_btn != button && _temp_btn != nil){
            _temp_btn.selected = NO;
            button.selected = YES; _temp_btn = button;
        }
    });
    
    // 改变指示器位置
    [UIView animateWithDuration:self.indicatorViewTimeOfAnimation animations:^{
        // 计算内容的Size
        [UIView animateWithDuration:self.indicatorViewTimeOfAnimation animations:^{
            self.indicatorView.frameWidth = button.frameWidth - 2 * self.btn_Margin;
            self.indicatorView.centerX = button.centerX;
        }];
    }];
    
    // 3、滚动标题选中居中
    [self selectedBtnCenter:button];
}

/** 滚动标题选中居中 */
- (void)selectedBtnCenter:(UIButton *)centerBtn {
    // 计算偏移量
    CGFloat offsetX = centerBtn.center.x - self.frame.size.width * 0.5;
    
    if (offsetX < 0) offsetX = 0;
    
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.contentSize.width - self.frame.size.width;
    
    if (-maxOffsetX > self.scrollViewWidth && self.isLeftAligned) {
        return;
    }
    if (offsetX > maxOffsetX)
        offsetX = maxOffsetX;
    
    if (self.contentSize.width <= self.frame.size.width) {
        // 滚动标题滚动条
        [self setContentOffset:CGPointMake(offsetX/2, 0) animated:YES];
    } else {
        // 滚动标题滚动条
        [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView {
    // 1、计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 2、把对应的标题选中
    UIButton *selectedBtn = self.storageAlltitleBtn_mArr[index];
    
    // 3、滚动时，改变标题选中
    [self selectedBtnLocation:selectedBtn];
}

- (void)changeTheIndexOfTheSelectedBtn:(NSInteger)index {
    // 1、把对应的标题选中
    UIButton *selectedBtn = self.storageAlltitleBtn_mArr[index];
    
    // 2、滚动时，改变标题选中
    [self selectedBtnLocation:selectedBtn];
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
