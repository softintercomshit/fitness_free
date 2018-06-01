//
//  GraphViewController.m
//  iBodybuilding-Update
//
//  Created by Gheorghe Onica on 8/17/13.
//  Copyright (c) 2013 com.softintercom. All rights reserved.
//

#import "GraphViewController.h"
#import "GuideAppDelegate.h"
#import "Exercise.h"
#import "Detail.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:1.0]

@interface GraphViewController ()
{
    int c;
}

@end

@implementation GraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.histTableView = [[UITableView alloc] init];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    c= 0;
    
    
    GuideAppDelegate* appDelegate = (GuideAppDelegate*)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    fetchArray = [appDelegate getAllexercises];

    [self arrayForExercise];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        {
            if (IS_HEIGHT_GTE_568)
            {
                perfView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, 340, 420)];
                perfGraph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 310, 300)];
                [self.histTableView setFrame:CGRectMake(0, 410, self.view.frame.size.width, 94)];
                [self.segmentedButtons setFrame:CGRectMake(self.segmentedButtons.frame.origin.x, 470, self.segmentedButtons.frame.size.width, self.segmentedButtons.frame.size.height)];
            }else{
                perfView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, 340, 365)];
                perfGraph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 310, 300)];
            }
    }else
        {
            if (IS_HEIGHT_GTE_568) {
                perfView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 50, 340, 450)];
                perfGraph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 310, 300)];
                [self.histTableView setFrame:CGRectMake(0, 470, self.view.frame.size.width, 50)];
                [self.segmentedButtons setFrame:CGRectMake(self.segmentedButtons.frame.origin.x, 530, self.segmentedButtons.frame.size.width, self.segmentedButtons.frame.size.height)];
            }else{
//                perfView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 50, 340, 365)];
//                perfGraph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 310, 300)];
                perfView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 50, 340, 365)];
                perfGraph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 310, 300)];
                [self.histTableView setFrame:CGRectMake(0, 390, self.view.frame.size.width, 138)];
                [self.segmentedButtons setFrame:CGRectMake(self.segmentedButtons.frame.origin.x, 450, self.segmentedButtons.frame.size.width, self.segmentedButtons.frame.size.height)];
               
            }
        }
    [self.segmentedButtons setTitle:NSLocalizedString(@"Weight", nil) forSegmentAtIndex:0 ];
    [self.segmentedButtons setTitle:NSLocalizedString(@"Repetitions", nil) forSegmentAtIndex:1 ];
    [self.segmentedButtons setTitle:NSLocalizedString(@"Performance", nil) forSegmentAtIndex:2 ];
    [self cretePlot];
    [self weightPlot];
    [self weightPlot];
    
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	return perfData.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSDecimalNumber *num = [[perfData objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    
	return num;
}

-(void)cretePlot
{
    
    [perfGraph applyTheme:nil];
    perfGraph.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    perfGraph.plotAreaFrame.paddingBottom = 40.0;
    perfGraph.plotAreaFrame.paddingLeft = 25.0;
    perfGraph.plotAreaFrame.masksToBorder = NO;
	perfView.hostedGraph = perfGraph;
	// Setup scatter plot space
//    perfView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] initWithFrame:perfGraph.bounds] autorelease];
    dataSourceLinePlot.identifier     = @"Data Source Plot";
    dataSourceLinePlot.dataSource     = self;
    dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
    CPTColor *areaColor;
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:[CPTColor whiteColor] endingColor:[CPTColor colorWithComponentRed:65 green:97 blue:142 alpha:0.5]];
    areaGradient.angle = -90.0f;
    CPTFill *areaGradientFill;
    
    areaColor                         = [CPTColor colorWithComponentRed:65.0/255 green:97.0/255 blue:142.0/255 alpha:0.5];
    CPTColor *areaColor2 = [CPTColor whiteColor];
    areaGradient                      = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor2];
    areaGradient.angle                = 270.0f;
    areaGradientFill                  = [CPTFill fillWithGradient:areaGradient];
    
    dataSourceLinePlot.areaFill2      = areaGradientFill;
    dataSourceLinePlot.areaBaseValue2 = CPTDecimalFromDouble(0.0);
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
	lineStyle.lineWidth				 = 2.0f;
	lineStyle.lineColor				 = [CPTColor colorWithComponentRed:113.0/255 green:133.0/255 blue:161.0/255 alpha:1];
    
	dataSourceLinePlot.dataLineStyle = lineStyle;
    
	dataSourceLinePlot.dataSource = self;
	[perfGraph addPlot:dataSourceLinePlot];
    [self.view insertSubview:perfView belowSubview:self.histTableView];
    
    oneDay = 24 * 60 * 60;
    [perfGraph.defaultPlotSpace setAllowsUserInteraction:NO ];
    perfView.allowPinchScaling = NO;
    NSDateFormatter *dateFormatter1 = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter1.dateStyle = kCFDateFormatterShortStyle;
    NSDate *refDate		  = [dateFormatter1 dateFromString:self.referencialDate];
	
    // Create graph from theme
    
    
    //
	// Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)perfGraph.axisSet;
	x		  = axisSet.xAxis;
    x.majorIntervalLength		  = CPTDecimalFromFloat(oneDay/2);
    //    x.minorTickLength = oneDay/2;
    x.majorTickLineStyle = nil;
	x.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0);
	x.minorTicksPerInterval		  = 0;
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    x.labelOffset = -2000;
    //    x.labelRotation = 1;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter.dateStyle = kCFDateFormatterShortStyle;
	CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
	timeFormatter.referenceDate = refDate;
    //    [dateFormatter release];
	x.labelFormatter			= timeFormatter;
    
	y = axisSet.yAxis;
    
	y.majorIntervalLength		  = CPTDecimalFromString(@"200");
    y.minorTickLength = 100;
	y.minorTicksPerInterval		  = 0;
	y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(-10);
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    //    y.tickDirection = CPTSignNegative;
    CPTMutableLineStyle *ymajorGridLineStyle = [CPTMutableLineStyle lineStyle];
    ymajorGridLineStyle.lineWidth = 0.5f;
    ymajorGridLineStyle.lineColor =[CPTColor colorWithComponentRed:162.0f/255.0f green:175.0f/255.0f blue:186.0f/255.0f alpha:1];
    //[CPTColor  colorWithComponentRed:113.0f/255.0f green:133.0f/255.0f blue:161.0f/255.0f alpha:1]; //[[CPTColor lightGrayColor] colorWithAlphaComponent:0.6f];
    CPTMutableLineStyle *xmajorGridLineStyle = [CPTMutableLineStyle lineStyle];
    xmajorGridLineStyle.lineWidth = 1.5f;
    xmajorGridLineStyle.lineColor =[CPTColor colorWithComponentRed:162.0f/255.0f green:175.0f/255.0f blue:186.0f/255.0f alpha:1]; //[[CPTColor lightGrayColor] colorWithAlphaComponent:0.6f];
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1.5f;
    axisLineStyle.lineColor =[CPTColor colorWithComponentRed:162.0f/255.0f green:175.0f/255.0f blue:186.0f/255.0f alpha:1];
    axisSet.xAxis.axisLineStyle = axisLineStyle;
    axisSet.yAxis.axisLineStyle = axisLineStyle;
    axisSet.xAxis.majorGridLineStyle = xmajorGridLineStyle;
    CPTMutableLineStyle *dottedStyle=[CPTMutableLineStyle lineStyle];
    dottedStyle.dashPattern=[NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:0.5],[NSDecimalNumber numberWithInt:2],nil];
    dottedStyle.patternPhase=1.0f;
    dottedStyle.lineColor =[CPTColor colorWithComponentRed:162.0f/255.0f green:175.0f/255.0f blue:186.0f/255.0f alpha:1];
    axisSet.yAxis.majorGridLineStyle = dottedStyle;

}



