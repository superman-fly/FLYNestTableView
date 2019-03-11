//
//  FLYTopView.h
//  FLYNestTableView
//
//  Created by Fly on 2019/3/11.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYTopView : UIView

@property (nonatomic, assign) CGFloat contentSizeHeight;
@property (nonatomic, assign) CGFloat contentOffsetY;
-(void)renderUIWithInfo:(NSArray *)info Model:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END
