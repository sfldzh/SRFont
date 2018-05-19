//
//  DetailViewController.m
//  SRFont
//
//  Created by hlet on 2018/5/17.
//  Copyright © 2018年 hlet. All rights reserved.
//

#import "DetailViewController.h"
#import "SRFontAdjust.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
//    self.detailDescriptionLabel.font = [UIFont systemFontOfSize:15];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.slider.value = [SRFontAdjust single].fontMultiple;
    [self configureView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 200, 40)];
    contentLabel.text = @"创建的Label";
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = [UIColor blackColor];
    [self.view addSubview:contentLabel];
}

- (IBAction)valueDidChange:(UISlider *)sender {
    [SRFontAdjust single].fontMultiple = sender.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(NSDate *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}


@end
