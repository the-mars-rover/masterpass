//
//  MPMasterPass.h
//  MasterPassKit
//
//  Created by Ferdie Danzfuss on 2016/03/29.
//  Copyright © 2016 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MPWaitingViewController.h"
#import "MPTransitioningDelegate.h"
#import "MPGlobals.h"

@protocol MMNixDelegate;

typedef NS_ENUM(NSInteger, MPError) {
    MPErrorNetworkError,
    MPErrorExceptionOccored,
    MPErrorPaymentError,
    MPErrorOTPError,
    MPErrorInvalidCodeParameter,
    MPErrorInvalidApiKeyParameter,
    MPErrorSecureCodeNotSupported
};


@protocol MPMasterPassDelegate <NSObject>

@required
-(void)masterpassUserDidCancel;
@required
-(void)masterpassPaymentSucceededWithTransactionReference:(NSString *)transactionReference;
@required
-(void)masterpassError:(MPError)error;
@required
-(void)masterpassPaymentFailedWithTransactionReference:(NSString *)transactionReference;
@required
-(void)masterpassInvalidCode;
@required
-(void)masterpassUserRegistered;

@end


@interface MPMasterPass : NSObject <MMNixDelegate>

+ (void)load;
-(void)showLoadingDialogFromController:(UIViewController *)presentingController;
-(void)hideLoadingDialog;
-(void)checkoutWithCode:(NSString *)code apiKey:(NSString *)apiKey system:(MPSystem)system controller:(UIViewController *)presentingController delegate:(id<MPMasterPassDelegate>)delegate;
-(NSString *)getLibNixApiVersion;
-(void)preRegister:(NSString *)apiKey system:(MPSystem)system controller:(UIViewController *)presentingController delegate:(id<MPMasterPassDelegate>)delegate ;

-(void)showScreen:(NSString *)storybaordId fromController:(UIViewController *)presentingController;

-(void)reset;

+(void)printFonts;

+(void)loadCodeInfo:(MPWaitingViewController*) waitingViewController;

@end
