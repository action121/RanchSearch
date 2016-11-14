//
//  WWQRadarView.h
//  画圆描点
//
//  Created by SelenaWong on 16/6/29.
//  Copyright © 2016年 SelenaWong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WWQRadarIndicatorView;
@class WWQRadarView;

@protocol WWQRadarViewDelegate <NSObject>

@optional
- (void)radarView:(WWQRadarView *)radarView didSelectItemIndex:(NSInteger)index;

@end

@protocol WWQRadarViewDataSource <NSObject>

@optional
/**返回绘制圆圈个数*/
- (NSInteger)numberOfSectionsInRadarView:(WWQRadarView *)radarView;
/**返回目标点个数*/
- (NSInteger)numberOfPositionsInRadarView:(WWQRadarView *)radarView;
/**返回目标点视图*/
- (UIImageView *)radarView:(WWQRadarView *)radarView viewForIndex:(NSInteger)index;
@end

@interface WWQRadarView : UIView
/**绘制圆的半径数组*/
@property (nonatomic, strong) NSArray *radius;
/**渐变开始颜色*/
@property (nonatomic, strong) UIColor *indicatorStartColor;
/**渐变结束颜色*/
@property (nonatomic, strong) UIColor *indicatorEndColor;
/**指针渐变角度*/
@property (nonatomic, assign) CGFloat indicatorAngle;
/**是否顺时针*/
@property (nonatomic, assign) BOOL indicatorClockwise;
/**背景图片*/
@property (nonatomic, strong) UIImage *backgroundImage;
/**提示标签*/
@property (nonatomic, strong) UILabel *textLabel;
/**提示文字*/
@property (nonatomic,   copy) NSString *labelText;
/**扫描指针*/
@property (nonatomic, strong) WWQRadarIndicatorView *indicatorView;


@property (nonatomic, weak) id<WWQRadarViewDelegate> delegate;

@property (nonatomic, weak) id<WWQRadarViewDataSource> dataSource;

- (instancetype)initWithFrame:(CGRect)frame radiusArr:(NSArray *)radiusArr;
- (void)scan;
- (void)stop;
- (void)show;
@end
