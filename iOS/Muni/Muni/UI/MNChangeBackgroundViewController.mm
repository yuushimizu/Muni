//
//  MNChangeBackgroundViewController.m
//  Muni
//
//  Created by Yuu Shimizu on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNChangeBackgroundViewController.h"
#import <QuartzCore/CALayer.h>

@interface MNBackgroundImageButton : UIButton {
	NSString *_imageName;
}

@property (nonatomic, retain) NSString *imageName;

@end

@implementation MNBackgroundImageButton

@synthesize imageName = _imageName;

- (UIImage *)backgroundImage {
	return [UIImage imageNamed:_imageName];
}

@end

@interface MNChangeBackgroundInnerViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
	id<MNChangeBackgroundDelegate> _changeBackgroundDelegate;
	BOOL _pickedFromImagePicker;
}

- (id)initWithChangeBackgroundDelegate:(id<MNChangeBackgroundDelegate>)changeBackgroundDelegate;

@end

@implementation MNChangeBackgroundInnerViewController

- (id)initWithChangeBackgroundDelegate:(id<MNChangeBackgroundDelegate>)changeBackgroundDelegate {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
		self.title = NSLocalizedString(@"Background", @"");
		_changeBackgroundDelegate = changeBackgroundDelegate;
		_pickedFromImagePicker = NO;
		self.view.backgroundColor = [UIColor blackColor];
		int buttonCount = kMNBackgroundImageCount + 1; // + 1 for the camera button
        int columns = 3;
		int rows = ceil((double) buttonCount / columns);
		double left = self.view.frame.size.width * 0.025;
		double width = (self.view.frame.size.width - left) / columns;
		double horizontalMargin = self.view.frame.size.width * 0.025;
		double top = self.view.frame.size.height * 0.025;
		double height = width * self.view.frame.size.height / self.view.frame.size.width;
		double verticalMargin = self.view.frame.size.height * 0.025;
		for (int y = 0; y < rows; ++y) {
			for (int x = 0; x < columns; ++x) {
				int backgroundImageNumber = y * columns + x + 1;
				if (backgroundImageNumber > buttonCount) break;
				UIButton *backgroundImageButton;
				if (backgroundImageNumber <= kMNBackgroundImageCount) {
					MNBackgroundImageButton *standardBackgroundImageButton = [MNBackgroundImageButton buttonWithType:UIButtonTypeCustom];
					standardBackgroundImageButton.imageName = [NSString stringWithFormat:@"Background%d", backgroundImageNumber];
					[standardBackgroundImageButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Background%d-Thumb", backgroundImageNumber]] forState:UIControlStateNormal];
					[standardBackgroundImageButton addTarget:self action:@selector(backgroundImageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
					backgroundImageButton = standardBackgroundImageButton;
				} else {
					if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) continue;
					UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
					[cameraButton setBackgroundImage:[UIImage imageNamed:@"BackgroundCamera-Thumb"] forState:UIControlStateNormal];
					[cameraButton addTarget:self action:@selector(backgroundCameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
					backgroundImageButton = cameraButton;
				}
				backgroundImageButton.frame = CGRectMake(left + horizontalMargin + x * width, top + verticalMargin + y * height, width - horizontalMargin * 2, height - verticalMargin * 2);
				CALayer *layer = backgroundImageButton.layer;
				layer.masksToBounds = YES;
				layer.borderWidth = 1;
				layer.borderColor = [[UIColor whiteColor] CGColor];
				[self.view addSubview:backgroundImageButton];
			}
			
		}
    }
    return self;
}



- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:(UIBarButtonItemStyle) UIBarButtonSystemItemCancel target:self action:@selector(backButtonPressed)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
	if (_pickedFromImagePicker) [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)backgroundImageButtonPressed:(UIView *)view {
	MNBackgroundImageButton *backgroundImageButton = (MNBackgroundImageButton *) view;
	[_changeBackgroundDelegate backgroundChanged:backgroundImageButton.backgroundImage];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)backgroundCameraButtonPressed {
    UIActionSheet*  sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", @""), NSLocalizedString(@"PhotoLibrary", @""), nil];
	[sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex > 1) return;
	UIImagePickerControllerSourceType sourceType = buttonIndex == 0 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
	if (![UIImagePickerController isSourceTypeAvailable:sourceType]) return;
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.allowsEditing = NO;
	imagePickerController.delegate = self;
	imagePickerController.sourceType = sourceType;
	[self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	[_changeBackgroundDelegate backgroundChanged:image];
	_pickedFromImagePicker = YES;
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)backButtonPressed {
	[_changeBackgroundDelegate backgroundChanged:nil];
	[self dismissModalViewControllerAnimated:YES];
}

@end

@implementation MNChangeBackgroundViewController

- (id)initWithChangeBackgroundDelegate:(id<MNChangeBackgroundDelegate>)changeBackgroundDelegate {
	return [super initWithRootViewController:[[MNChangeBackgroundInnerViewController alloc] initWithChangeBackgroundDelegate:changeBackgroundDelegate]];
}

@end
