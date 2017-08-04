//
//  WDLineChartView.h
//  WDLineChartViewDemo
//
//  Created by WD on 2017/6/2.
//  Copyright © 2017年 CFJ. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end
