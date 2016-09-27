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
@property (nonatomic, assign) BOOL haveSignature;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.haveSignature = NO;
    self.showImageView.image = [UIImage imageWithPDFNamed:@"myOrderPDF" fitInSize:self.showImageView.bounds.size];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2Signature)];
    [self.view addGestureRecognizer:tapGesture];
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
//    BOOL writeResult = [pdfData writeToFile:@"/signatured.pdf" atomically:YES];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSError *error;
    BOOL writeResult = [pdfData writeToFile:[NSString stringWithFormat:@"%@/%@",path,@"signatured.pdf"] options:NSDataWritingAtomic error:&error];
    NSLog(@"============ result:%d err:%@============",writeResult,error);

}

- (void)go2Signature {
    if (!self.haveSignature) {
        JRSignatureController *signatureController = [[JRSignatureController alloc] init];
        __weak __typeof(self) weakSelf = self;
        
        signatureController.completedSignatureBlock = ^(UIImage *signatureImage) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];;
            imageView.image = signatureImage;
            [weakSelf.showImageView addSubview:imageView];
            weakSelf.haveSignature = YES;
        };
        [self.navigationController pushViewController:signatureController animated:YES];
    }
}


@end
