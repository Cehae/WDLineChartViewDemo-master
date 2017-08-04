# WDLineChartViewDemo-master 自定义折线图/柱状图

利用layer和核心动画封装的折线图/柱状图，网格间距颜色，折线类型，连接点形状等等都可以自定义，可以左右滚动，使用灵活方便，适合制作统计图。喜欢的请Star。

可自定义属性
```
// 线条类型
typedef NS_ENUM(NSInteger, WDLineChartType) {
WDLineChartType_Straight = 0, // 折线
WDLineChartType_Curve     // 曲线

};
// 点类型
typedef NS_ENUM(NSInteger, WDPointType) {
WDPointType_Rect = 0,         // 方形
WDPointType_Circel,       // 圆形
WDPointType_Ring         // 圆环
};

@interface WDLineChartView : UIView

//值设置
// x轴正方向的值
@property (nonatomic, strong) NSArray *xValues;

// x轴对应的y正方向的值
@property (nonatomic, strong) NSArray *yValues;


//UI设置 设置之后需要重新调用一下绘制方法
/***  网格颜色 默认为[UIColor grayColor]*/
@property (nonatomic, strong)  UIColor * gridColor;

/***  y轴颜色 默认为[UIColor blackColor]*/
@property (nonatomic, strong)  UIColor * yColor;

/***  x轴颜色 默认为[UIColor blackColor]*/
@property (nonatomic, strong)  UIColor * xColor;

/***  线颜色 默认为RGB(60, 160, 255)*/
@property (nonatomic, strong)  UIColor * lineColor;

/** 圆柱颜色 默认为RGB(60, 160, 255)*/
@property (nonatomic, strong)  UIColor * pillarColor;

/***  值颜色 默认为[UIColor blackColor]*/
@property (nonatomic, strong)  UIColor * valueColor;

/***  点颜色 默认为[UIColor redColor]*/
@property (nonatomic, strong)  UIColor * pointColor;


/** 是否显示网格 默认为YES */
@property (nonatomic,assign) BOOL showGrid;

/** 是否显示折线 默认为YES */
@property (nonatomic,assign) BOOL showFoldLine;

/** 是否显示圆柱 默认为YES */
@property (nonatomic,assign) BOOL showPillar;

/** 是否显示点 默认为YES*/
@property (nonatomic,assign) BOOL showPoint;

/** 是否显示值 默认为YES*/
@property (nonatomic,assign) BOOL showValues;

/** 是否需要动画 默认为YES*/
@property (nonatomic,assign) BOOL needAnimation;


/***  折线的类型*/
@property (nonatomic, assign) WDLineChartType  LineChartType;
/***  点的类型*/
@property (nonatomic, assign) WDPointType  pointType;

#pragma mark - 初始化
// 初始化折线图所在视图
+ (instancetype)lineChartViewWithFrame:(CGRect)frame;

#pragma mark - 绘制方法
// 绘制
- (void)drawChartView;
```

效果图：
![效果图](http://img.blog.csdn.net/20170804155433871?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvQ2VoYWU=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

喜欢的请star，如有问题请加我QQ1291349760，欢迎小伙伴交流。
地址：[GitHub](https://github.com/Cehae/WDLineChartViewDemo-master)
博客：[博客](http://blog.csdn.net/Cehae/article/details/76686986)

使用方法
```
#import "ViewController.h"
#import "WDLineChartView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *BGView;

/** <#annotation#> */
@property (nonatomic,weak) WDLineChartView * cView;

@end

@implementation ViewController

- (void)viewDidLoad {
[super viewDidLoad];

WDLineChartView * cView = [WDLineChartView lineChartViewWithFrame:CGRectMake(0,20,self.BGView.bounds.size.width,self.BGView.bounds.size.height-20)];
[self.BGView addSubview:cView];

self.cView = cView;

_cView.xValues = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,@31];

_cView.yValues = @[@903.09,@1000, @80, @400, @50, @130, @50, @75,@25, @100,@64,@95, @33,@100,@100,@100,@100,@500,@400,@1000, @80, @40, @50, @13, @50, @75,@25, @100,@64,@95, @33,@100,@100,@100,@100,@1000,@400];

}
-(void)viewDidAppear:(BOOL)animated
{
[super viewDidAppear:animated];
[self btnClick:nil];
}

- (IBAction)btnClick:(UIButton *)sender {

[_cView drawChartView];

}
- (IBAction)sw1:(UISwitch*)sender
{
switch (sender.tag) {
case 1000:
{
_cView.showGrid = sender.on;

}break;

case 1001:
{
_cView.showFoldLine = sender.on;

}break;

case 1002:
{
_cView.showPillar= sender.on;

}break;

case 1003:
{
_cView.showPoint= sender.on;

}break;

case 1004:
{
_cView.showValues= sender.on;

}break;

case 1005:
{
_cView.needAnimation= sender.on;

}break;

default:
{
}break;
}

[self btnClick:nil];

}
- (IBAction)sw2:(UISegmentedControl *)sender {


if (2000 == sender.tag)
{
_cView.LineChartType= sender.selectedSegmentIndex;

}else
{
_cView.pointType= sender.selectedSegmentIndex;
}

[self btnClick:nil];

}

@end

```


