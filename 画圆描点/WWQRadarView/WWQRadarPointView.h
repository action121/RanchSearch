//
//  XHRadarPointView.h
//  XHRadarView
//
//  Created by 邱星豪 on 14/10/27.
//  Copyright (c) 2014年 邱星豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WWQRadarPointView;
@protocol WWQRadarPointViewDelegate <NSObject>
@optional

- (void)didSelectItemRadarPointView:(WWQRadarPointView *)radarPointView; //点击事件

@end


@interface WWQRadarPointView : UIView

@property (nonatomic, assign) id <WWQRadarPointViewDelegate> delegate;        //委托

@end

