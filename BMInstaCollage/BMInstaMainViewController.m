//
//  BMInstaMainViewController.m
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 16.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//
#import "BMInstaMainViewController.h"
#import "BMInstagramConnector.h"
#import "BMPicSelectionViewController.h"
@interface BMInstaMainViewController () <BMInstagramConnectorDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *getPhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *bluredImageView;

@property (strong, nonatomic) UIView *blackIndicatorView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) BMInstagramConnector *connectionDelegate;
@end

@implementation BMInstaMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.connectionDelegate = [[BMInstagramConnector alloc] init];
    self.connectionDelegate.delegate = self;
    self.connectionDelegate.numberOfPhotos = 5;
	
	self.getPhotoButton.layer.borderColor = [UIColor whiteColor].CGColor;
	self.getPhotoButton.layer.borderWidth = 1.f;
	self.getPhotoButton.layer.cornerRadius = 6.f;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	
	[self.bluredImageView addGestureRecognizer:tap];

}

- (void)proceedWithMediaArray:(NSArray *)mediaDataArray
{
	BMPicSelectionViewController *picSelectionVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PicSelectionVC"];
	picSelectionVc.mediaDataArray = mediaDataArray;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.navigationController pushViewController:picSelectionVc animated:YES];
	});
}


- (IBAction)getPhotosButtonPressed:(id)sender {
	if (!self.usernameTextField.text.length)
	{
		[self sendAlertWithMessage:@"Введите сначала имя пользователя"];
		return;
	}
	
	[self.connectionDelegate findUserWithNickName:self.usernameTextField.text];
}

-(void)dismissKeyboard
{
	[self.usernameTextField resignFirstResponder];
}

#pragma mark -=Delegate methods=-
- (void)sendAlertWithMessage:(NSString*)message
{
	dispatch_async(dispatch_get_main_queue(), ^{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
	});
}

#pragma mark -=Indicator=-
- (void) showIndicatorView
{
	self.blackIndicatorView = [[UIView alloc] initWithFrame:self.view.frame];
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	[self.activityIndicator setCenter:self.blackIndicatorView.center];
	[self.blackIndicatorView addSubview:self.activityIndicator];
	[self.activityIndicator startAnimating];
	
	self.blackIndicatorView.alpha = .8f;
	self.blackIndicatorView.backgroundColor = [UIColor blackColor];
	
	[self.view addSubview:self.blackIndicatorView];
	
}
- (void) hideIndicatorView
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.activityIndicator removeFromSuperview];
		[self.blackIndicatorView removeFromSuperview];
	});
}
@end
