//
//  FLYBaseScrollView.m
//  FLYNestTableView
//
//  Created by Fly on 2019/3/11.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FLYBaseScrollView.h"

@implementation FLYBaseScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
