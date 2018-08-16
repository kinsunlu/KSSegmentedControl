//
//  KSMainView.m
//  KSSegmentedControl
//
//  Created by kinsun on 2018/8/10.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSMainView.h"

@implementation KSMainView {
    __weak UIView *_topBar;
    __weak UIView *_line;
    NSArray <UILabel*>*_labels;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self __initView];
    }
    return self;
}

-(void)__initView {
    NSArray <NSString*>*items = @[@"列表", @"年历", @"月历", @"日历"];
    NSUInteger count = items.count;
    self.backgroundColor = [UIColor whiteColor];
    CGRect bounds = self.bounds;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:bounds];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = (CGSize){bounds.size.width*count, 0.f};
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UIColor *color = [UIColor colorWithRed:255.f/255.f green:111.f/255.f  blue:111.f/255.f  alpha:1.f];
    
    NSMutableArray <UILabel*>*labels = [NSMutableArray array];
    for (NSUInteger i=0; i<count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont boldSystemFontOfSize:280.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = color;
        label.text = [NSNumber numberWithUnsignedInteger:i+1].stringValue;
        [scrollView addSubview:label];
        [labels addObject:label];
    }
    _labels = [NSArray arrayWithArray:labels];
    
    UIView *topBar = [[UIView alloc]init];
    topBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:topBar];
    _topBar = topBar;
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:220.f/255.f green:220.f/255.f  blue:220.f/255.f  alpha:1.f];
    [topBar addSubview:line];
    _line = line;
    
    KSSegmentedControl *segmented = [[KSSegmentedControl alloc]initWithFrame:CGRectZero items:items];
    segmented.normalTextColor = color;
    segmented.cornerRadius = 6.f;
    __weak typeof(self) weakSelf = self;
    [segmented setDidClickItem:^(NSInteger index, BOOL isAnimation) {
        UIScrollView *k_scrollView = weakSelf.scrollView;
        [k_scrollView setContentOffset:(CGPoint){k_scrollView.frame.size.width*index,0.f} animated:isAnimation];
    }];
    [topBar addSubview:segmented];
    _segmented = segmented;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger count = _labels.count;
    CGRect bounds = self.bounds;
    CGFloat windowWidth = bounds.size.width,
    statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    _scrollView.frame = bounds;
    _scrollView.contentSize = (CGSize){windowWidth*count, 0.f};
    
    k_creatFrameElement;
    viewW = windowWidth;viewH=bounds.size.height;
    for (NSUInteger i=0; i<count; i++) {
        viewX=i*viewW;
        UILabel *label = [_labels objectAtIndex:i];
        k_settingFrame(label);
    }
    
    viewX = viewY = 0.f;
    viewH=statusBarHeight+44.f;
    viewW=windowWidth;
    k_settingFrame(_topBar);
    
    viewW=66.5f*count;viewH=38.f;viewX=(windowWidth-viewW)*0.5f;viewY=statusBarHeight+(44.f-viewH)*0.5f;
    k_settingFrame(_segmented);
    
    viewW=windowWidth;viewH=0.5f;viewX=0.f;viewY=_topBar.frame.size.height-viewH;
    k_settingFrame(_line);
}

@end