-(void)perfPlot
{
    [perfGraph reloadData];
    [perfData removeAllObjects];
    perfData = nil;
    [perfData release];
    perfData = [[NSMutableArray alloc] init];
    
//        NSMutableArray *newData = [NSMutableArray array];
	NSUInteger i;
    float max = 0;

    NSTimeInterval j = 0;
    NSTimeInterval k = 0;
    NSMutableSet *xAxisLabelSet = [[NSMutableSet alloc] init];
    NSMutableSet *xAxisSet = [[NSMutableSet alloc] init];

    NSArray *sortedArray = [exerciseArray sortedArrayUsingComparator: ^(Exercise *obj1, Exercise *obj2) {
        
        if ([obj1.date compare: obj2.date] == NSOrderedAscending) {
//            NSLog(@"1Eaerlier %@",obj1.date );
//            NSLog(@"1later    %@",obj2.date );
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1.date compare: obj2.date] == NSOrderedDescending) {
//            NSLog(@"2Eaerlier %@",obj2.date );
//            NSLog(@"2later    %@",obj1.date );
            return (NSComparisonResult)NSOrderedDescending;
            
        }
        return (NSComparisonResult)NSOrderedDescending;
    }];
//    NSLog(@"Sorted array: %d", [sortedArray count]);
    

	for ( i = 0; i < [sortedArray count]; i++ )
    {
        Exercise *exercise = (Exercise *)[sortedArray objectAtIndex:i];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateStyle = NSDateFormatterShortStyle;
        NSLocale *locale = [NSLocale currentLocale];
        [format setTimeZone:[NSTimeZone systemTimeZone]];
        [format setLocale:locale];
        NSString *exercDate = [format stringFromDate:exercise.date];
        [format release];
        
        if ([exercise.name isEqualToString:self.nameOfexercise])
            for (int v = 0; v < [[exercise.detail allObjects] count]; v++)
            {
                CPTMutableTextStyle *dataLabelTextStyle = [CPTMutableTextStyle textStyle];
                dataLabelTextStyle.color    = [CPTColor colorWithComponentRed:68.0f/255.0f green:100.0f/255.0f blue:143.0f/255.0f alpha:1];
                dataLabelTextStyle.fontSize = 12.0f;
                x.labelTextStyle = dataLabelTextStyle;
                CPTAxisLabel *label= [[[CPTAxisLabel alloc] initWithText:exercDate textStyle:x.labelTextStyle] autorelease];
                CPTLayer *imageLayer;
                if ([exercDate length] == 7){
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 43, 16)] autorelease];
                }else if ([exercDate length] == 8){
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 49, 16)] autorelease];

                }else if ([exercDate length] == 10) {
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 62, 16)] autorelease];
                } else{
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 38, 16)] autorelease];

                }
                
                UIImage *image = [UIImage imageNamed:@"bg_data_2.png"];

                y.labelTextStyle = dataLabelTextStyle;
                CALayer *imageSubLayer = [[[CALayer alloc] init] autorelease];
                imageSubLayer.frame = imageLayer.frame;
                imageSubLayer.contents = (id)image.CGImage;
                [imageLayer addSublayer:imageSubLayer];
                label.offset = 5;
                [label.contentLayer insertSublayer:imageLayer atIndex:-1];
                
                k= j+[[exercise.detail allObjects]count]-1;
                label.tickLocation = [[NSNumber numberWithInt:k*(oneDay/2) ] decimalValue];
                
                [xAxisSet addObject:@(k*(oneDay/2))];
                [xAxisLabelSet addObject:label];
                Detail *detail = (Detail*)[[exercise.detail allObjects] objectAtIndex:v];
                [dataArray addObject:detail];
            }
        NSArray *sortedArray1 = [dataArray sortedArrayUsingComparator: ^(id obj1, id obj2)
        {
            if ([[obj1 sort] integerValue] > [[obj2 sort] integerValue])
            {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([[obj1 sort] integerValue] < [[obj2 sort] integerValue])
            {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        [dataArray release];
        for (int v = 0; v < [sortedArray1 count]; v++)
        {
           
             NSTimeInterval x1 = j * (oneDay /2);
                j++;
                id y1;
            Detail *detail = (Detail *)[sortedArray1 objectAtIndex:v];
                if ([detail.weight intValue]== 0){
                y1			 = [detail reps];
                }else {
                y1			 = [NSNumber numberWithInt:[[detail reps] intValue] * [[detail weight] intValue] ];
                }
                
                if ([y1 intValue] > max){
                max= [y1 intValue];
                }
            
            NSMutableDictionary *tmpDict =[NSMutableDictionary dictionary];

            [tmpDict setObject:[NSDecimalNumber numberWithFloat:x1] forKey:[NSNumber numberWithInt:CPTScatterPlotFieldX]];
            [tmpDict setObject:y1 forKey:[NSNumber numberWithInt:CPTScatterPlotFieldY]];
            
//            tmpDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [NSDecimalNumber numberWithFloat:x1], [NSNumber numberWithInt:CPTScatterPlotFieldX],
//                                 y1, [NSNumber numberWithInt:CPTScatterPlotFieldY],
//                                 nil];
            [perfData addObject:tmpDict];
//            tmpDict = nil;
//            [tmpDict removeAllObjects];
//            [tmpDict release];
           
        }
    }
    float prevMax = max;
    if (max<100) {
        max = max/10;
    }else if((max >=100) && (max < 10000))
    {
        max = max /100;
    }else if (max >10000)
    {
        max = max / 1000;
    }
    max = round(max);
    if (prevMax<100) {
        max = max*10;
    }else if ((prevMax >=100) && (prevMax < 10000))
    {
        max = max *100;
    }else if (prevMax > 10000)
    {
        max = max * 1000;
    }
//    NSLog(@"MAX: %f", max);
    y.majorIntervalLength		  = CPTDecimalFromFloat(max/ 5) ;
    y.minorTickLength = max/5;
//       [perfGraph.defaultPlotSpace scaleToFitPlots:[perfGraph allPlots]];
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) perfGraph.defaultPlotSpace;
    CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(oneDay*k)];
    CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(max+5 )];
    plotSpace.globalXRange = globalXRange;
    plotSpace.globalYRange = globalYRange;
