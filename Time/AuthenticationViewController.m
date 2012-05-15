//
//  AuthenticationViewController.m
//  Time
//
//  Created by Nikil Viswanathan on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "API.h"

@interface AuthenticationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *loginError;

@end

@implementation AuthenticationViewController
@synthesize loginButton = _loginButton;
@synthesize email = _email;
@synthesize password = _password;
@synthesize loginError = _loginError;
@synthesize delegate = _delegate;

- (void)displayLoginError:(NSString *)message
{
    self.loginError.text = message;
}

- (IBAction)loginClicked {
    
    //TODO: clean
    NSString * email = self.email.text;
    NSString * password = self.password.text;
    
    //try login result
    NSDictionary * loginResult =  [API loginWithEmail:email  andPassword:password]; 

    //Check Login
    //Good
    if([API successfulLogin:loginResult])
    {
        NSString *authToken = [API authTokenForSuccessfulLogin:loginResult];
        [self.delegate successfulAuthentication:authToken];
    }
    //No
    else
        [self displayLoginError:[API errorMessageForAuthentication:loginResult]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLoginButton:nil];
    [self setEmail:nil];
    [self setPassword:nil];
    [self setLoginError:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


/*
    TryLogin
 
    Logs in and gets the current information
*/
- (void)tryLogin
{
    //Save the auth token
    //todo: check if incorrect information
      
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
