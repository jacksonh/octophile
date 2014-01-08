//
//  OPHLProfileViewController.m
//  octophile
//
//  Created by Jackson Harper on 1/8/14.
//  Copyright (c) 2014 SyntaxTree. All rights reserved.
//

#import "OPHLProfileViewController.h"

#import <OctoKit/OctoKit.h>
#import <SSKeychain/SSKeychain.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface OPHLProfileViewController ()

@property (strong, nonatomic) OCTClient *client;

@property (strong, nonatomic) UIImageView *userImageView;

@end



@implementation OPHLProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectZero];
	UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	[self setUserImageView:userImageView];

	[loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	[loginButton setTitle:@"Login" forState:UIControlStateNormal];
	[loginButton setBackgroundColor:[UIColor colorWithRed:1.0 green:(143.0/255) blue:(155.0/255) alpha:1.0]];
	[loginButton addTarget:self action:@selector(ophl_buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

	[userImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[userImageView setBackgroundColor:[UIColor lightGrayColor]];
	[userImageView setContentMode:UIViewContentModeScaleAspectFill];

	[[self view] addSubview:loginButton];
	[[self view] addSubview:userImageView];

	NSDictionary *views = NSDictionaryOfVariableBindings (loginButton, userImageView);

	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[loginButton]-|"
																		options:kNilOptions
																		metrics:nil
																		  views:views]];
	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[userImageView]-|"
																		options:kNilOptions
																		metrics:nil
																		  views:views]];
	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(100)-[loginButton(==44)]-[userImageView]-|"
																		options:kNilOptions
																		metrics:nil
																		  views:views]];
}

- (void)ophl_buttonTapped:(id)sender
{
	return ([self client] ? [self ophl_fetchUserInfoFromButton:sender] : [self ophl_signInFromButton:sender]);
}

- (void)ophl_signInFromButton:(UIButton *)button
{
	[[[self ophl_signInAndCreateClient]
	  deliverOn:[RACScheduler mainThreadScheduler] ]
	 subscribeNext:^(OCTClient *client) {
		NSLog (@"USER INFO:  %@", client);
		 [self setClient:client];
		 [button setTitle:@"Fetch User Info" forState:UIControlStateNormal];
	} error:^(NSError *error) {
		NSLog (@"ERROR FETCHING INFO:  %@", error);
	}];
}

- (void)ophl_fetchUserInfoFromButton:(UIButton *)button
{
	[[[self client] fetchUserInfo] subscribeNext:^(OCTUser *user) {
		NSLog (@"FETCHED INFO:  %@", user);
		[[self userImageView] setImageWithURL:[user avatarURL]];
	} error:^(NSError *error) {
		NSLog (@"ERROR FETCHING USER INFO:  %@", error);
	}];
}

- (RACSignal *)ophl_signInAndCreateClient {
	RACSignal *signIn = [RACSignal defer:^{
		return [OCTClient
				signInToServerUsingWebBrowser:OCTServer.dotComServer scopes:OCTClientAuthorizationScopesRepository | OCTClientAuthorizationScopesUser];
	}];

	return signIn;
}

@end


