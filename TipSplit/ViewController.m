//
//  ViewController.m
//  TipSplit
//
//  Created by Alexandria Mar on 9/16/16.
//  Copyright © 2016 Alexandria Mar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(weak, nonatomic) IBOutlet UITextField *billAmount;
@property(weak, nonatomic) IBOutlet UISegmentedControl *taxPercent;
@property(weak, nonatomic) IBOutlet UILabel *tipPercentage;
@property(weak, nonatomic) IBOutlet UILabel *numPeopleSplittingBill;
@property(weak, nonatomic) IBOutlet UILabel *tax;
@property(weak, nonatomic) IBOutlet UILabel *totalForTip;
@property(weak, nonatomic) IBOutlet UILabel *tip;
@property(weak, nonatomic) IBOutlet UILabel *totalWithTip;
@property(weak, nonatomic) IBOutlet UILabel *totalPerPerson;
@property (weak, nonatomic) IBOutlet UISlider *sliderNum;
@property (weak, nonatomic) IBOutlet UIStepper *stepperNum;
@property (weak, nonatomic) IBOutlet UISwitch *tipIncludesTax;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property float mBill;
@property float mTaxPercentage;
@property float mTaxAmount;
@property float mTipPercentage;
@property float mTotalForTip;
@property float mTipValue;
@property float mTotalWithTip;
@property float mTotalPerPerson;
@property int mSplitNum;
@property BOOL mIncludeTax;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    BOOL startOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"start"];
//    
//    [self.tipIncludesTax setOn:startOn animated:YES];
    [self setDefaultValues];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)billTouched:(id)sender {
    if (self.billAmount.text.length > 0) {
        self.mBill = self.billAmount.text.floatValue;
    }
    [self updateValues];
}

- (IBAction)textFieldExit:(id)sender {
    [sender resignFirstResponder];
    self.mBill = self.billAmount.text.floatValue;
    [self updateValues];
}

- (IBAction)taxPercent:(id)sender {
    [self updateValues];
}

- (IBAction)switchChanged:(id)sender {
    [self updateValues];
}

- (IBAction) sliderChanged: (id) sender {
    [self updateValues];
}

- (IBAction)stepperChanged:(id)sender {
    [self updateValues];
}

- (IBAction)clearAll:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Clear All Values" message:@"Are you sure you want to clear all values?" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style: UIAlertActionStyleCancel handler:^(UIAlertAction *action) { /* nothing happens */ }];
    
    UIAlertAction *clearAll = [UIAlertAction actionWithTitle:@"Clear All" style: UIAlertActionStyleDestructive handler:^(UIAlertAction *action) { [self clearAllNumbers]; }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:clearAll];
    [self presentViewController:alertController animated:YES completion: nil];

}

- (void) setDefaultValues {
    self.mBill = 0.00;

    self.mIncludeTax = YES;
    self.mTipPercentage = 20;
    self.mTaxPercentage = 0.075;
    self.mSplitNum = 1;
    self.mTaxAmount = 0.00;
    self.mTipValue = 0.00;
    self.mTotalForTip = 0.00;
    self.mTotalPerPerson = 0.00;
    self.mTotalWithTip = 0.00;
    
    self.billAmount.text = @"";
    self.numPeopleSplittingBill.text = @"1";
    self.tipPercentage.text = @"20%";
    self.tax.text = @"$";
    self.totalForTip.text = @"$";
    self.tip.text = @"$";
    self.totalWithTip.text = @"$";
    self.totalPerPerson.text = @"$";
}


- (void) touchesBegan: (NSSet *) touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.billAmount isFirstResponder] && [touch view] != self.billAmount) {
        [self.billAmount resignFirstResponder];
        [self updateValues];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void) updateValues {
    self.mBill = self.billAmount.text.floatValue;
    if (self.mTaxPercentage == 0) {
        self.mTaxPercentage = 0.075;
    }
    
    // segmented control
    NSInteger segment = self.segmentedControl.selectedSegmentIndex;
    if (segment == 0) {
        self.mTaxPercentage = 0.075;
    }
    if (segment == 1) {
        self.mTaxPercentage = 0.08;
    }
    if (segment == 2) {
        self.mTaxPercentage = 0.085;
    }
    if (segment == 3) {
        self.mTaxPercentage = 0.09;
    }
    if (segment == 4) {
        self.mTaxPercentage = 0.095;
    }
    
    self.mTaxAmount = self.mTaxPercentage * self.mBill;
    
    // switch
    if (self.tipIncludesTax.isOn) {
        self.mIncludeTax = YES;
        self.mTotalForTip = self.mBill + self.mTaxAmount;
        self.mTipValue = self.mTotalForTip * self.mTipPercentage * 0.01;
        self.mTotalWithTip = self.mTipValue + self.mTotalForTip;
    }
    else {
        self.mIncludeTax = NO;
        self.mTotalForTip = self.mBill;
        self.mTipValue = self.mTotalForTip * self.mTipPercentage * 0.01;
        self.mTotalWithTip = self.mTipValue + self.mTotalForTip + self.mTaxAmount;
    }
    
    // slider
    int number = (int) (self.sliderNum.value + 0.5f);
    NSString *newText = [NSString stringWithFormat:@"%d%%", number];
    self.tipPercentage.text = newText;
    self.mTipPercentage = newText.floatValue;
    
    // stepper
    int stepperNum = (int) self.stepperNum.value;
    NSString *numPeopleSplitting = [NSString stringWithFormat:@"%d", stepperNum];
    self.numPeopleSplittingBill.text = numPeopleSplitting;
    self.mSplitNum = numPeopleSplitting.intValue;
    
    // other values
    self.mTotalPerPerson = self.mTotalWithTip / self.mSplitNum;
    
    // labels
    self.tax.text = [NSString stringWithFormat:@"$%0.2f",self.mTaxAmount];
    self.totalForTip.text = [NSString stringWithFormat:@"$%0.2f",self.mTotalForTip];
    self.tip.text = [NSString stringWithFormat:@"$%0.2f",self.mTipValue];
    self.totalWithTip.text = [NSString stringWithFormat:@"$%0.2f",self.mTotalWithTip];
    self.totalPerPerson.text = [NSString stringWithFormat:@"$%0.2f",self.mTotalPerPerson];
    
}

- (void) clearAllNumbers {
    self.mBill = 0.00;
    
    self.mIncludeTax = YES;
    self.mTipPercentage = 20;
    self.mTaxPercentage = 0.075;
    self.mSplitNum = 1;
    self.mTaxAmount = 0.00;
    self.mTipValue = 0.00;
    self.mTotalForTip = 0.00;
    self.mTotalPerPerson = 0.00;
    self.mTotalWithTip = 0.00;
    
    self.sliderNum.value = 20;
    self.stepperNum.value = 1;
    [self.segmentedControl setSelectedSegmentIndex:0];
    
    self.billAmount.text = @"";
    self.numPeopleSplittingBill.text = @"1";
    self.tipPercentage.text = @"20%";
    self.tax.text = @"$";
    self.totalForTip.text = @"$";
    self.tip.text = @"$";
    self.totalWithTip.text = @"$";
    self.totalPerPerson.text = @"$";
}



@end
