//
//  ConnectSocialProfileViewCell.m
//  nimple-iOS
//
//  Created by Guido Schmidt on 03.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "ConnectSocialProfileViewCell.h"

@implementation ConnectSocialProfileViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//
- (IBAction)connectButtonClicked:(id)sender
{
    NSLog(@"connect with facebook");
    
    if(self.index == 0)
    {
        self.fbLoginView = [[FBLoginView alloc] init];
        self.fbLoginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
        [self addSubview:self.fbLoginView];
        [self.fbLoginView setHidden:TRUE];
        self.fbLoginView.delegate = self;
        
        for(id object in self.fbLoginView.subviews){
            if([[object class] isSubclassOfClass:[UIButton class]]){
                UIButton* button = (UIButton*)object;
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    if(self.index == 1)
    {
        self.twitterAcountStore = [[ACAccountStore alloc] init];
    }
}

// ### FACEBOOK ################################################################

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [self.socialNetworkButton setAlpha:0.3];
    [self.connectStatusButton setTitle:@"mit facebook verbinden" forState:UIControlStateNormal];
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    [viewController.myNimpleCode setValue:@"" forKey:@"facebook_ID"];
    [viewController.myNimpleCode setValue:@"" forKey:@"facebook_URL"];
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    UITableView *tableView = (UITableView *) self.superview.superview;
    EditNimpleCodeTableViewController *viewController = (EditNimpleCodeTableViewController *) tableView.dataSource;
    [viewController.myNimpleCode setValue:user.id forKey:@"facebook_ID"];
    [viewController.myNimpleCode setValue:user.link forKey:@"facebook_URL"];
    [self.socialNetworkButton setAlpha:1.0];
    [self.connectStatusButton setTitle:@"verbunden" forState:UIControlStateNormal];
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
@end
