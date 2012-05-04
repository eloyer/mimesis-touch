//
//  AppDelegate.h
//  MimesisTouch
//
//  Created by Erik Loyer on 5/2/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class MimesisNarrativeView;
@class NarrativeController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow                    *window;
	RootViewController          *viewController;
	MimesisNarrativeView        *narrativeView;							// primary view for the application
	NarrativeController			*narrativeController;					// primary controller for the application
}

@property (nonatomic, retain) UIWindow *window;

@end
