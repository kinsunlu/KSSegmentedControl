//
//  KSMainView.h
//  KSSegmentedControl
//
//  Created by kinsun on 2018/8/10.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSSegmentedControl.h"

@interface KSMainView : UIView

@property (nonatomic, weak, readonly) KSSegmentedControl *segmented;
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

@end
