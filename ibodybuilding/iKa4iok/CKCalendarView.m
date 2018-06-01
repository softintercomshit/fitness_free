//
// Copyright (c) 2012 Jason Kozemczak
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//


#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKCalendarView.h"

#define BUTTON_MARGIN 0
#define CALENDAR_MARGIN 0
#define TOP_HEIGHT 100
#define DAYS_HEADER_HEIGHT 0
#define DEFAULT_CELL_WIDTH 43
#define CELL_BORDER_WIDTH 0

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@class CALayer;
@class CAGradientLayer;

@interface GradientView : UIView

@property(nonatomic, strong, readonly) CAGradientLayer *gradientLayer;
- (void)setColors:(NSArray *)colors;

@end

@implementation GradientView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

- (void)setColors:(NSArray *)colors {
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:( id)color.CGColor];
    }
    self.gradientLayer.colors = cgColors;
}


@end


@interface DateButton : UIButton

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) CKDateItem *dateItem;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) UIImageView *img;

@end

@implementation DateButton

- (void)setDate:(NSDate *)date {
    _date = [date retain];
    if (date) {
        NSDateComponents *comps = [self.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:date];
        [self setTitle:[NSString stringWithFormat:@"%d", comps.day] forState:UIControlStateNormal];
    } else {
        [self setTitle:@"" forState:UIControlStateNormal];
    }
    
}

@end

@implementation CKDateItem

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundColor = [UIColor clearColor];
        self.textColor = [UIColor darkGrayColor];
        self.selectedTextColor = [UIColor redColor];
        [self.markDayImage setFrame:CGRectMake(10, 20, 2, 2)];
        
    }
    return self;
}



@end

@interface CKCalendarView ()

@property(nonatomic, strong) UIView *highlight;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *prevButton;
@property(nonatomic, strong) UIButton *nextButton;
@property(nonatomic, strong) UIView *calendarContainer;
@property(nonatomic, strong) GradientView *daysHeader;
@property(nonatomic, strong) NSArray *dayOfWeekLabels;
@property(nonatomic, strong) NSMutableArray *dateButtons;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSDate *monthShowing;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, assign) CGFloat cellWidth;

@end

@implementation CKCalendarView

@dynamic locale;

- (id)init {
    return [self initWithStartDay:startSunday];
}

- (id)initWithStartDay:(CKCalendarStartDay)firstDay {
    return [self initWithStartDay:firstDay frame:CGRectMake(0, 0, 100, 100)];
}