//    [perfGraph.defaultPlotSpace scaleToFitPlots:[perfGraph allPlots]];
    plotSpace.allowsUserInteraction = YES;
    
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat((k*(oneDay/2)) -(10*(oneDay/2)))length:CPTDecimalFromFloat(oneDay*5)];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(max+20)];
    perfGraph.plotAreaFrame.masksToBorder = NO;
    [x setAxisLabels:xAxisLabelSet];
 
    [xAxisLabelSet release];
    [x setMajorTickLocations:xAxisSet];
    [xAxisSet release];
//    [perfData release];
//	perfData = [[NSMutableArray alloc] initWithArray:newData];
    

}

-(void)repsPlot
{
    [perfGraph reloadData];
    [perfData removeAllObjects];
//    perfData = nil;
    [perfData release];
    perfData = [[NSMutableArray alloc] init];
    
    float max = 0;
    NSArray *sortedArray = [exerciseArray sortedArrayUsingComparator: ^(Exercise *obj1, Exercise *obj2) {
        
        if ([obj1.date compare: obj2.date] == NSOrderedAscending) {
//            NSLog(@"1Eaerlier %@",obj1.date );
//            NSLog(@"1later    %@",obj2.date );
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1.date compare: obj2.date] == NSOrderedDescending) {
//            NSLog(@"2Eaerlier %@",obj2.date );
//            NSLog(@"2later    %@",obj1.date );
            return (NSComparisonResult)NSOrderedDescending;
            
        }
        return (NSComparisonResult)NSOrderedDescending;
    }];
