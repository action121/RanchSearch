//
//  ViewController.m
//  画圆描点
//
//  Created by SelenaWong on 16/6/29.
//  Copyright © 2016年 SelenaWong. All rights reserved.
//

#import "ViewController.h"
#import "WWQRadarView.h"
#import "WWQRadarIndicatorView.h"

#define UIScreen_Width [UIScreen mainScreen].bounds.size.width
#define UIScreen_Height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<WWQRadarViewDelegate,WWQRadarViewDataSource>
@property (nonatomic, strong) WWQRadarView *radarView;
@property (nonatomic, strong) NSArray      *radiuArr;
@property (nonatomic, strong) UIButton     *searchBtn;
@property (nonatomic, assign) BOOL isFristInto;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFristInto = YES;
    self.radiuArr = @[@50,@100,@120,@150];
    [self addRadarView:self.radiuArr];
    [self addUserCenter];
    [self addScanBtn];
    [self startUpdatingRadar];
}

- (void)addScanBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, UIScreen_Height - 60, UIScreen_Width, 50);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"重新搜索" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reloadSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
    self.searchBtn = btn;
    self.searchBtn.hidden = YES;
}

- (void)addRadarView:(NSArray *)radiuArr{
    WWQRadarView *radarView = [[WWQRadarView alloc] initWithFrame:self.view.bounds radiusArr:radiuArr];
    radarView.dataSource = self;
    radarView.delegate = self;
    radarView.indicatorAngle = 200.f;
    radarView.indicatorClockwise = NO;
    radarView.backgroundColor = [UIColor colorWithRed:0.251 green:0.329 blue:0.490 alpha:1];
    radarView.backgroundImage = [UIImage imageNamed:@"radar_background"];
    radarView.labelText = @"正在搜索附近的目标";
    [self.view addSubview:radarView];
    [self.view sendSubviewToBack:radarView];
    //    [self.view.layer insertSublayer:radarView.layer atIndex:0];


    self.radarView = radarView;

    [self.radarView scan];
}

- (void)addUserCenter{
    UIImageView *user = [[UIImageView alloc] init];
    user.center = self.view.center;
    user.bounds = CGRectMake(0, 0, 50, 50);
    user.layer.cornerRadius = 25;
    user.layer.masksToBounds = YES;
    user.image = [UIImage imageNamed:@"user"];
    [self.view.layer insertSublayer:user.layer above:self.radarView.layer];
}

- (void)startUpdatingRadar {
    if (!self.isFristInto) {
        [self.searchBtn setTitle:@"正在搜索" forState:UIControlStateNormal];
        self.searchBtn.enabled = NO;
    }
    typeof(self) __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.radarView.labelText = [NSString stringWithFormat:@"搜索已完成，共找到%lu个目标",self.radiuArr.count*3];
        [weakSelf.radarView show];
        [weakSelf.radarView.indicatorView removeFromSuperview];
        if (!weakSelf.isFristInto) {
            weakSelf.searchBtn.hidden = NO;
            weakSelf.searchBtn.enabled = YES;
            [self.searchBtn setTitle:@"重新搜索" forState:UIControlStateNormal];
        }
        weakSelf.isFristInto = NO;
        weakSelf.searchBtn.hidden = NO;
    });
}

- (void)reloadSearch{
    if (self.radarView) {
        [self.radarView removeFromSuperview];
    }
    self.radiuArr = @[@50,@100,@150];
    [self addRadarView:self.radiuArr];
    [self startUpdatingRadar];
}

#pragma mark - WWQRadarViewDataSource
- (NSInteger)numberOfSectionsInRadarView:(WWQRadarView *)radarView{
    return self.radiuArr.count;
}

- (NSInteger)numberOfPositionsInRadarView:(WWQRadarView *)radarView{
    return self.radiuArr.count*3;
}

- (UIImageView *)radarView:(WWQRadarView *)radarView viewForIndex:(NSInteger)index{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point"]];
    imageView.frame = CGRectMake(0, 0, 20, 20);
    imageView.userInteractionEnabled = YES;
    return imageView;
}

- (void)radarView:(WWQRadarView *)radarView didSelectedItemIndex:(NSInteger)index{
    NSLog(@"点击了第%ld个目标",(long)index);
}


@end