- (void)_init:(CKCalendarStartDay)firstDay {
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [self.calendar setLocale:[NSLocale currentLocale]];
    
    self.cellWidth = DEFAULT_CELL_WIDTH;
    
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateFormatter.dateFormat = @"LLLL yyyy";
    
    self.calendarStartDay = firstDay;
    self.onlyShowCurrentMonth = YES;
    self.adaptHeightToNumberOfWeeksInMonth = YES;
    
    self.layer.cornerRadius = 6.0f;
    
    UIView *highlight = [[UIView alloc] initWithFrame:CGRectZero];
    highlight.backgroundColor = [UIColor clearColor];
    highlight.layer.cornerRadius = 6.0f;
    //    [self addSubview:highlight];
    self.highlight = highlight;
    
    // SET UP THE HEADER
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevButton setImage:[UIImage imageNamed:@"previous_calendar@2x.png"] forState:UIControlStateNormal];
    //    [prevButton setBackgroundColor:[UIColor blackColor]];
    //    prevButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [prevButton setFrame:CGRectMake(50, 70, 48, 38)];
    [prevButton addTarget:self action:@selector(_moveCalendarToPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:prevButton];
    self.prevButton = prevButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"next_calendar@2x.png"] forState:UIControlStateNormal];
    //    [nextButton setBackgroundColor:[UIColor blackColor]];
    [nextButton setFrame:CGRectMake(250, 70, 48, 38)];
    //    [nextButton setBackgroundColor:[UIColor grayColor]];
    //    nextButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    [nextButton addTarget:self action:@selector(_moveCalendarToNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
    self.nextButton = nextButton;
    
    // THE CALENDAR ITSELF
    UIView *calendarContainer = [[UIView alloc] initWithFrame:CGRectZero];
    //    calendarContainer.layer.borderWidth = 1.0f;
    //    calendarContainer.layer.borderColor = [UIColor blackColor].CGColor;
    calendarContainer.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    calendarContainer.layer.cornerRadius = 4.0f;
    calendarContainer.clipsToBounds = YES;
    [self addSubview:calendarContainer];
    self.calendarContainer = calendarContainer;
    
    GradientView *daysHeader = [[GradientView alloc] initWithFrame:CGRectZero];
    daysHeader.backgroundColor = [UIColor clearColor];
    daysHeader.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self.calendarContainer addSubview:daysHeader];
    self.daysHeader = daysHeader;
    
    NSMutableArray *labels = [NSMutableArray array];
    for (int i = 0; i < 7; ++i) {
        UILabel *dayOfWeekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dayOfWeekLabel.textAlignment = NSTextAlignmentCenter;
        dayOfWeekLabel.backgroundColor = [UIColor lightTextColor];
        dayOfWeekLabel.shadowColor = [UIColor clearColor];
        dayOfWeekLabel.shadowOffset = CGSizeMake(0, 1);
        [labels addObject:dayOfWeekLabel];
        [self.calendarContainer addSubview:dayOfWeekLabel];
    }
    self.dayOfWeekLabels = labels;
    [self _updateDayOfWeekLabels];
    
    // at most we'll need 42 buttons, so let's just bite the bullet and make them now...
    NSMutableArray *dateButtons = [NSMutableArray array];
    for (NSInteger i = 1; i <= 42; i++) {
        DateButton *dateButton = [DateButton buttonWithType:UIButtonTypeCustom];
        dateButton.calendar = self.calendar;
        [dateButton addTarget:self action:@selector(_dateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [dateButtons addObject:dateButton];
    }
    self.dateButtons = dateButtons;
    
    // initialize the thing
    self.monthShowing = [NSDate date];
    [self _setDefaultStyle];
    
    [self layoutSubviews]; // TODO: this is a hack to get the first month to show properly
}

- (id)initWithStartDay:(CKCalendarStartDay)firstDay frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _init:firstDay];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithStartDay:startSunday frame:frame];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init:startSunday];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"layout subviews");
    
    CGFloat containerWidth = self.bounds.size.width - (CALENDAR_MARGIN * 2);
    self.cellWidth = (floorf(containerWidth / 7.0+0.2)) - CELL_BORDER_WIDTH;
    
    NSInteger numberOfWeeksToShow = 6;
    if (self.adaptHeightToNumberOfWeeksInMonth) {
        numberOfWeeksToShow = [self _numberOfWeeksInMonthContainingDate:self.monthShowing];
    }
    CGFloat containerHeight = (numberOfWeeksToShow * (self.cellWidth + CELL_BORDER_WIDTH) + DAYS_HEADER_HEIGHT);
    
    CGRect newFrame = self.frame;
    newFrame.size.height = containerHeight + CALENDAR_MARGIN + TOP_HEIGHT;
    self.frame = newFrame;
    
    self.highlight.frame = CGRectMake(1, 1, self.bounds.size.width - 2, 1);
    
    self.titleLabel.text = [self.dateFormatter stringFromDate:_monthShowing];
    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, TOP_HEIGHT);
    self.prevButton.frame = CGRectMake(0, 35, 48, 38);
    self.nextButton.frame = CGRectMake(self.bounds.size.width - 47 - BUTTON_MARGIN, 35, 48, 38);
    
    self.calendarContainer.frame = CGRectMake(CALENDAR_MARGIN, CGRectGetMaxY(self.titleLabel.frame), containerWidth, containerHeight);
    self.daysHeader.frame = CGRectMake(0, 0, self.calendarContainer.frame.size.width-1, DAYS_HEADER_HEIGHT);
    
    CGRect lastDayFrame = CGRectZero;
    for (UILabel *dayLabel in self.dayOfWeekLabels) {
        dayLabel.frame = CGRectMake(CGRectGetMaxX(lastDayFrame) + CELL_BORDER_WIDTH, lastDayFrame.origin.y, self.cellWidth, self.daysHeader.frame.size.height);
        lastDayFrame = dayLabel.frame;
    }
    
    for (DateButton *dateButton in self.dateButtons) {
        dateButton.date = nil;
        [dateButton removeFromSuperview];
    }
//    NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
    NSDate *date = [[NSDate alloc] init];
    date = [self _firstDayOfMonthContainingDate:self.monthShowing];
    if (!self.onlyShowCurrentMonth) {
        while ([self _placeInWeekForDate:date] != 0) {
            date = [self _previousDay:date];
        }
    }
    NSDate *endDate = [[NSDate alloc] init];
    endDate = [self _firstDayOfNextMonthContainingDate:self.monthShowing];
    if (!self.onlyShowCurrentMonth) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setWeek:numberOfWeeksToShow];

        endDate = [self.calendar dateByAddingComponents:comps toDate:date options:0];
