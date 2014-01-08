//
//  OPHLAppDelegate+OPHLExtensions.h
//  octophile
//
//  Created by Jackson Harper on 1/8/14.
//  Copyright (c) 2014 SyntaxTree. All rights reserved.
//

#import "OPHLAppDelegate.h"

@interface OPHLAppDelegate (OPHLExtensions)


- (void)ophl_initializeApplication;
- (BOOL)ophl_openURL:(NSURL *)url fromApplication:(NSString *)sourceApplication withAnnotation:(id)annotation;


@end
