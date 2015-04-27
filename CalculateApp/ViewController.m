//
//  ViewController.m
//  Calculate field katushki
//
//  Created by Alex Tsiganov on 29.12.14.
//  Copyright (c) 2014 Alex Tsiganov. All rights reserved.
//

#import "ViewController.h"
#import "CorePlot-CocoaTouch.h"

#define graph_geometry_count 10
#define _x 0
#define _y 1

@interface ViewController() <CPTPlotDataSource>

@end

@implementation ViewController
{
    CPTGraphHostingView *hostView;
    CPTScatterPlot *graphs_of_geometry[graph_geometry_count];
    NSMutableArray *dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCorePlot];
}

-(void) viewWillAppear:(BOOL)animated
{
    [NSThread detachNewThreadSelector:@selector(asyncCalculateB) toTarget:self withObject:nil];
}

-(void) setConstraintsForHostView
{
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[hostView]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(hostView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[hostView]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(hostView)]];
}

-(void) initCorePlot
{
    hostView = [[CPTGraphHostingView alloc] init];
    [hostView setTranslatesAutoresizingMaskIntoConstraints:NO];
    hostView.allowPinchScaling = YES;
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    [graphsContainer addSubview:hostView];
    [self setConstraintsForHostView];
    hostView.hostedGraph = graph;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    CPTPlotRange *p1 = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(1)];
    //plotSpace.xRange = p1;
    [plotSpace setXScaleType:CPTScaleTypeLinear];
  //  plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(1)];
    
    for (int i=0; i< graph_geometry_count; i++)
    {
        graphs_of_geometry[i] = [[CPTScatterPlot alloc] initWithFrame:graph.frame];
        CPTMutableLineStyle *_lineStyle = [graphs_of_geometry[i].dataLineStyle mutableCopy];
        _lineStyle.lineWidth = 1.f;
        _lineStyle.lineColor = [CPTColor redColor];
        graphs_of_geometry[i].dataLineStyle = _lineStyle;
        graphs_of_geometry[i].dataSource = self;
        [graph addPlot:graphs_of_geometry[i]];
    }
    
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor blackColor];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    axisSet.xAxis.axisLineStyle = axisLineStyle;
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    x.minorTicksPerInterval = 10;
    axisSet.yAxis.minorTicksPerInterval = 10;
    axisSet.yAxis.axisLineStyle = axisLineStyle;
    axisSet.yAxis.labelingPolicy =CPTAxisLabelingPolicyAutomatic;
    graph.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    
    // 3 - Set up plot space
    //[plotSpace scaleToFitPlots:[NSArray arrayWithObjects:graph_01, graph_field_B0, graph_field_B_by_q1, /*graph_field_B_by_q2, nil]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1)];
    //plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(.3)];
    plotSpace.yRange = yRange;
    
    [graph reloadData];
}

-(float) scaleXOY
{
    if (CGRectGetWidth(graphsContainer.frame)>CGRectGetHeight(graphsContainer.frame))
        return CGRectGetWidth(graphsContainer.frame)/CGRectGetHeight(graphsContainer.frame);
    else
        return CGRectGetHeight(graphsContainer.frame)/CGRectGetWidth(graphsContainer.frame);
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    for (int i=0; i<graph_geometry_count; i++)
    {
        if (plot == graphs_of_geometry[i])
        {
            return dataSource.count;
        }
    }
    return 0;
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    for (int i=0; i<graph_geometry_count; i++)
    {
        if (plot == graphs_of_geometry[i])
        {
            if (fieldEnum == CPTScatterPlotFieldX)
                return dataSource[idx][_x];
            else
                return dataSource[idx][_y];
        }
    }
    return @(0);
}

-(void) asyncCalculateB
{
    [self asyncCalculateB1];
    return;
    dataSource = [NSMutableArray new];
    double m = 4*M_PI*pow(10, -7), g = 8.854187817*pow(10, -12), t = 0;
    m=1; g= 1;
    double a = 10, b = 10, i = 1, w = 100, R = 30;
    double x = 1, y = 1;
    
    while (t<50)
    {
        t+=0.01;
        double res = funcCalcFieldB(x, y, t, i, a, b, m, g, w, R);
        [dataSource addObject:@[@(t),@(res)]];
        NSLog(@"B(t=%f, x=%f, y=%f)=%f",t,x,y,res);
    }
    [graphs_of_geometry[0] reloadData];
}

-(void) asyncCalculateB1
{
    dataSource = [NSMutableArray new];
    double m = 4*M_PI*pow(10, -7), g = 8.854187817*pow(10, -12), t = 0;
    m=1; g= 1;
    double y=0;
    for (int sh=0; sh<graph_geometry_count; sh++)
    {
        dataSource = [NSMutableArray new];
        double a = 10, b = 10, i = 1, w = 100, R = 30;
        double x = 0;
        y+=1;
        while (x<10)
        {
            t=0.01;
            x+=0.1;
            double res = funcCalcFieldB(x, y, t, i, a, b, m, g, w, R);
            [dataSource addObject:@[@(x),@(res)]];
            NSLog(@"B(t=%f, x=%f, y=%f)=%f",t,x,y,res);
        }
        [graphs_of_geometry[sh] reloadData];
    }
}

double funcCalcFieldB(double x, double y, double t, float i, float a, float b, float m, float g, float w, float R)
{
    double result = 0;
    double A = 16*i*w*m/(M_PI*M_PI*2*M_PI*R);
    for (int k=1; k<100; k+=2)
    {
        for (int l=1; l<100; l+=2)
        {
            double sin1 = sin(k*M_PI*x/a);
            double sin2 = sin(l*M_PI*y/b);
            double e_step = -(M_PI*M_PI/(g*m))*(k*k/(a*a)+l*l/(b*b))*t;
            result+=1/(k*l)*sin1*sin2*pow(M_E, e_step);
        }
    }
    return result*A;
}


@end
