//
//  knobView.m
//  mooer
//
//  Created by Smile on 2018/3/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "knobView.h"

//传控件 取该控件宽高
#define MooVW(view) (view.frame.size.width)
#define MooVH(view) (view.frame.size.height)

@interface knobView ()
{
    CGPoint initialLocation;//初始点
    CGPoint changeLocation;//移动中的点
    CGFloat initialAngle;//初始角度
    CGFloat changeAngle;//移动中角度
    CGFloat currentAngle;//当前角度
    
    UILabel *titleLabel;
}
@property (nonatomic, strong) CAShapeLayer *processLayer;
@end

@implementation knobView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self InitializeUI];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    titleLabel.text = titleStr;
}
-(void)setMinValue:(float )minValue
{
    _minValue = minValue;
    return;
}
-(void)setMaxValue:(float )maxValue
{
    _maxValue = maxValue;
    return;
}
-(void)setInitialValue:(float )initialValue
{
    _initialValue = initialValue;
    return;
}
- (void)InitializeUI
{
    currentAngle = 0;
    _minValue = 0;
    
    titleLabel = [self Label:@""];
    titleLabel.frame = CGRectMake(0, 0, MooVW(self), 20);
    [self addSubview:titleLabel];
    
    UIImageView *baseImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0-15, 0, MooVW(self)+28, MooVH(self)-20+28)];
    baseImgView.image = [UIImage imageNamed:@"knob_base"];
    baseImgView.tag = 11;
    [self addSubview:baseImgView];
    
    UIImageView *pointerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, MooVW(self), MooVH(self)-20)];
    pointerImgView.image = [UIImage imageNamed:@"knob_pointer"];
    pointerImgView.userInteractionEnabled = YES;
    pointerImgView.tag = 1;
    [self addSubview:pointerImgView];
    
    //这个UIview是一个透明的 用来画外面圆弧形就是画在这个view上面
    UIView *dataView = [[UIView alloc]initWithFrame:CGRectMake(0,20,MooVW(self),MooVH(self)-20)];
    dataView.backgroundColor = [UIColor colorWithRed:1/123 green:1/23 blue:1/233 alpha:0.];
    dataView.transform = CGAffineTransformMakeRotation(90 *M_PI / 180.0);
    CGAffineTransform transform = dataView.transform;
    transform = CGAffineTransformScale(transform, 0,0);
    [self addSubview:dataView];
    [self addSubview:pointerImgView];
    
    //创建出CAShapeLayer
    self.processLayer = [CAShapeLayer layer];
    self.processLayer.frame = CGRectMake(0, 0,MooVW(self),MooVH(self)-20);
    self.processLayer.fillColor = [UIColor clearColor].CGColor;
    //设置线条的圆角，宽度和颜色
    self.processLayer.lineCap = kCALineCapRound;
    self.processLayer.lineWidth = 8;
    self.processLayer.strokeColor = [UIColor greenColor].CGColor;
    self.processLayer.strokeStart = 0.13;//外圈圆起点
    self.processLayer.strokeEnd = 0.131;//外圈圆终点
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0,MooVW(self),MooVH(self)-20)];
    self.processLayer.path = circlePath.CGPath;
    [dataView.layer addSublayer:self.processLayer];
    
    initialAngle = 0;
    changeAngle = 0;
    
    return;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

//监控手指操作
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event//点击
{
    UITouch *touch = [touches anyObject];
    initialLocation = [touch locationInView:self];
    initialAngle = changeAngle+initialAngle;
    if (initialAngle>270) {
        initialAngle = 270;
    }
    if (initialAngle<0) {
        initialAngle = 0;
    }
    return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event//移动中
{
    UITouch *touch = [touches anyObject];
    changeLocation = [touch locationInView:self];
    
    UIView *view = [touch view];
    if (view.tag == 1) {
        UIImageView *img = (UIImageView *)view;
        img.transform = CGAffineTransformMakeRotation(initialAngle *M_PI / 180.0);
        CGFloat Angle;
        if (changeLocation.y>initialLocation.y) {
            changeAngle = changeLocation.y - initialLocation.y;
            Angle = initialAngle+changeAngle;
            if (Angle>270) {
                Angle = 270;
            }
            self.processLayer.strokeEnd = Angle/360+0.131;
            img.transform = CGAffineTransformMakeRotation(Angle *M_PI / 180.0);
            
        }
        if (changeLocation.y<initialLocation.y) {
            changeAngle = changeLocation.y - initialLocation.y;
            Angle = initialAngle+changeAngle;
            if (Angle<0) {
                Angle = 0;
            }
            self.processLayer.strokeEnd = Angle/360+0.131;
            img.transform = CGAffineTransformMakeRotation(Angle *M_PI / 180.0);
            
        }
        
        CGAffineTransform transform = img.transform;
        transform = CGAffineTransformScale(transform, 0,0);//前面表示横向放大0，后边的表示纵向缩小0
        
    }
//    [self numericalData];//如果需要VC数值跟着变化，打开这个方法。
    
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event//结束
{
    [self numericalData];
    return;
}

//数据传回VC
- (void)numericalData
{
    currentAngle = changeAngle+initialAngle;
    if (currentAngle>270) {
        currentAngle = 270;
    }
    if (currentAngle<0) {
        currentAngle = 0;
    }
    CGFloat current = (_maxValue/270)*currentAngle;
    
    //代理传回VC
    [self.delegate knobViewDidDismiss:titleLabel.text data:current];
    return;
}

- (UILabel *)Label:(NSString *)title{
    
    UILabel *Label = [[UILabel alloc] init];
    Label.text = title;
    Label.textColor = [UIColor blackColor];
    Label.backgroundColor = [UIColor clearColor];
    Label.textAlignment = NSTextAlignmentCenter;
    Label.numberOfLines = 0;
    Label.adjustsFontSizeToFitWidth = YES;
    Label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    
    return Label;
}
@end