//    NSLog(@"Sorted array: %d", [sortedArray count]);
    
	
    // Create graph from theme
    
    
//        NSMutableArray *newData = [NSMutableArray array];
	NSUInteger i;
        NSTimeInterval j = 0;
    NSTimeInterval k = 0;
    NSMutableSet *xAxisLabelSet = [[NSMutableSet alloc] init];
    NSMutableSet *xAxisSet = [[NSMutableSet alloc] init];
	for ( i = 0; i < [sortedArray count]; i++ )
    {
        Exercise *exercise = (Exercise *)[sortedArray objectAtIndex:i];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateStyle = NSDateFormatterShortStyle;
        NSLocale *locale = [NSLocale currentLocale];
        [format setTimeZone:[NSTimeZone systemTimeZone]];
        [format setLocale:locale];
        NSString *exercDate = [format stringFromDate:exercise.date];
        [format release];
        
        if ([exercise.name isEqualToString:self.nameOfexercise])
            
            for (int v = 0; v < [[exercise.detail allObjects] count]; v++)
            {
//                NSLog(@"title: %@", self.nameOfexercise);
                CPTMutableTextStyle *dataLabelTextStyle = [CPTMutableTextStyle textStyle];
                dataLabelTextStyle.color    = [CPTColor colorWithComponentRed:68.0f/255.0f green:100.0f/255.0f blue:143.0f/255.0f alpha:1];
                dataLabelTextStyle.fontSize = 12.0f;
                x.labelTextStyle = dataLabelTextStyle;
                CPTAxisLabel *label= [[[CPTAxisLabel alloc] initWithText:exercDate textStyle:x.labelTextStyle] autorelease];
                CPTLayer *imageLayer;
                if ([exercDate length] == 7){
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 43, 16)] autorelease];
                }else if ([exercDate length] == 8){
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 49, 16)] autorelease];
                    
                }else if ([exercDate length] == 10) {
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 62, 16)] autorelease];
                } else{
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 38, 16)] autorelease];
                    
                }
      UIImage *image = [UIImage imageNamed:@"bg_data_2.png"];
                
                y.labelTextStyle = dataLabelTextStyle;
                CALayer *imageSubLayer = [[[CALayer alloc] init] autorelease];
                imageSubLayer.frame = imageLayer.frame;
                imageSubLayer.contents = (id)image.CGImage;
                [imageLayer addSublayer:imageSubLayer];
                label.offset = 5;
                [label.contentLayer insertSublayer:imageLayer atIndex:-1];
                
                k= j+[[exercise.detail allObjects]count]-1;
                label.tickLocation = [[NSNumber numberWithInt:k*(oneDay/2) ] decimalValue];
                [xAxisSet addObject:@(k*(oneDay/2))];
                [xAxisLabelSet addObject:label];
                Detail *detail = (Detail*)[[exercise.detail allObjects] objectAtIndex:v];
                [dataArray addObject:detail];
            }
        NSArray *sortedArray1 = [dataArray sortedArrayUsingComparator: ^(id obj1, id obj2)
                                 {
                                     if ([[obj1 sort] integerValue] > [[obj2 sort] integerValue])
                                     {
                                         return (NSComparisonResult)NSOrderedDescending;
                                     }
                                     
                                     if ([[obj1 sort] integerValue] < [[obj2 sort] integerValue])
                                     {
                                         return (NSComparisonResult)NSOrderedAscending;
                                     }
                                     return (NSComparisonResult)NSOrderedSame;
                                 }];
        [dataArray release];
