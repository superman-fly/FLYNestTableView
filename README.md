# FLYNestTableView
ScrollView嵌套多个TableView

csdn博客：https://blog.csdn.net/feiyue0823/article/details/88412580

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