//        endDate = [date dateByAddingTimeInterval:60*60*24*7*comps.week];
        [comps release];
        
    }
    
    NSUInteger dateButtonPosition = 0;
    while ([date compare:endDate] == NSOrderedAscending) {
        
        DateButton *dateButton = [self.dateButtons objectAtIndex:dateButtonPosition];
        
        dateButton.date = date;
        CKDateItem *item = [[[CKDateItem alloc] init] autorelease];
        if ([self _dateIsToday:dateButton.date]) {
            item.textColor = [[UIColor redColor] autorelease];
            item.backgroundColor = [UIColor clearColor];
        } else if (!self.onlyShowCurrentMonth && [self _compareByMonth:date toDate:self.monthShowing] != NSOrderedSame) {
            item.textColor = [UIColor lightGrayColor];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(calendar:configureDateItem:forDate:)]) {
            [self.delegate calendar:self configureDateItem:item forDate:date];
        }
        [self.selectedDate retain];
        if (self.selectedDate && [self date:self.selectedDate isSameDayAsDate:date]) {
            [dateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            dateButton.backgroundColor = [UIColor clearColor];
        } else {
            [dateButton setTitleColor:item.textColor forState:UIControlStateNormal];
            dateButton.backgroundColor = item.backgroundColor;
        }
        [item.markDayImage setFrame:CGRectMake(35, 33, 4, 4)];
        for (int f = 0; f < [dateButton.subviews count]; f++) {
            if ([[dateButton.subviews objectAtIndex:f] isKindOfClass:[UIImageView class]])
                [[dateButton.subviews objectAtIndex:f] removeFromSuperview];
        }
        [dateButton addSubview:item.markDayImage];
        dateButton.frame = [self _calculateDayCellFrame:date];
        
        [self.calendarContainer addSubview:dateButton];
        
        date = [self _nextDay:date];
//        NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
//        [comps setDay:1];
//        NSDate *dat =[[[NSDate alloc] init] autorelease];
//        dat = date;
//        date = [self.calendar dateByAddingComponents:comps toDate:dat options:0];
//        date = [date dateByAddingTimeInterval:60*60*24];
       
        dateButtonPosition++;
        
        
    }
    NSLog(@"Retain count: %d", [date retainCount]);
//    //    if ([self.delegate respondsToSelector:@selector(calendar:didLayoutInRect:)]) {
//    //        [self.delegate calendar:self didLayoutInRect:self.frame];
//    //
//    //    }
    
}

- (NSDate *)_nextDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents new] autorelease];
    [comps setDay:1];
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [gregorian dateByAddingComponents:comps toDate:date options:0];
}

- (void)_updateDayOfWeekLabels {
//    NSArray *weekdays = [self.dateFormatter shortWeekdaySymbols];
//    // adjust array depending on which weekday should be first
//    NSUInteger firstWeekdayIndex = [self.calendar firstWeekday] - 1;
//    if (firstWeekdayIndex > 0) {
//        weekdays = [[weekdays subarrayWithRange:NSMakeRange(firstWeekdayIndex, 7 - firstWeekdayIndex)]
//                    arrayByAddingObjectsFromArray:[weekdays subarrayWithRange:NSMakeRange(0, firstWeekdayIndex)]];
//    }
//    
//    NSUInteger i = 0;
//    for (NSString *day in weekdays) {
//        [[self.dayOfWeekLabels objectAtIndex:i] setText:[day uppercaseString]];
//        i++;
//    }
}

- (void)setCalendarStartDay:(CKCalendarStartDay)calendarStartDay {
    _calendarStartDay = calendarStartDay;
    [self.calendar setFirstWeekday:self.calendarStartDay];
    [self _updateDayOfWeekLabels];
    [self setNeedsLayout];
}

- (void)setLocale:(NSLocale *)locale {
    [self.dateFormatter setLocale:locale];
    [self _updateDayOfWeekLabels];
    [self setNeedsLayout];
}

- (NSLocale *)locale {
    return self.dateFormatter.locale;
}

- (NSArray *)datesShowing {
    NSMutableArray *dates = [NSMutableArray array];
    // NOTE: these should already be in chronological order
    for (DateButton *dateButton in self.dateButtons) {
        if (dateButton.date) {
            [dates addObject:dateButton.date];
        }
    }
    return dates;
}

