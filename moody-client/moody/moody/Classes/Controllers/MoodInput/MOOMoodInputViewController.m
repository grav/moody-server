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
    RACChannelTerminal *modelTermnial = RACChannelTo_(self, viewModel.mood, @0);
    [sliderTerminal subscribe:modelTermnial];
    [modelTermnial subscribe:sliderTerminal];

    RAC(self.view, backgroundColor) = RACObserve(self, viewModel.backgroundColor);
}


#pragma mark - Lazy loading views

- (MOOMoodInputView *)mainView {
    if (!_mainView) {
        _mainView = [MOOMoodInputView new];
        _mainView.slider.minimumValue = kMinMoodValue;
        _mainView.slider.maximumValue = kMaxMoodValue;
    }
    return _mainView;
}


@end