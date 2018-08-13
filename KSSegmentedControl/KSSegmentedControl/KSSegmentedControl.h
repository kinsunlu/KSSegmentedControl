//
//  KSSegmentedControl.h
//  KSSegmentedControl
//
//  Created by kinsun on 2018/8/10.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSSegmentedControl : UIView

@property (nonatomic, strong, readonly) NSArray <NSString*>*items;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *highlightTextColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, copy) void (^didClickItem)(NSInteger index);

-(instancetype)initWithFrame:(CGRect)frame items:(NSArray<NSString*>*)items;
-(void)scrollViewDidScroll:(UIScrollView*)scrollView;

@end
