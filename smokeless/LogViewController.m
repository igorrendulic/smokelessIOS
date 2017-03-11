//
//  LogViewController.m
//  smokeless
//
//  Created by Igor Test on 24/07/16.
//  Copyright © 2016 Igor Rendulic. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"logfile.txt"];
    // create if needed
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        
        NSString *log = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        _textView.text = log;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
