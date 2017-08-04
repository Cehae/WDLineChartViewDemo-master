//
//  WDLineChartView.m
//  WDLineChartDemo
//
//  Created by WD on 2017/6/2.
//  Copyright © 2017年 CFJ. All rights reserved.
//
//  地址：https://github.com/Cehae/WDLineChartViewDemo-master
//  博客：http://blog.csdn.net/Cehae/article/details/76686986
//
#import "WDLineChartView.h"

#define AngleToRad(angle) ((angle) / 180.0 * M_PI)

#define ColorFromBinary(rgb)   [UIColor colorWithRed:((rgb&0xff0000) >> 16)/255.0 green:((rgb&0xff00) >> 8)/255.0 blue:(rgb&0xff)/255.0 alpha:1.0]

#define RGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define RGB(r,g,b)     RGBA(r,g,b,1.0)

#define RandColor RGB(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))

#define AngleToRad(angle) ((angle) / 180.0 * M_PI)

@interface WDLineChartView()<CAAnimationDelegate>

/******下面的是需要设置的*****/

/**
 *  表格左边间距--左边文字宽度
 */
@property (nonatomic, assign) CGFloat  leftMargin;
/**
 *  表格右边间距
 */
@property (nonatomic, assign) CGFloat  rightMargin;
/**
 *  表格上面间距
 */
@property (nonatomic, assign) CGFloat  topMargin;
/**
 *  表格下面间距--X轴上面文字的高度
 */
@property (nonatomic, assign) CGFloat  bottomMargin;

/**
 *  Y轴的线的数量
 */
@property (nonatomic, assign) NSInteger yCount;
/**
 *  格子的宽度
 */
@property (nonatomic, assign) CGFloat  everyW;
/**
 *  圆柱的宽度
 */
@property (nonatomic, assign) CGFloat  pillarsW;



/******下面的是自己计算的******/

/**
 *  Y轴最大值
 */
@property (nonatomic, assign) CGFloat  maxY;

/**
 *  格子的高度
 */
@property (nonatomic, assign) CGFloat  everyH;

/**
 *  X轴的个数
 */
@property (nonatomic, assign) NSInteger xCount;



/**
 *  scrollView的内容宽度
 */
@property (nonatomic, assign) CGFloat  scrollContentW;

/**
 *  内容视图
 */
@property (strong, nonatomic) UIScrollView *bgView;

@end

@implementation WDLineChartView

// 初始化折线图所在视图
+ (instancetype)lineChartViewWithFrame:(CGRect)frame
{
    WDLineChartView *lineChartView = [[WDLineChartView alloc]initWithFrame:frame];
    return lineChartView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.bgView.scrollIndicatorInsets =  UIEdgeInsetsMake(0, 0, 0, 0);
        self.bgView.showsVerticalScrollIndicator = NO;
        self.bgView.showsHorizontalScrollIndicator = NO;
        self.bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        
        //圆柱宽度
        self.pillarsW = 10.0;
        
        //水平方向
        self.leftMargin = 32.0;
        self.rightMargin = 20.0;
        self.everyW = 50.0;
        
        //垂直方法
        self.yCount = 4.0;
        self.topMargin = 20.0;
        self.bottomMargin = 25;
        
        self.everyH = (frame.size.height - self.topMargin -self.bottomMargin) / self.yCount;

        //UI颜色设置
        [self setUpUIColor];
        
        //显示设置
        [self setUpUIShow];
    }
    return self;
}
#pragma mark - UI颜色设置
-(void)setUpUIColor
{
    self.gridColor = [UIColor grayColor];
    
    self.yColor = [UIColor blackColor];
    self.xColor = [UIColor blackColor];
    
    self.lineColor = RGB(60,160,255);
    self.pillarColor = RGB(60, 160, 255);
    
    self.valueColor = [UIColor blackColor];
    self.pointColor = [UIColor redColor];
}
#pragma mark - 显示设置
-(void)setUpUIShow
{
    self.showGrid = YES;
    self.showFoldLine = YES;
    self.showPillar = YES;
    self.showPoint = YES;
    self.showValues = YES;
    self.needAnimation = YES;
    
    self.LineChartType = 0;
    self.pointType = 0;
}

