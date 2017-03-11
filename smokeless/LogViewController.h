//
//  LogViewController.h
//  smokeless
//
//  Created by Igor Test on 24/07/16.
//  Copyright © 2016 Igor Rendulic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogViewController : UIViewController
- (IBAction)closeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
