//
//  WWQRadarView.m
//  画圆描点
//
//  Created by SelenaWong on 16/6/29.
//  Copyright © 2016年 SelenaWong. All rights reserved.
//

#import "WWQRadarView.h"
#import "WWQRadarIndicatorView.h"
#import "WWQRadarPointView.h"
#import <CoreGraphics/CoreGraphics.h>


#define RADAR_DEFAULT_SECTIONS_NUM 0
#define INDICATOR_ANGLE 240.0
#define INDICATOR_CLOCKWISE YES
#define RADAR_ROTATE_SPEED 60.0f
#define RADAR_DEFAULT_RADIU (self.bounds.size.width-50)/2.f
#define INDICATOR_START_COLOR [UIColor colorWithRed:20.0/255.0 green:120.0/255.0 blue:40.0/255.0 alpha:1]
#define INDICATOR_END_COLOR [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0]

@interface WWQRadarView () <WWQRadarPointViewDelegate>
//默认圆的半径
@property (nonatomic, assign) CGFloat defaultRadiu;
@end

@implementation WWQRadarView

- (NSArray *)radius{
    if (!_radius) {
        _radius = [NSArray array];
    }
    return _radius;
}

- (void)setLabelText:(NSString *)labelText{
    _labelText = labelText;
    if (self.textLabel) {
        self.textLabel.text = labelText;
    }
}

- (instancetype)initWithFrame:(CGRect)frame radiusArr:(NSArray *)radiusArr{
    if (self == [super initWithFrame:frame]) {
        if (radiusArr &&radiusArr.count >0) {
            _radius = radiusArr;
        }
        [self setUI];
    }
    return self;
}

- (void)setUI{
    if (!self.indicatorView) {
        _indicatorView = [[WWQRadarIndicatorView alloc] initWithFrame:self.bounds];
        [self addSubview:_indicatorView];
    }
    
    if (!self.textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.center.y +30, self.bounds.size.width, 30)];
        [self addSubview:_textLabel];
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*背景图片*/
    if (self.backgroundImage) {
        UIImage *image = self.backgroundImage;
        [image drawInRect:self.bounds];
    }
    
    /*绘制圆圈个数*/
    NSInteger sectionsNum = RADAR_DEFAULT_SECTIONS_NUM;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInRadarView:)]) {
        sectionsNum = [self.dataSource numberOfSectionsInRadarView:self];
    }
    
    /*返回外部传进来半径数组的最大值*/
    CGFloat indicatorViewRadiu = 0.0;
    if (sectionsNum >RADAR_DEFAULT_SECTIONS_NUM) {//如果条件成立，则意味着self.radius.count>0
        indicatorViewRadiu = [[self.radius valueForKeyPath:@"@max.floatValue"] floatValue];
    }
    
    CGFloat indicatorAngle = INDICATOR_ANGLE;
    if (self.indicatorAngle) {
        indicatorAngle = self.indicatorAngle;
    }
    
    BOOL indicatorClockwise = INDICATOR_CLOCKWISE;
    if (self.indicatorClockwise) {
        indicatorClockwise = self.indicatorClockwise;
    }
    
    UIColor *indicatorStartColor = INDICATOR_START_COLOR;
    if (self.indicatorStartColor) {
        indicatorStartColor = self.indicatorStartColor;
    }
    
    UIColor *indicatorEndColor = INDICATOR_END_COLOR;
    if (self.indicatorEndColor) {
        indicatorEndColor = self.indicatorEndColor;
    }
    
    if (sectionsNum >0) {
        for (int i=0; i<sectionsNum; i++) {
            /*画圆*/
            //边框圆
            CGContextSetRGBStrokeColor(context, 1, 1, 1, (1-(float)i/(sectionsNum + 1))*0.5);//画笔线的颜色(透明度渐变)
            CGContextSetLineWidth(context, 1.0);//线的宽度
            //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
            // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
            CGContextAddArc(context, self.center.x, self.center.y, [self.radius[i] floatValue], 0, 2*M_PI, 0); //添加一个圆
            CGContextDrawPath(context, kCGPathStroke); //绘制路径
        }
    }else{
        CGContextSetRGBStrokeColor(context, 1, 1, 1, (sectionsNum+1)*0.5);//画笔线的颜色(透明度渐变)
        CGContextSetLineWidth(context, 1.0);//线的宽度
        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        CGContextAddArc(context, self.center.x, self.center.y, RADAR_DEFAULT_RADIU, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
    }
    
    if (self.indicatorView) {
        self.indicatorView.frame = self.bounds;
        self.indicatorView.backgroundColor = [UIColor clearColor];
        if (sectionsNum >0) {
            self.indicatorView.radius = indicatorViewRadiu;
        }else{
            self.indicatorView.radius = RADAR_DEFAULT_RADIU;
        }
        self.indicatorView.angle = indicatorAngle;
        self.indicatorView.clockwise = indicatorClockwise;
        self.indicatorView.startColor = indicatorStartColor;
        self.indicatorView.endColor = indicatorEndColor;
    }
    
    if (self.textLabel) {
        self.textLabel.frame = CGRectMake(0, self.center.y + ([UIScreen mainScreen].bounds.size.height)/3.3, rect.size.width, 30);
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        if (self.labelText) {
            self.textLabel.text = self.labelText;
        }
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self bringSubviewToFront:self.textLabel];
    }
}