//        NSLog(@"sorted aray 1 %@", sortedArray1);
        for (int v = 0; v < [sortedArray1 count]; v++)
        {
            NSTimeInterval x1 = j * (oneDay /2);
            j++;
            id y1;
            Detail *detail = (Detail *)[sortedArray1 objectAtIndex:v];
            y1			 = [detail reps];
            
            
            if ([y1 intValue] > max){
                max= [y1 intValue];
            }
            
            NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
            
            [tmpDict setObject:[NSDecimalNumber numberWithFloat:x1] forKey:[NSNumber numberWithInt:CPTScatterPlotFieldX]];
            [tmpDict setObject:y1 forKey:[NSNumber numberWithInt:CPTScatterPlotFieldY]];
            
            //            tmpDict = [NSDictionary dictionaryWithObjectsAndKeys:
            //                                 [NSDecimalNumber numberWithFloat:x1], [NSNumber numberWithInt:CPTScatterPlotFieldX],
            //                                 y1, [NSNumber numberWithInt:CPTScatterPlotFieldY],
            //                                 nil];
            [perfData addObject:tmpDict];
//            tmpDict = nil;
//            [tmpDict removeAllObjects];
//            [tmpDict release];
            
        }

    }
    float prevMax = max;
    if (max<100) {
        max = max/10;
    }else if((max >=100) && (max < 10000))
    {
        max = max /100;
    }else if (max >10000)
    {
        max = max / 1000;
    }
    max = round(max);
    if (prevMax<100) {
        max = max*10;
    }else if ((prevMax >=100) && (prevMax < 10000))
    {
        max = max *100;
    }else if (prevMax > 10000)
    {
        max = max * 1000;
    }
    y.majorIntervalLength		  = CPTDecimalFromFloat(max/ 5) ;
    y.minorTickLength = max/5;
    [perfGraph.defaultPlotSpace scaleToFitPlots:[perfGraph allPlots]];
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) perfGraph.defaultPlotSpace;
    CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(oneDay*k)];
    CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(max+5)];
    plotSpace.globalXRange = globalXRange;
    plotSpace.globalYRange = globalYRange;
    plotSpace.allowsUserInteraction = YES;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat((k*(oneDay/2)) -(10*(oneDay/2)))length:CPTDecimalFromFloat(oneDay*5)];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(max+20)];
    perfGraph.plotAreaFrame.masksToBorder = NO;
    [x setAxisLabels:xAxisLabelSet];
    [xAxisLabelSet release];
    [x setMajorTickLocations:xAxisSet];
    [xAxisSet release];
//    perfData = nil;
//    [perfData release];
//    perfData = [[NSMutableArray alloc] initWithArray:newData];
    
    
}


-(void)weightPlot
{
//    perfGraph = nil;
//    [perfGraph release];
//    perfGraph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
    [perfGraph reloadData];
    [perfData removeAllObjects];
//    perfData = nil;
    [perfData release];
    perfData = [[NSMutableArray alloc] init];
//        NSMutableArray *newData = [NSMutableArray array];
	NSUInteger i;
    float max = 0;
    NSArray *sortedArray = [exerciseArray sortedArrayUsingComparator: ^(Exercise *obj1, Exercise *obj2) {
        
        if ([obj1.date compare: obj2.date] == NSOrderedAscending) {
//            NSLog(@"1Eaerlier %@",obj1.date );
//            NSLog(@"1later    %@",obj2.date );
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1.date compare: obj2.date] == NSOrderedDescending) {
//            NSLog(@"2Eaerlier %@",obj2.date );
//            NSLog(@"2later    %@",obj1.date );
            return (NSComparisonResult)NSOrderedDescending;
            
        }
        return (NSComparisonResult)NSOrderedDescending;
    }];
