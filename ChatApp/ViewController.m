//
//  ViewController.m
//  ChatApp
//
//  Created by mohamed on 26/05/15.
//  Copyright (c) 2015 mohamed. All rights reserved.
//

#import "ViewController.h"
#import "ChatViewController.h"

@interface ViewController ()<UIAlertViewDelegate>
{
    NSString *userName;
}
@property (nonatomic, strong) UITextField *alertTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Home";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)joinRoom:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userName = [defaults stringForKey:@"chatName"];
    
    if ([userName isEqualToString:@"chat"])
    {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"Enter Your Name"
                                                    delegate:self
                                           cancelButtonTitle:@"Dismiss"
                                           otherButtonTitles:@"Confirm", nil];
    
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    _alertTextField = [alert textFieldAtIndex:0];
    _alertTextField.keyboardType = UIKeyboardTypeDefault;
    _alertTextField.placeholder = @"User";
    
    [alert show];
    }
    else
    {
        ChatViewController *chatViewObj = (ChatViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewVC"];
        chatViewObj.userName = userName;
        [self.navigationController pushViewController:chatViewObj animated:YES];
   
    }
}

#pragma mark - Alertview method

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //    NSLog(@"%ld",(long)buttonIndex);
    //    NSLog(@"%@",_alertTextField.text);
    if(buttonIndex == 1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:_alertTextField.text forKey:@"chatName"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        ChatViewController *chatViewObj = (ChatViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewVC"];
        chatViewObj.userName = _alertTextField;
        [self.navigationController pushViewController:chatViewObj animated:YES];
    }
}

@end