#pragma mark - 计算

- (void)doWithCalculate{
    if (!self.xValues || !self.xValues.count || !self.yValues || !self.yValues.count) {
        return;
    }
    // 移除多余的值，计算个数
    if (self.xValues.count > self.yValues.count) {
        NSMutableArray * xArr = [self.xValues mutableCopy];
        for (int i = 0; i < self.xValues.count - self.yValues.count; i++){
            [xArr removeLastObject];
        }
        self.xValues = [xArr mutableCopy];
    }else if (self.xValues.count < self.yValues.count){
        NSMutableArray * yArr = [self.yValues mutableCopy];
        for (int i = 0; i < self.yValues.count - self.xValues.count; i++){
            [yArr removeLastObject];
        }
        self.yValues = [yArr mutableCopy];
    }
    
    //x轴数量
    _xCount = (int)self.xValues.count;
    
    
    //计算scrollView的内容宽度
    _scrollContentW = _leftMargin + _everyW * _xCount + _rightMargin;
    
    self.bgView.contentSize = CGSizeMake(_scrollContentW,0);
    
    _maxY = CGFLOAT_MIN;
    for (int i = 0; i < _xCount; i ++) {
        if ([self.yValues[i] floatValue] > _maxY) {
            _maxY = [self.yValues[i] floatValue];
        }
    }
    
}


#pragma mark - 绘制
// 绘制折线图
-(void)drawChartView
{
    
    if (!self.xValues || !self.xValues.count || !self.yValues || !self.yValues.count) {
        return;
    }
    
    //删除数据
    //删除内容子layer
    for (CAShapeLayer *subLayer in [self.bgView.layer.sublayers copy])
    {
        [subLayer removeAllAnimations];
        [subLayer removeFromSuperlayer];
    }
    
    //删除内容子视图
    for (UIView * subView  in self.bgView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    //删除自己上面的子视图
    for (UIView * subView  in self.subviews)
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            continue;
        }
        
        [subView removeFromSuperview];
    }
    
    // 计算赋值
    [self doWithCalculate];
    
    
    //绘制
    // 画网格
    [self drawGrid];
    
    // 画xy轴上的值
    [self drawXYLabels];

    // 画折线
    [self drawFoldLine];

    // 画圆柱
    [self drawPillar];
    
    //动画结束后会画圆点和显示值,如果不需要动画,请在这里调用下面两个方法
    if (!self.showFoldLine||(self.showFoldLine && !self.needAnimation)) {
        // 画点
        [self drawPointsWithPointType:self.pointType];
        
        // 显示值
        [self drawValues];
    }
}
#pragma mark - 画网格
- (void)drawGrid{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 横线
    for (int i = 0; i <= _yCount; i ++) {
        
        CGFloat y = CGRectGetHeight(_bgView.frame) - _bottomMargin;
        
        [path moveToPoint:CGPointMake(_leftMargin ,y - _everyH * i)];
        
        [path addLineToPoint:CGPointMake(_scrollContentW - _rightMargin,y - _everyH * i)];
    }
    
    
    if (self.showGrid) {
    // 竖线
       for(int i = 0; i <= _xCount; i ++){
    
        [path moveToPoint:CGPointMake(_leftMargin + _everyW * i, CGRectGetHeight(self.bgView.frame) - _bottomMargin)];
                [path addLineToPoint:CGPointMake(_leftMargin + _everyW * i, _topMargin)];
        
       }
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = self.gridColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0.5;

    if (self.needAnimation) {
        [self addLayerAnimation:layer needDellegate:NO];
    }
    
    [self.bgView.layer addSublayer:layer];
}


#pragma mark - 添加XYlabel
- (void)drawXYLabels{
    
    //Y轴
    //背景view
    UIView *bgy = [[UIView alloc] initWithFrame:CGRectMake(0,0, _leftMargin-2, CGRectGetHeight(self.bgView.frame))];
    bgy.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgy];
    
    for(int i = 0; i <= _yCount; i ++)
    {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,(_topMargin-_everyH * 0.5)+i*_everyH, _leftMargin-2, _everyH)];
        
        lbl.backgroundColor = [UIColor clearColor];
        
        lbl.textColor = self.yColor;
        
        lbl.font = [UIFont systemFontOfSize:10];
        
        lbl.textAlignment = NSTextAlignmentRight;
        
        lbl.text = [NSString stringWithFormat:@"%d", (int)(_maxY / _yCount * (_yCount - i)) ];
        
        [self addSubview:lbl];
    }
    
    
    
    // X轴
    for(int i = 0; i < _xCount; i ++){
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(_leftMargin+_everyW*i, CGRectGetHeight(self.bgView.frame) - _bottomMargin, _everyW, _bottomMargin)];
        
        lbl.backgroundColor = [UIColor clearColor];
        
        lbl.textColor = self.xColor;
        
        lbl.font = [UIFont systemFontOfSize:12];
        
        lbl.textAlignment = NSTextAlignmentCenter;
        
        lbl.text = [NSString stringWithFormat:@"%@", self.xValues[i]];
        
        [self.bgView addSubview:lbl];//注意是添加到scrollView上
    }
    
}