//    NSLog(@"Sorted array: %d", [sortedArray count]);
    
    NSTimeInterval j = 0;
    NSTimeInterval k = 0;
    x.labelOffset = 2;
    NSMutableSet *xAxisLabelSet = [[NSMutableSet alloc] init];
    NSMutableSet *xAxisSet = [[NSMutableSet alloc] init];
	for ( i = 0; i < [sortedArray count]; i++ )
    {
        Exercise *exercise = (Exercise *)[sortedArray objectAtIndex:i];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateStyle = NSDateFormatterShortStyle;
        NSLocale *locale = [NSLocale currentLocale];
        [format setTimeZone:[NSTimeZone systemTimeZone]];
        [format setLocale:locale];
        NSString *exercDate = [format stringFromDate:exercise.date];
        [format release];
        
        if ([exercise.name isEqualToString:self.nameOfexercise])
            for (int v = 0; v < [[exercise.detail allObjects] count]; v++)
            {
                CPTMutableTextStyle *dataLabelTextStyle = [CPTMutableTextStyle textStyle];
                dataLabelTextStyle.color    = [CPTColor colorWithComponentRed:68.0f/255.0f green:100.0f/255.0f blue:143.0f/255.0f alpha:1];
                dataLabelTextStyle.fontSize = 12.0f;
                x.labelTextStyle = dataLabelTextStyle;
                CPTAxisLabel *label= [[[CPTAxisLabel alloc] initWithText:exercDate textStyle:x.labelTextStyle] autorelease];
                CPTLayer *imageLayer;
                if ([exercDate length] == 7){
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 43, 16)] autorelease];
                }else if ([exercDate length] == 8){
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 49, 16)] autorelease];
                    
                }else if ([exercDate length] == 10) {
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 62, 16)] autorelease];
                } else{
                    imageLayer = [[[CPTLayer alloc] initWithFrame:CGRectMake(0 , 3, 38, 16)] autorelease];
                    
                }

                UIImage *image = [UIImage imageNamed:@"bg_data_2.png"];
                
                y.labelTextStyle = dataLabelTextStyle;
                CALayer *imageSubLayer = [[[CALayer alloc] init] autorelease];
                imageSubLayer.frame = imageLayer.frame;
                imageSubLayer.contents = (id)image.CGImage;
                [imageLayer addSublayer:imageSubLayer];
                label.offset = 5;
                [label.contentLayer insertSublayer:imageLayer atIndex:-1];
                
                k= j+[[exercise.detail allObjects]count]-1;
                label.tickLocation = [[NSNumber numberWithInt:k*(oneDay/2) ] decimalValue];
                [xAxisSet addObject:@(k*(oneDay/2))];
                [xAxisLabelSet addObject:label];
                Detail *detail = (Detail*)[[exercise.detail allObjects] objectAtIndex:v];
                [dataArray addObject:detail];            }
        
        NSArray *sortedArray1 = [dataArray sortedArrayUsingComparator: ^(id obj1, id obj2)
                                 {
                                     if ([[obj1 sort] integerValue] > [[obj2 sort] integerValue])
                                     {
                                         return (NSComparisonResult)NSOrderedDescending;
                                     }
                                     
                                     if ([[obj1 sort] integerValue] < [[obj2 sort] integerValue])
                                     {
                                         return (NSComparisonResult)NSOrderedAscending;
                                     }
                                     return (NSComparisonResult)NSOrderedSame;
                                 }];
        [dataArray release];
        
