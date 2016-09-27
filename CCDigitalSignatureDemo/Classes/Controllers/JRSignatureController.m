//
//  JRSignatureController.m
//  CCDigitalSignatureDemo
//
//  Created by cloudtech on 9/27/16.
//  Copyright © 2016 cloundCall. All rights reserved.
//

#import "JRSignatureController.h"
#import "LGBoardView.h"

@interface JRSignatureController ()

@property (nonatomic, strong) LGBoardView *boardView;

@end

@implementation JRSignatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.boardView = [[LGBoardView alloc] initWithFrame:self.view.frame];
    self.boardView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.boardView];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)doneButtonAction {
    if (self.completedSignatureBlock) {
        self.completedSignatureBlock([self.boardView exportImage]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
