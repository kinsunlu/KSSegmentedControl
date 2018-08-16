//
//  KSMainViewController.m
//  KSSegmentedControl
//
//  Created by kinsun on 2018/8/10.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSMainViewController.h"
#import "KSMainView.h"

@interface KSMainViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) KSMainView *view;

@end

@implementation KSMainViewController
@dynamic view;

-(void)loadView {
    [super loadView];
    KSMainView *view = [[KSMainView alloc]initWithFrame:self.view.frame];
    view.scrollView.delegate = self;
    view.segmented.selectedSegmentIndex = 2;
    self.view = view;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view.segmented scrollViewDidScroll:scrollView];
}

@end
