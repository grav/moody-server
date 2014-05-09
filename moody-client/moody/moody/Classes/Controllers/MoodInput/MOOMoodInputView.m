//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodInputView.h"
#import "resource_images.h"

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
    [self addSubview:self.moodImageView];
}

- (void)defineLayout {
    [self.moodImageView mas_updateConstraintsWithTopMarginRelativeToSuperview];
    [self.moodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.moodImageView.superview);
    }];

    [self.slider mas_updateConstraintsWithTopMarginRelativeTo:self.moodImageView.mas_bottom];
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
            slider.cas_styleClass = @"mood-input-slider";
            slider.transform = CGAffineTransformMakeRotation((CGFloat) (-M_PI * 0.5f));
            slider;
        });
    }
    return _slider;
}

- (UIImageView *)moodImageView {
    if (!_moodImageView) {
        _moodImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:kImgMoodMedium];
            imageView.cas_styleClass = @"mood-input-image-view";
            imageView;
        });
    }
    return _moodImageView;
}


@end