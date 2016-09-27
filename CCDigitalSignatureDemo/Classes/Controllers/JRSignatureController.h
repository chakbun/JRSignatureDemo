//
//  JRSignatureController.h
//  CCDigitalSignatureDemo
//
//  Created by cloudtech on 9/27/16.
//  Copyright © 2016 cloundCall. All rights reserved.
//

#import "CCBaseController.h"

@interface JRSignatureController : CCBaseController

@property (nonatomic, strong) void(^completedSignatureBlock)(UIImage *signature);

@end
