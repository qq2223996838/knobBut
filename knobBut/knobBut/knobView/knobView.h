//
//  knobView.h
//  mooer
//
//  Created by Smile on 2018/3/14.
//  Copyright © 2018年 mac. All rights reserved.
//
/*
    最好初始化的高度 要比宽度高20 因为标题Label高度占了20
    否则旋转就不是圆形啦，是椭圆。
 */
#import <UIKit/UIKit.h>
@class knobView;

@protocol knobViewDelegate <NSObject>
@optional
- (void)knobViewDidDismiss:(NSString *)name data:(CGFloat )data;//传回数值和tag

@end

@interface knobView : UIView

@property (nonatomic, weak) id<knobViewDelegate> delegate;

//旋钮标题
@property (nonatomic, strong) NSString *titleStr;
//旋钮数值最小值
@property (nonatomic, assign) float minValue;
//旋钮数值最大值
@property (nonatomic, assign) float maxValue;
//旋钮默认值
@property (nonatomic, assign) float initialValue;

@end
