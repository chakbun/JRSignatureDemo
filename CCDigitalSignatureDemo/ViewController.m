//
//  ViewController.m
//  CCDigitalSignatureDemo
//
//  Created by cloudtech on 9/27/16.
//  Copyright © 2016 cloundCall. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+OHPDF.h"
#import "JRSignatureController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showImageView.image = [UIImage imageWithPDFNamed:@"myOrderPDF" fitInSize:self.showImageView.bounds.size];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2Signature:)];
    [self.showImageView addGestureRecognizer:tapGesture];
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.showImageView addGestureRecognizer:pinGesture];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.showImageView addGestureRecognizer:panGestureRecognizer];
    self.showImageView.userInteractionEnabled = YES;

    UIBarButtonItem *exportItem = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStyleDone target:self action:@selector(exportAction)];
    self.navigationItem.rightBarButtonItem = exportItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)exportAction {
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData(pdfData, self.showImageView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [ self.showImageView.layer renderInContext:pdfContext];
    UIGraphicsEndPDFContext();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSError *error;
    BOOL writeResult = [pdfData writeToFile:[NSString stringWithFormat:@"%@/%@",path,@"signatured.pdf"] options:NSDataWritingAtomic error:&error];
    NSLog(@"============ result:%d err:%@============",writeResult,error);
}

#pragma mark - Gesture Action


- (void)pinchGesture:(UIPinchGestureRecognizer *)pinGesture {
    NSLog(@"============ scale:%f velocity %f ============",pinGesture.scale, pinGesture.velocity);
    UIView *view = pinGesture.view;
    if (pinGesture.state == UIGestureRecognizerStateBegan || pinGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinGesture.scale, pinGesture.scale);
        pinGesture.scale = 1;
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture {
    UIView *view = panGesture.view;
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGesture setTranslation:CGPointZero inView:view.superview];
    }
}

- (void)go2Signature:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self.showImageView];
    JRSignatureController *signatureController = [[JRSignatureController alloc] init];
    __weak __typeof(self) weakSelf = self;
    
    signatureController.completedSignatureBlock = ^(UIImage *signatureImage) {
        CGFloat width = signatureImage.size.width * 100.0 / signatureImage.size.height;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
        imageView.center = touchPoint;
        imageView.image = signatureImage;
        [weakSelf.showImageView addSubview:imageView];
    };
    [self.navigationController pushViewController:signatureController animated:YES];
}


@end
