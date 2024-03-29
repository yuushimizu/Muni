#import "MNMainViewController.h"
#import "juiz.h"
#import "MNGLView.h"
#import "MNChangeBackgroundViewController.h"

@implementation MNMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)hideMenuView {
	_menuView.alpha = 0;
}

- (void)showMenuView {
	_menuView.alpha = 1;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	_backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background1"]];
	_backgroundImageView.frame = self.view.frame;
	[self.view addSubview:_backgroundImageView];
	MNGLView *glView = [[MNGLView alloc] initWithFrame:self.view.frame];
	_sceneDirector = [[MNSceneDirector alloc] initWithGLView:glView withSize:juiz::size(self.view.frame.size)];
	[self.view addSubview:glView];
	_menuView = [[MNMenuView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height) withDelegate:self];
	[self.view addSubview:_menuView];
	[self hideMenuView];
	[_sceneDirector start];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)interrupt {
	if (_sceneDirector) [_sceneDirector stop];
}

- (void)resume {
	if (_sceneDirector) [_sceneDirector start];
}

- (void)resetButtonPressed {
	[self hideMenuView];
	[_sceneDirector reset];
}

- (void)changeBackgroundButtonPressed {
	[_sceneDirector stop];
	[self presentModalViewController:[[MNChangeBackgroundViewController alloc] initWithChangeBackgroundDelegate:self] animated:YES];
}

- (void)backgroundChanged:(UIImage *)backgroundImage {
	[self hideMenuView];
	if (backgroundImage) {
		_backgroundImageView.image = backgroundImage;
		[_backgroundImageView setNeedsDisplay];
	}
	[_sceneDirector start];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.2];
	if (_menuView.alpha == 1) {
		[self hideMenuView];
	} else {
		[self showMenuView];
	}
	[UIView commitAnimations];
}

@end
