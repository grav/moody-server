//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodInputViewController.h"
#import "MOOMoodInputView.h"
#import "MOOMoodInputViewModel.h"

@interface MOOMoodInputViewController ()

@property (nonatomic, strong) MOOMoodInputViewModel *viewModel;

@end

@implementation MOOMoodInputViewController {
    MOOMoodInputView *_mainView;
}

- (id)init {
    if (!(self = [super init])) return nil;

    self.viewModel = [MOOMoodInputViewModel new];

    return self;
}

- (void)loadView {
    self.view = self.mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBindings];
}

- (void)setupBindings {
    RACChannelTerminal *sliderTerminal = [self.mainView.slider rac_newValueChannelWithNilValue:@0];
    RACChannelTerminal *modelTerminal = RACChannelTo_(self, viewModel.moodValue, @0);
    [sliderTerminal subscribe:modelTerminal];
    [modelTerminal subscribe:sliderTerminal];

    RAC(self.view, backgroundColor) = RACObserve(self, viewModel.backgroundColor);
    RAC(self.mainView.moodImageView, image) = [RACObserve(self, viewModel.moodImage) distinctUntilChanged];
    [self rac_liftSelector:@selector(bounceMoodImage:) withSignals:RACObserve(self.mainView.moodImageView, image), nil];
}

- (void)bounceMoodImage:(id)_ {
    CGSize size = self.mainView.moodImageView.image.size;
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
    anim.springBounciness = 20;
    anim.springSpeed = 20;
    anim.fromValue = [NSValue valueWithCGSize:(CGSize){size.width-10.f, size.height-10.f}];
    anim.toValue = [NSValue valueWithCGSize:size];
    [self.mainView.moodImageView pop_addAnimation:anim forKey:@"bounce"];
}

#pragma mark - Lazy loading views

- (MOOMoodInputView *)mainView {
    if (!_mainView) {
        _mainView = [MOOMoodInputView new];
        _mainView.slider.minimumValue = -1;
        _mainView.slider.maximumValue = 1;
    }
    return _mainView;
}


@end