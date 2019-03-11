//
//  UIView+FLYExtension.h
//  Dragon_LCS
//
//  Created by 乔布斯 on 2019/3/8.
//  Copyright © 2019年 乔布斯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (FLYExtension)

@property (nonatomic) CGFloat frameX;// ①x
@property (nonatomic) CGFloat frameY;// ②y
@property (nonatomic) CGFloat frameWidth;// width
@property (nonatomic) CGFloat frameHeight;// height
@property (nonatomic) CGFloat frameX_Width;// x + width(没有set方法)
@property (nonatomic) CGFloat frameY_Height;// y + height(没有set方法)

@property (nonatomic) CGFloat distance_right;// ③相对于父视图，距离右侧的距离
@property (nonatomic) CGFloat distance_bottom;// ④相对于父视图，距离底部的距离

@property (nonatomic) CGFloat centerX;// 中心点x
@property (nonatomic) CGFloat centerY;// 中心点y

@property (nonatomic) CGPoint origin;// origin
@property (nonatomic) CGSize size;// size

/**
 *  相对于①的set方法，同样是设置了x，但是这个方法的width也变了，而距离右侧的距离不变
 */
- (void)setFrameXWithRightUnchanged:(CGFloat)frameX;
/**
 *  相对于②的set方法，同样是设置了y，但是这个方法的height也变了，而距离底部的距离不变
 */
- (void)setFrameYWithBottomUnchanged:(CGFloat)frameY;
/**
 *  相对于③的set方法，同样是设置了距离右侧的距离，但是这个方法的width也变了，而x不变
 */
- (void)setDistance_rightWithFrameXUnchanged:(CGFloat)distance_right;
/**
 *  相对于④的set方法，同样是设置了距离底部的距离，但是这个方法的height也变了，而y不变
 */
- (void)setDistance_bottomWithFrameYUnchanged:(CGFloat)distance_bottom;

@end

NS_ASSUME_NONNULL_END