#pragma mark - 画折线\曲线
- (void)drawFoldLine
{
    
    if (!self.showFoldLine) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat allH = CGRectGetHeight(_bgView.frame) - _topMargin - _bottomMargin;
    
    [path moveToPoint:CGPointMake(_leftMargin + _everyW*0.5, _topMargin + (1 - [self.yValues[0] floatValue] / _maxY) * allH)];
    
    
    
    switch (self.LineChartType) {
        case WDLineChartType_Straight:
        {
            for (int i = 1; i < _xCount; i ++) {
                [path addLineToPoint:CGPointMake(_leftMargin + _everyW*0.5 +_everyW * i, _topMargin + (1 - [self.yValues[i] floatValue] / _maxY) * allH)];
            }
        }break;
            
        case WDLineChartType_Curve:
        {
            for (int i = 1; i < _xCount; i ++) {
                
                CGPoint prePoint = CGPointMake(_leftMargin -_everyW*0.5+ _everyW * i, _topMargin + (1 - [self.yValues[i-1] floatValue] / _maxY) * allH);
                
                CGPoint nowPoint = CGPointMake(_leftMargin + _everyW*0.5 +_everyW * i, _topMargin + (1 - [self.yValues[i] floatValue] / _maxY) * allH);
                
                // 两个控制点的两个x中点为X值，preY、nowY为Y值；
                
                [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            }
        }break;
            
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    layer.path = path.CGPath;
    
    layer.strokeColor = self.lineColor.CGColor;//折线颜色
    
    layer.fillColor = [UIColor clearColor].CGColor;
    
    [self addLayerAnimation:layer needDellegate:self.needAnimation];
    
    [self.bgView.layer addSublayer:layer];
}


#pragma mark - 画柱状图
- (void)drawPillar{
    if (!self.showPillar) {
        return;
    }
    CGFloat allH = CGRectGetHeight(_bgView.frame) - _topMargin - _bottomMargin;
    
    for (int i = 0; i < _xCount; i ++) {
        
        CGPoint point = CGPointMake(_leftMargin + _everyW * (i + 1), _topMargin + (1 - [self.yValues[i] floatValue] / _maxY) * allH);
        
        CGRect rect = CGRectMake(point.x - _pillarsW / 2, point.y, _pillarsW, (CGRectGetHeight(self.bgView.frame) -  _bottomMargin - point.y));
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.strokeColor = [UIColor clearColor].CGColor;
        layer.fillColor = self.pillarColor.CGColor;
        [self.bgView.layer addSublayer:layer];
    }
}

#pragma mark - 画点
- (void)drawPointsWithPointType:(WDPointType)pointType{
    
    if (!self.showPoint) {
        return;
    }
    
    CGFloat allH = CGRectGetHeight(_bgView.frame) - _topMargin - _bottomMargin;
    
    // 画点
    switch (pointType) {
        case WDPointType_Rect:
        {
            for (int i = 0; i < _xCount; i ++) {
                CGPoint point = CGPointMake(_leftMargin + _everyW*0.5 +_everyW * i , _topMargin + (1 - [self.yValues[i] floatValue] / _maxY ) * allH);
                CAShapeLayer *layer = [[CAShapeLayer alloc] init];
                layer.frame = CGRectMake(point.x - 2.5, point.y - 2.5, 5, 5);
                layer.backgroundColor = self.pointColor.CGColor;
                [self.bgView.layer addSublayer:layer];
            }
        }break;
            
        case WDPointType_Circel:
        {
            for (int i = 0; i < _xCount; i ++) {
                CGPoint point = CGPointMake(_leftMargin + _everyW*0.5 +_everyW * i , _topMargin + (1 - [self.yValues[i] floatValue] / _maxY ) * allH);
                
                
                //方法1
                UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                
                //方法2
                //  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - 2.5, point.y - 2.5, 5, 5) cornerRadius:2.5];
                
                CAShapeLayer *layer = [CAShapeLayer layer];
                layer.path = path.CGPath;
                layer.strokeColor = self.pointColor.CGColor;
                layer.fillColor = self.pointColor.CGColor;
                [self.bgView.layer addSublayer:layer];
            }
            
        }break;
        case WDPointType_Ring:
        {
            for (int i = 0; i < _xCount; i ++) {
                
                CGPoint point = CGPointMake(_leftMargin + _everyW*0.5 +_everyW * i , _topMargin + (1 - [self.yValues[i] floatValue] / _maxY ) * allH);
                
                UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point
                                                                    radius:2.5
                                                                startAngle:0
                                                                  endAngle:2*M_PI
                                                                 clockwise:NO];
                CAShapeLayer *layer = [CAShapeLayer layer];
                layer.path = path.CGPath;
                layer.lineWidth = 1;
                layer.strokeColor = self.lineColor.CGColor;
                layer.fillColor = self.pointColor.CGColor;
                [self.bgView.layer addSublayer:layer];
            }
            
        }break;
    }
}

#pragma mark - 显示数据
- (void)drawValues{
    
    if (!self.showValues) {
        return;
    }
    CGFloat allH = CGRectGetHeight(_bgView.frame) - _topMargin - _bottomMargin;
    for (int i = 0; i < _xCount; i ++)
    {
        CGPoint point = CGPointMake(_leftMargin + _everyW*0.5 +_everyW * i , _topMargin + (1 - [self.yValues[i] floatValue] / _maxY) * allH);
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(point.x - _everyW/2.0-5, point.y - 20, _everyW+10, 20)];
        lbl.textColor = self.valueColor;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = [NSString stringWithFormat:@"%@",self.yValues[i]];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.adjustsFontSizeToFitWidth = YES;
        [self.bgView addSubview:lbl];
    }
}

#pragma mark - 添加动画
-(void)addLayerAnimation:(CAShapeLayer *)layer needDellegate:(BOOL)need
{
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (need)
    {
        basic.delegate = self;
    }
    basic.duration = 0.75;
    basic.fromValue = @(0);
    basic.toValue = @(1);
    basic.autoreverses = NO;
    basic.fillMode = kCAFillModeForwards;
    [layer addAnimation:basic forKey:nil];
}

#pragma mark - CABasicAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

    if (flag)
    {
        // 动画结束后 在这里显示点和值
        // 画点
        [self drawPointsWithPointType:self.pointType];
        
        // 显示值
        [self drawValues];
    }
}
@end