#pragma mark - Actions
- (void)scan {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    BOOL indicatorClockwise = INDICATOR_CLOCKWISE;
    if (self.indicatorClockwise) {
        indicatorClockwise = self.indicatorClockwise;
    }
    rotationAnimation.toValue = [NSNumber numberWithFloat: (indicatorClockwise?1:-1) * M_PI * 2.0 ];
    rotationAnimation.duration = 360.f/RADAR_ROTATE_SPEED;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    [_indicatorView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stop {
    [_indicatorView.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)show{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[WWQRadarPointView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if ([self.dataSource respondsToSelector:@selector(numberOfPositionsInRadarView:)]) {
        //目标点的个数
        NSInteger pointNum = [self.dataSource numberOfPositionsInRadarView:self];
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInRadarView:)]) {//圆圈的个数
            NSInteger sectionNum = [self.dataSource numberOfSectionsInRadarView:self];
            if (sectionNum >0) {
                for (int i=0; i<pointNum; i++) {
                    if ([self.dataSource respondsToSelector:@selector(radarView:viewForIndex:)]) {
                        WWQRadarPointView *pointView = [[WWQRadarPointView alloc] initWithFrame:CGRectZero];
                        pointView.delegate = self;
                        pointView.tag = i;
                        pointView.backgroundColor = [UIColor clearColor];
                        UIImageView *imageView = [self.dataSource radarView:self viewForIndex:i];
                        [pointView addSubview:imageView];
                        int radiuIndex = arc4random()%self.radius.count;
                        //半径
                        int radiu = [self.radius[radiuIndex] intValue];
                        //半径的平方
                        int radiuSquare = radiu*radiu;
                        //x的平方
                        int positionXSquare = arc4random()%(radiuSquare);
                        //y的平方
                        int positionYSquare = radiuSquare - positionXSquare;
                        
                        double DX = sqrtf(positionXSquare);
                        NSLog(@"%.2f",DX);
                        
                        double DY = sqrtf(positionYSquare);
                        NSLog(@"%.2f",DY);
                        
                        int isPositiveOrNegativeX = arc4random()%2;
                        if (isPositiveOrNegativeX == 0) {
                            DX = -DX;
                        }
                        
                        int isPositiveOrNegativeY = arc4random()%2;
                        if (isPositiveOrNegativeY == 1) {
                            DY = -DY;
                        }
                        
                        pointView.bounds = imageView.bounds;
                        pointView.center = CGPointMake(self.center.x +DX, self.center.y +DY);
                        NSLog(@"pointCenter==%@",NSStringFromCGPoint(pointView.center));
                        NSLog(@"imageCenter==%@",NSStringFromCGPoint(imageView.center));

                        //动画
                        pointView.alpha = 0.0;
                        CGAffineTransform fromTransform =
                        CGAffineTransformScale(pointView.transform, 0.1, 0.1);
                        [pointView setTransform:fromTransform];
                        
                        CGAffineTransform toTransform = CGAffineTransformConcat(pointView.transform,  CGAffineTransformInvert(pointView.transform));
                        
                        double delayInSeconds = 0.05*i;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [UIView beginAnimations:nil context:NULL];
                            [UIView setAnimationDuration:0.3];
                            pointView.alpha = 1.0;
                            [pointView setTransform:toTransform];
                            [UIView commitAnimations];
                        });
                        
                        [self addSubview:pointView];
                    }
                }
            }
        }
    }
}

- (void)didSelectItemRadarPointView:(WWQRadarPointView *)radarPointView{
    if ([self.delegate respondsToSelector:@selector(radarView:didSelectedItemIndex:)]) {
        [self.delegate radarView:self didSelectedItemIndex:radarPointView.tag];
    }
}

@end
