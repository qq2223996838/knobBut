//
//  ViewController.m
//  knobBut
//
//  Created by Smile on 2018/3/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"
#import "knobView.h"

//传控件 取该控件宽高
#define MooVW(view) (view.frame.size.width)
#define MooVH(view) (view.frame.size.height)
//屏幕宽高
#define MooScreenWidth [[UIScreen mainScreen] bounds].size.width
#define MooScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<knobViewDelegate>
{
    UILabel * Label;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MooVW(self.view), MooVH(self.view))];
    bgImgView.image = [UIImage imageNamed:@"woodVcBg"];
    bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgImgView];
    
    Label  = [[UILabel alloc] initWithFrame:CGRectMake(0, MooScreenHeight-80, MooScreenWidth, 50)];
    Label.text=@"数据";
    Label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    Label.textColor = [UIColor blackColor];
    Label.textAlignment = NSTextAlignmentCenter;
    Label.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:Label];
    
    NSArray *Name = @[@"knobBut1",@"knobBut2",@"knobBut3",@"knobBut4",@"knobBut5",@"knobBut6"];
    for (int i = 0; i<Name.count; i++) {
        knobView * knobBut;
        if (i>2) {
            knobBut  = [[knobView alloc] initWithFrame:CGRectMake(MooScreenWidth-150, 50+(i-3)*(120+15), 100, 120)];
        }else{
            knobBut  = [[knobView alloc] initWithFrame:CGRectMake(50, 50+i*(120+15), 100, 120)];
        }
        
        knobBut.delegate = self;
        knobBut.titleStr = Name[i];
        knobBut.maxValue = 31;
        knobBut.minValue = 0;
        knobBut.initialValue = 0;
        [self.view addSubview:knobBut];
    }
}

#pragma mark - ChannelViewDelegate
- (void)knobViewDidDismiss:(NSString *)name data:(CGFloat )data;
{
    Label.text = [NSString stringWithFormat:@"选择%@旋钮 - 数值%.f",name,data];
    return;
}


@end
