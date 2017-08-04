//
//  ViewController.m
//  WDLineChartViewDemo
//
//  Created by apple on 2017/8/4.
//  Copyright © 2017年 apple. All rights reserved.
//

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
