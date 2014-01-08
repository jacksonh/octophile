//
//  OPHLAppDelegate+OPHLExtensions.m
//  octophile
//
//  Created by Jackson Harper on 1/8/14.
//  Copyright (c) 2014 SyntaxTree. All rights reserved.
//

#import "OPHLAppDelegate+OPHLExtensions.h"

#import <OctoKit/OctoKit.h>


@implementation OPHLAppDelegate (OPHLExtensions)


- (void)ophl_initializeApplication
{
	[OCTClient setClientID:@"5e796a921bb71491ca8e" clientSecret:@"4ef7caad48caeaf28c4f83aa52efe3be16f25fea"];
}

- (BOOL)ophl_openURL:(NSURL *)URL fromApplication:(NSString *)sourceApplication withAnnotation:(id)annotation
{
    if ([URL.host isEqual:@"oauth"]) {
        [OCTClient completeSignInWithCallbackURL:URL];
        return YES;
    }
	return NO;
}

@end
