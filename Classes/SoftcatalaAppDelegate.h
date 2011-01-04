//
//  SoftcatalaAppDelegate.h
//  Softcatala
//
//  Created by Marcos Grau on 09/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoftcatalaAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIViewController *traductorViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *traductorViewController;


@end

