//
//  BMCollageMakerViewController.m
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 19.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//

#import "BMCollageMakerViewController.h"
#import "BMCollageCreator.h"
#import <MessageUI/MessageUI.h>

@interface BMCollageMakerViewController ()<BMCollageCreatorDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *collageImageView;
@property (nonatomic, weak) IBOutlet UIButton *sendMailButton;
@property (nonatomic, strong) UIImage *collageImage;
@end

@implementation BMCollageMakerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	BMCollageCreator *collageCreator = [[BMCollageCreator alloc] init];
	collageCreator.delegate = self;
	[collageCreator createCollageWithImages:self.imagesArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setImagesArray:(NSArray *)imagesArray
{
	_imagesArray = [NSArray arrayWithArray:imagesArray];
}

#pragma mark -=Mail=-
- (IBAction)sendMail:(id)sender {
	MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
	mailVC.mailComposeDelegate = self;
	
	[mailVC setSubject:@"Зацени коллаж!"];
	 
	NSData *imageData = UIImageJPEGRepresentation(self.collageImage, 1.f);
	[mailVC addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"collage.jpeg"];
	
	NSString *emailBody = @"Смотри, какой крутой коллаж! Я его сделал через приложение Богдана Матвеева :)";
	[mailVC setMessageBody:emailBody isHTML:YES];
	 
	[self presentViewController:mailVC animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error {
	
 	[self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -=Delegate methods=-
-(void)onCollageCreatedWithImage:(UIImage *)image
{
	self.collageImageView.image = image;
	self.collageImage = image;
}


@end
