//
//  KSSegmentedControl.m
//  KSSegmentedControl
//
//  Created by kinsun on 2018/8/10.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSSegmentedControl.h"

@interface KSSegmentedItemLayer : CATextLayer

@end

@implementation KSSegmentedItemLayer

-(instancetype)init {
    if (self = [super init]) {
        self.wrapped = YES;
        self.alignmentMode = kCAAlignmentCenter;
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

@end

@interface KSSegmentedControl () {
    CALayer *_highlightLayer;
    CAShapeLayer *_maskLayer;
    NSArray <KSSegmentedItemLayer*>* _normalTextLayerArray;
    NSArray <KSSegmentedItemLayer*>* _highlightTextLayerArray;
}

@end

@implementation KSSegmentedControl

-(instancetype)initWithFrame:(CGRect)frame items:(NSArray<NSString*>*)items {
    if (self = [super initWithFrame:frame]) {
        _items = items;
        [self __initView];
    }
    return self;
}

-(void)__initView {
    CALayer *layer = self.layer;
    layer.masksToBounds = YES;
    
    CALayer *highlightLayer = [CALayer layer];
    [layer addSublayer:highlightLayer];
    _highlightLayer = highlightLayer;
    
    NSMutableArray <KSSegmentedItemLayer*>* normalTextLayerArray = [NSMutableArray array];
    NSMutableArray <KSSegmentedItemLayer*>* highlightTextLayerArray = [NSMutableArray array];
    for (NSString *title in _items) {
        KSSegmentedItemLayer *normalTextLayer = [KSSegmentedItemLayer layer];
        normalTextLayer.string = title;
        [layer insertSublayer:normalTextLayer below:highlightLayer];
        [normalTextLayerArray addObject:normalTextLayer];
        
        KSSegmentedItemLayer *highlightTextLayer = [KSSegmentedItemLayer layer];
        highlightTextLayer.string = title;
        [highlightLayer addSublayer:highlightTextLayer];
        [highlightTextLayerArray addObject:highlightTextLayer];
    }
    _normalTextLayerArray = [NSArray arrayWithArray:normalTextLayerArray];
    _highlightTextLayerArray = [NSArray arrayWithArray:highlightTextLayerArray];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    highlightLayer.mask = maskLayer;
    _maskLayer = maskLayer;
    
    self.font = [UIFont systemFontOfSize:17.f];
    self.normalTextColor = [UIColor blueColor];
    self.highlightTextColor = [UIColor whiteColor];
    self.cornerRadius = 4.f;
}

-(void)layoutSublayersOfLayer:(CALayer *)layer {
    _highlightLayer.frame = layer.bounds;
    CGSize size = layer.bounds.size;
    NSUInteger count = _items.count;
    k_creatFrameElement;
    viewX=0.f;viewH=self.font.lineHeight;viewY=(size.height-viewH)*0.5f;viewW=size.width/count;
    for (NSUInteger i=0; i<count; i++) {
        KSSegmentedItemLayer *normalTextLayer = [_normalTextLayerArray objectAtIndex:i];
        KSSegmentedItemLayer *highlightTextLayer = [_highlightTextLayerArray objectAtIndex:i];
        CGRect rect = k_setFrame;
        normalTextLayer.frame = rect;
        highlightTextLayer.frame = rect;
        viewX=CGRectGetMaxX(rect);
    }
    
    CGFloat width=viewW, height = size.height, radius = _cornerRadius;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:(CGPoint){radius, radius} radius:radius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
    [path addArcWithCenter:(CGPoint){width-radius, radius} radius:radius startAngle:-M_PI_2 endAngle:0.f clockwise:YES];
    [path addArcWithCenter:(CGPoint){width-radius, height-radius} radius:radius startAngle:0.f endAngle:M_PI_2 clockwise:YES];
    [path addArcWithCenter:(CGPoint){radius, height-radius} radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path closePath];
    _maskLayer.path = path.CGPath;
}

-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    CGFloat s = x/scrollView.contentSize.width;
    CGFloat t = s*self.frame.size.width;
    CGRect rect = _maskLayer.frame;
    rect.origin.x = t;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _maskLayer.frame = rect;
    [CATransaction commit];
    
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = ceil((x-width*0.5f)/width);
    _selectedSegmentIndex = page;
}

-(void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    if (_selectedSegmentIndex != selectedSegmentIndex) {
        _selectedSegmentIndex = selectedSegmentIndex;
        CGRect rect = _maskLayer.frame;
        CGFloat t = self.frame.size.width/_items.count*selectedSegmentIndex;
        rect.origin.x = t;
        _maskLayer.frame = rect;
    }
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font {
    _font = font;
    CGFloat pointSize = font.pointSize;
    CFStringRef fontCFString = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontCFString);
    for (NSUInteger i=0; i<_items.count; i++) {
        KSSegmentedItemLayer *normalTextLayer = [_normalTextLayerArray objectAtIndex:i];
        normalTextLayer.font = fontRef;
        normalTextLayer.fontSize = pointSize;
        KSSegmentedItemLayer *highlightTextLayer = [_highlightTextLayerArray objectAtIndex:i];
        highlightTextLayer.font = fontRef;
        highlightTextLayer.fontSize = pointSize;
    }
    CGFontRelease(fontRef);
}

-(void)setNormalTextColor:(UIColor *)normalTextColor {
    _normalTextColor = normalTextColor;
    CGColorRef CGColor = normalTextColor.CGColor;
    for (KSSegmentedItemLayer *normalTextLayer in _normalTextLayerArray) {
        normalTextLayer.foregroundColor = CGColor;
    }
    _highlightLayer.backgroundColor = CGColor;
}

-(void)setHighlightTextColor:(UIColor *)highlightTextColor {
    _highlightTextColor = highlightTextColor;
    CGColorRef CGColor = highlightTextColor.CGColor;
    for (KSSegmentedItemLayer *highlightTextLayer in _highlightTextLayerArray) {
        highlightTextLayer.foregroundColor = CGColor;
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (_didClickItem) {
        UITouch *touch = touches.anyObject;
        CGPoint location = [touch locationInView:self];
        if (CGRectContainsPoint(self.bounds, location)) {
            NSInteger page = location.x/(self.frame.size.width/_items.count);
            _selectedSegmentIndex = page;
            _didClickItem(page);
        }
    }
}

@end