//        NSLog(@"Sorted array: %@", sortedArray1);

        for (int v = 0; v < [sortedArray1 count]; v++)
        {
            NSTimeInterval x1 = j * (oneDay /2);
            j++;
            id y1;
            Detail *detail = (Detail *)[sortedArray1 objectAtIndex:v];
            y1			 = [detail weight];
            
            
            if ([y1 intValue] > max){
                max= [y1 intValue];
            }
            NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
            
            [tmpDict setObject:[NSDecimalNumber numberWithFloat:x1] forKey:[NSNumber numberWithInt:CPTScatterPlotFieldX]];
            [tmpDict setObject:y1 forKey:[NSNumber numberWithInt:CPTScatterPlotFieldY]];

            [perfData addObject:tmpDict];
//            tmpDict = nil;
//            [tmpDict removeAllObjects];
//            [tmpDict release];
            
        }
    }
    float prevMax = max;
    if (max<100) {
        max = max/10;
    }else if((max >=100) && (max < 10000))
    {
        max = max /100;
    }else if (max >10000)
    {
        max = max / 1000;
    }
    max = round(max);
    if (prevMax<100) {
        max = max*10;
//         NSLog(@"PrevMax");
//        NSLog(@"1Max %f", max);
    }else if ((prevMax >=100) && (prevMax < 10000))
    {
        max = max *100;
//        NSLog(@"PrevMax %f", prevMax);
//        NSLog(@"2Max %f", max);
    }else if (prevMax > 10000)
    {
        max = max * 1000;
//        NSLog(@"PrevMax %f", prevMax);
//        NSLog(@"3Max %f", max);
    }
    if (max == 0){
        max = 100;
    }
    y.majorIntervalLength		  = CPTDecimalFromFloat(max/ 5) ;
    y.minorTickLength = max/5;

    [perfGraph.defaultPlotSpace scaleToFitPlots:[perfGraph allPlots]];
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) perfGraph.defaultPlotSpace;
    CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(oneDay*k)];
    CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(max+20)];
    plotSpace.globalXRange = globalXRange;
    plotSpace.globalYRange = globalYRange;
    plotSpace.allowsUserInteraction = YES;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat((k*(oneDay/2)) -(10*(oneDay/2)))length:CPTDecimalFromFloat(oneDay*5)];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(max+20)];
    perfGraph.plotAreaFrame.masksToBorder = NO;
    [x setAxisLabels:xAxisLabelSet];
    [xAxisLabelSet release];
//    NSLog(@"Axis labels set: %@", xAxisLabelSet);
    [x setMajorTickLocations:xAxisSet];
    [xAxisSet release];
//    perfData = nil;
//    [perfData release];
//	perfData = [[NSMutableArray alloc] initWithArray:newData];
    
}



-(IBAction)changeSeg{
	if(self.segmentedButtons.selectedSegmentIndex == 0){
		[self weightPlot];
        [perfGraph reloadData];
	}
	if(self.segmentedButtons.selectedSegmentIndex == 1){
        [self repsPlot];
        [perfGraph reloadData];
	}
    if(self.segmentedButtons.selectedSegmentIndex == 2){
        [self perfPlot];
        
        [perfGraph reloadData];
	}
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"exercise array count: %d", [exerciseArray count]);
    return [exerciseArray count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Cell for row");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }else
    {
        cell = nil;
        [cell release];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    UIImageView *cellView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"celula_grafic@2x.png"]];
    [cell setBackgroundView:cellView];
    UIScrollView *histScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 10, 240, 50)];
    NSArray *sortedArray = [exerciseArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([[obj1 date] compare: [obj2 date]]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if (![[obj1 date] compare: [obj2 date]]) {
                return (NSComparisonResult)NSOrderedAscending;
                
            }
            return (NSComparisonResult)NSOrderedAscending;
        }] ;
    
        Exercise *exercise = [sortedArray objectAtIndex:indexPath.row];
        c++;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateStyle:NSDateFormatterShortStyle];
        NSLocale *locale = [NSLocale currentLocale];
        [format setTimeZone:[NSTimeZone systemTimeZone]];
        [format setLocale:locale];
        NSString *exercDate = [format stringFromDate:exercise.date];
        [format release];
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 20, 65, 10)];
    [cellLabel setFont:[UIFont systemFontOfSize:12]];
    [cellLabel setTextColor:UIColorFromRGB(0x909090)];
    [cellLabel setBackgroundColor:[UIColor clearColor]];
    [cellLabel setText:exercDate];
    [cell.contentView addSubview:cellLabel];
    [cellLabel release];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int v = 0; v < [[exercise.detail allObjects] count]; v++) {
        Detail *detail = (Detail*)[[exercise.detail allObjects] objectAtIndex:v];
        [dataArray addObject:detail];
    }
    NSArray *sortedArray1 = [dataArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([[obj1 sort] integerValue] > [[obj2 sort] integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([[obj1 sort] integerValue] < [[obj2 sort] integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    dataArray = [sortedArray1 copy];
    for (int d = 0; d < [dataArray count]; d++)
    {
        if ([[dataArray objectAtIndex:d]reps] != nil)
        {
            UILabel *repsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50* d, 20, 40, 10)];
            [repsLabel setFont:[UIFont systemFontOfSize:13]];
            [repsLabel setBackgroundColor:[UIColor clearColor]];
            [repsLabel setTextColor:[UIColor lightGrayColor]];
            [repsLabel setText:[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:d]reps] ]];
            UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(50* d, 0, 40, 10)];
            [weightLabel setFont:[UIFont systemFontOfSize:13]];
            [weightLabel setBackgroundColor:[UIColor  clearColor]];
            [weightLabel setTextColor:[UIColor lightGrayColor]];
            [weightLabel setText:[NSString stringWithFormat:@"%@", [[dataArray objectAtIndex:d] weight]]];
            [histScroll addSubview:repsLabel];
            [histScroll addSubview:weightLabel];
            [weightLabel release];
            [repsLabel release];
            
        }
    }
    [histScroll setContentSize:CGSizeMake([dataArray count]* 50, 50)];
    [histScroll setUserInteractionEnabled:YES];
    [cell addSubview:histScroll];
    [histScroll release];
    [dataArray release];