- (void)setMonthShowing:(NSDate *)aMonthShowing {
    _monthShowing = [[self _firstDayOfMonthContainingDate:aMonthShowing] retain];
    [self setNeedsLayout];
}

- (void)setOnlyShowCurrentMonth:(BOOL)onlyShowCurrentMonth {
    _onlyShowCurrentMonth = onlyShowCurrentMonth;
    [self setNeedsLayout];
}

- (void)setAdaptHeightToNumberOfWeeksInMonth:(BOOL)adaptHeightToNumberOfWeeksInMonth {
    _adaptHeightToNumberOfWeeksInMonth = adaptHeightToNumberOfWeeksInMonth;
    [self setNeedsLayout];
}

- (void)selectDate:(NSDate *)date makeVisible:(BOOL)visible {
    NSMutableArray *datesToReload = [NSMutableArray array];
    if (self.selectedDate) {
        [datesToReload addObject:self.selectedDate];
    }
    if (date) {
        [datesToReload addObject:date];
    }
    self.selectedDate = date;
    [self reloadDates:datesToReload];
    if (visible && date) {
        self.monthShowing = date;
    }
}

- (void)reloadData {
    self.selectedDate = nil;
    [self setNeedsLayout];
}

- (void)reloadDates:(NSArray *)dates {
    // TODO: only update the dates specified
    [self setNeedsLayout];
}

- (void)_setDefaultStyle {
    self.backgroundColor =[UIColor grayColor];
    [self setTitleColor:[UIColor colorWithRed:68/255 green:100/255 blue:143/255 alpha:1.0]];
    [self setTitleFont:[UIFont boldSystemFontOfSize:17.0]];
    
    [self setDayOfWeekFont:[UIFont boldSystemFontOfSize:12.0]];
    [self setDayOfWeekTextColor:[UIColor clearColor]];
    [self setDayOfWeekBottomColor:[UIColor clearColor] topColor:[UIColor clearColor]];
    
    [self setDateFont:[UIFont boldSystemFontOfSize:16.0f]];
    [self setDateBorderColor:UIColorFromRGB(0x556989)];
}

- (CGRect)_calculateDayCellFrame:(NSDate *)date {
    NSInteger numberOfDaysSinceBeginningOfThisMonth = [self _numberOfDaysFromDate:self.monthShowing toDate:date];
    NSInteger row = (numberOfDaysSinceBeginningOfThisMonth + [self _placeInWeekForDate:self.monthShowing]) / 7;
	
    NSInteger placeInWeek = [self _placeInWeekForDate:date];
    
    return CGRectMake(placeInWeek * (self.cellWidth + CELL_BORDER_WIDTH), (row * (38 + CELL_BORDER_WIDTH)) + CGRectGetMaxY(self.daysHeader.frame) + CELL_BORDER_WIDTH, self.cellWidth, 38);
    
}

- (void)_moveCalendarToNextMonth {
    NSDateComponents* comps = [[[NSDateComponents alloc] init] autorelease];
    [comps setMonth:1];
    NSDate *newMonth = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];
    if ([self.delegate respondsToSelector:@selector(calendar:willChangeToMonth:)] && ![self.delegate calendar:self willChangeToMonth:newMonth]) {
        return;
    } else {
        self.monthShowing = newMonth;
        if ([self.delegate respondsToSelector:@selector(calendar:didChangeToMonth:)] ) {
            [self.delegate calendar:self didChangeToMonth:self.monthShowing];
        }
    }
}

- (void)_moveCalendarToPreviousMonth {
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    NSDate *newMonth = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];
    if ([self.delegate respondsToSelector:@selector(calendar:willChangeToMonth:)] && ![self.delegate calendar:self willChangeToMonth:newMonth]) {
        return;
    } else {
        self.monthShowing = newMonth;
        if ([self.delegate respondsToSelector:@selector(calendar:didChangeToMonth:)] ) {
            [self.delegate calendar:self didChangeToMonth:self.monthShowing];
        }
    }
}

- (void)_dateButtonPressed:(id)sender {
    DateButton *dateButton = sender;
    NSDate *date = dateButton.date;
    if ([date isEqualToDate:self.selectedDate]) {
        // deselection..
        if ([self.delegate respondsToSelector:@selector(calendar:willDeselectDate:)] && ![self.delegate calendar:self willDeselectDate:date]) {
            return;
        }
        date = nil;
    } else if ([self.delegate respondsToSelector:@selector(calendar:willSelectDate:)] && ![self.delegate calendar:self willSelectDate:date]) {
        return;
    }
    
    [self selectDate:date makeVisible:YES];
    [self.delegate calendar:self didSelectDate:date];
    [self setNeedsLayout];
}

