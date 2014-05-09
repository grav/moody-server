//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodInputView.h"

@interface MOOMoodInputView ()

@end

@implementation MOOMoodInputView

- (id)init {
    if (!(self = [super init])) return nil;

    self.backgroundColor = [UIColor orangeColor];

    return self;
}

- (void)addSubviews {
    [self addSubview:self.slider];
}

- (void)defineLayout {
    [self.slider mas_updateConstraintsWithTopMarginRelativeToSuperview];
    [self.slider mas_updateConstraintsWithBottomMarginRelativeToSuperview];
    [self.slider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.slider.superview);
    }];
}


#pragma mark - Lazy loading views

- (UISlider *)slider {
    if (!_slider) {
        _slider = ({
            UISlider *slider = [UISlider new];
//            slider.minimumValue = -5;
//            slider.maximumValue = 5;
            slider.cas_styleClass = @"mood-input-slider";
            slider.transform = CGAffineTransformMakeRotation(-M_PI * 0.5f);
            slider;
        });
    }
    return _slider;
}


@end