//    cell.textLabel.text = @"Text";
//    NSLog(@"Cell textlabel: %@", cell.textLabel.text);
    cell.selectionStyle =UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)arrayForExercise
{
    NSArray *sortedArray = [fetchArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([[obj1 date] compare: [obj2 date]]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (![[obj1 date] compare: [obj2 date]]) {
            return (NSComparisonResult)NSOrderedAscending;
            
        }
        return (NSComparisonResult)NSOrderedDescending;
    }];
//    NSLog(@"Arra for exercse: %@", fetchArray);
    NSMutableArray *sortArr = [NSMutableArray array];
    exerciseArray = [[NSMutableArray alloc] init];
    for (NSManagedObject *product in sortedArray)
    {
        
        Exercise *exercise = (Exercise*)product;
//        NSLog(@"name for exercse: %@", exercise.name);
//        NSLog(@"name for exercse: %@", self.nameOfexercise);

        if ([exercise.name isEqualToString:self.nameOfexercise])
        {
            
            [sortArr addObject:exercise.date];
//            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
//            for (int v = 0; v < [[exercise.detail allObjects] count]; v++) {
//                Detail *detail = (Detail*)[[exercise.detail allObjects] objectAtIndex:v];
//                [dataArray addObject:detail];
//            }
//            NSArray *sortedArray1 = [dataArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
//                
//                if ([[obj1 sort] integerValue] > [[obj2 sort] integerValue]) {
//                    return (NSComparisonResult)NSOrderedDescending;
//                }
//                
//                if ([[obj1 sort] integerValue] < [[obj2 sort] integerValue]) {
//                    return (NSComparisonResult)NSOrderedAscending;
//                }
//                return (NSComparisonResult)NSOrderedSame;
//            }];
//            
//            [dataArray release];
////            [sortedArray release];
//            for (int d = 0; d < [sortedArray1 count]; d++)
//            {
//                if ([[sortedArray1 objectAtIndex:d]reps] != nil)
//                {
//                }
//                
//            }
            
        }
        
    }

    
    NSSet *datesSet2 = [[NSSet alloc] initWithArray:sortArr];
    sortArr = [[NSMutableArray alloc] initWithArray:[datesSet2 allObjects]];
    //    [auxDatesArr sortedArrayUsingSelector:@selector(compare:)];
    [sortArr sortUsingComparator:^NSComparisonResult(NSDate* obj1, NSDate* obj2){
        return [obj1 compare:obj2];
    }];
    NSLog(@"Aux dates Arry: %@", sortArr);

    

    for (int k = 0; k < [sortArr count]; k++)
    for (NSManagedObject *product in sortedArray) {
        Exercise *exercise = (Exercise*)product;
        NSLog(@"Date1 %@", exercise.date);
         NSLog(@"Date1 %@", [sortArr objectAtIndex:k]);
        if ([exercise.date isEqualToDate:[sortArr objectAtIndex:k]])
        {
            if ([exercise.name isEqualToString:self.nameOfexercise]) {
                NSLog(@"adding");
                [exerciseArray addObject:exercise];
            }
        }
    }
     NSLog(@"Aux dates Arry: %@", exerciseArray);
    [sortArr release];
    [datesSet2 release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_histTableView release];
    [perfData removeAllObjects];
    [perfData release];
    [perfGraph release];
    [perfView release];
    [exerciseArray release];
//    [fetchArray release];
    [_referencialDate release];
    [_nameOfexercise release];
    [_segmentedButtons release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setHistTableView:nil];
    exerciseArray = nil;
    [self setSegmentedButtons:nil];
    [super viewDidUnload];
}
@end