#pragma mark - Theming getters/setters

- (void)setTitleFont:(UIFont *)font {
    self.titleLabel.font = font;
}
- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (void)setTitleColor:(UIColor *)color {
    self.titleLabel.textColor = color;
}
- (UIColor *)titleColor {
    return self.titleLabel.textColor;
}

- (void)setMonthButtonColor:(UIColor *)color {
    //    [self.prevButton setImage:[UIImage imageNamed:@"previous_calendar@2x.png" ] forState:UIControlStateNormal];
    ////    [self.prevButton.imageView setFrame:self.prevButton.frame];
    ////    UIImageView *prevImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"previous_calendar@2x.png"]];
    ////    [prevImg setFrame:self.prevButton.frame];
    ////    [self.prevButton addSubview:prevImg];
    //    [self.nextButton setImage:[UIImage imageNamed:@"next_calendar@2x.png"] forState:UIControlStateNormal];
}

- (void)setInnerBorderColor:(UIColor *)color {
    self.calendarContainer.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void)setDayOfWeekFont:(UIFont *)font {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.font = font;
    }
}
- (UIFont *)dayOfWeekFont {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).font : nil;
}

- (void)setDayOfWeekTextColor:(UIColor *)color {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.textColor = color;
    }
}
- (UIColor *)dayOfWeekTextColor {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).textColor : nil;
}

- (void)setDayOfWeekBottomColor:(UIColor *)bottomColor topColor:(UIColor *)topColor {
    [self.daysHeader setColors:[NSArray arrayWithObjects:topColor, bottomColor, nil]];
}

- (void)setDateFont:(UIFont *)font {
    for (DateButton *dateButton in self.dateButtons) {
        dateButton.titleLabel.font = font;
    }
}
- (UIFont *)dateFont {
    return (self.dateButtons.count > 0) ? ((DateButton *)[self.dateButtons lastObject]).titleLabel.font : nil;
}

- (void)setDateBorderColor:(UIColor *)color {
    
    self.calendarContainer.backgroundColor = [UIColor clearColor];
}
- (UIColor *)dateBorderColor {
    return self.calendarContainer.backgroundColor;
}

#pragma mark - Calendar helpers

- (NSDate *)_firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    comps.day = 1;
    return [self.calendar dateFromComponents:comps];
}

- (NSDate *)_firstDayOfNextMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    comps.day = 1;
    comps.month = comps.month + 1;
    return [self.calendar dateFromComponents:comps];
}

- (BOOL)dateIsInCurrentMonth:(NSDate *)date {
    return ([self _compareByMonth:date toDate:self.monthShowing] == NSOrderedSame);
}

- (NSComparisonResult)_compareByMonth:(NSDate *)date toDate:(NSDate *)otherDate {
    NSDateComponents *day = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    NSDateComponents *day2 = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:otherDate];
    if (day.year < day2.year) {
        return NSOrderedAscending;
    } else if (day.year > day2.year) {
        return NSOrderedDescending;
    } else if (day.month < day2.month) {
        return NSOrderedAscending;
    } else if (day.month > day2.month) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSInteger)_placeInWeekForDate:(NSDate *)date {
    NSDateComponents *compsFirstDayInMonth = [self.calendar components:NSWeekdayCalendarUnit fromDate:date];
    return (compsFirstDayInMonth.weekday - 1 - self.calendar.firstWeekday + 8) % 7;
}

- (BOOL)_dateIsToday:(NSDate *)date {
    return [self date:[NSDate date] isSameDayAsDate:date];
}

- (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2 {
    // Both dates must be defined, or they're not the same
    if (date1 == nil || date2 == nil) {
        return NO;
    }
    
    NSDateComponents *day = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date1];
    NSDateComponents *day2 = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date2];
    return ([day2 day] == [day day] &&
            [day2 month] == [day month] &&
            [day2 year] == [day year] &&
            [day2 era] == [day era]);
}

- (NSInteger)_numberOfWeeksInMonthContainingDate:(NSDate *)date {
    return [self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}



- (NSDate *)_previousDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents new] autorelease];
    [comps setDay:-1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

- (NSInteger)_numberOfDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSInteger startDay = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:startDate];
    NSInteger endDay = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:endDate];
    return endDay - startDay;
}

+ (UIImage *)_imageNamed:(NSString *)name withColor:(UIColor *)color {
    UIImage *img = [UIImage imageNamed:name];
    UIGraphicsBeginImageContextWithOptions(img.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

@end