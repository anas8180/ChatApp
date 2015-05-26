//
//  ChatViewController.m
//  ChatApp
//
//  Created by mohamed on 26/05/15.
//  Copyright (c) 2015 mohamed. All rights reserved.
//

#import "ChatViewController.h"
#import "AKTextView.h"
#import "ChatViewCell.h"

#define TABBAR_HEIGHT 49.0f
#define TEXTFIELD_HEIGHT 70.0f
#define MAX_ENTRIES_LOADED 25

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString *className;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet AKTextView *messageTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomCOnstraint;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation ChatViewController
@synthesize userName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"ChatRoom";
    
    //    // add tap gesuture to hide keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped:)];
    tapGesture.numberOfTapsRequired = 2;
    
    [self.tableView addGestureRecognizer:tapGesture];
    
    self.tableView.estimatedRowHeight = 84.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    
    _dataArray = [NSMutableArray new];
    
    
    UIImage *img1 = [UIImage imageNamed:@"user1"];
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"UserID",@"Mohamed",@"name",@"Assalamu Alaikum",@"message",NULL,@"media", nil];
    
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"UserID",@"Mohamed",@"name",@"",@"message",img1,@"media", nil];
    
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"UserID",userName,@"name",@"Va Alaikum Salaam",@"message",NULL,@"media", nil];
    
    [_dataArray addObject:dict1];
    [_dataArray addObject:dict2];
    [_dataArray addObject:dict3];
    
    className = @"chatroom";

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];

    // Register for Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [_dataArray objectAtIndex:indexPath.row];
    
    NSInteger userID = [[object objectForKey:@"UserID"] integerValue];
    
    if(userID == 1)
    {
        if(![object objectForKey:@"media"])
        {
        ChatViewCell *cell = (ChatViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ChatSenderCell" forIndexPath:indexPath];
        
        [self configureGossipItem:cell atIndexPath:indexPath];
        
        return cell;
        }
        else
        {
            ChatViewCell *cell = (ChatViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ChatPicSenderCell" forIndexPath:indexPath];
            
            [self configureGossipItem:cell atIndexPath:indexPath];
            
            return cell;
  
        }
        
    }
    else
    {
        if(![object objectForKey:@"media"])
        {

        ChatViewCell *cell = (ChatViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
        
        [self configureGossipItem:cell atIndexPath:indexPath];
        
        return cell;
        }
        else
        {
            ChatViewCell *cell = (ChatViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ChatPicCell" forIndexPath:indexPath];
            
            [self configureGossipItem:cell atIndexPath:indexPath];
            
            return cell;
  
        }
        
    }
    
    // Configure the cell...
    
}

- (void)configureGossipItem:(ChatViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    
    cell.user_image.layer.cornerRadius = 22.5;
    cell.user_image.clipsToBounds = YES;
    
    cell.chatView.layer.cornerRadius = 5.0;
    
    
    cell.user_name.text = [NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
   
    if([[_dataArray objectAtIndex:indexPath.row] objectForKey:@"media"])
       cell.mediaImage.image = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"media"];
    
    NSString *commentStr = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"message"];
    
    if(![commentStr isKindOfClass:[NSNull class]])
        cell.comment.text = commentStr;
    
    cell.comment.numberOfLines = 0;
    
}


#pragma mark - UIKeyboardNotifications

- (void)keyboardDidShow:(NSNotification *)notification{
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // move message textview above keyboard
    
    self.bottomCOnstraint.constant = frame.size.height - 12;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
        
        [self.tableView reloadData];
        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArray.count -1 inSection:0];
//        
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification{
    // move message textview above keyboard
    
    self.bottomCOnstraint.constant = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Tableview Tap Gesuture

- (void)tableViewTapped:(UITapGestureRecognizer *)gesture{
    [self dismissKeyboard];
}

#pragma mark - Utilities

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag ==500)
    {
        textView.tag =501;
        
        textView.text = @"";
    }
}
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - Action

- (IBAction)sendButton_Clicked:(id)sender
{
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"UserID",userName,@"name",_messageTextView.text,@"message",NULL,@"media", nil];

    [_dataArray addObject:dict1];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArray.count -1 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    // going for the parsing
    PFObject *newMessage = [PFObject objectWithClassName:@"chatroom"];
    [newMessage setObject:_messageTextView.text forKey:@"text"];
    [newMessage setObject:userName forKey:@"userName"];
    [newMessage setObject:@"2" forKey:@"UserID"];
    [newMessage setObject:@"nil" forKey:@"media"];


    [newMessage saveInBackground];

    _messageTextView.text = @"";
}
- (IBAction)addMedia:(id)sender {
    
    UIActionSheet * action = [[UIActionSheet alloc]
                              initWithTitle:@"Select Your Option"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"Upload From Gallery",@"Take a New Picture",nil];
    
    
    [action showInView:self.view];

}


#pragma mark - UIAction Sheet method

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"%ld",(long)buttonIndex);
    
    if(buttonIndex == 0)
    {
        [self callImagePicker:buttonIndex];
    }
    else if(buttonIndex ==1)
    {
        [self callImagePicker:buttonIndex];
    }
    
    
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if([chosenImage isKindOfClass:NULL])
    {
        chosenImage = info[UIImagePickerControllerOriginalImage];
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    [self loadTableView:chosenImage];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


-(void)callImagePicker:(NSInteger) sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.allowsEditing = YES;
    
    if(sender == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)loadTableView:(UIImage *)image
{
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"UserID",userName,@"name",@"",@"message",image,@"media", nil];
    
    [_dataArray addObject:dict1];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArray.count -1 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
