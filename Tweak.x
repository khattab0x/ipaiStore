// ipaiStoreCredit
// Shows a one-time credit message on first launch:
// "Distributed by ipaiStore - tweak developed by khattab"

#import <UIKit/UIKit.h>

static NSString *const kChannelURL = @"https://t.me/ipaiStore";
static NSString *const kShownKey   = @"ipaiStoreCredit_shown_v1";
static BOOL gPresenting = NO;

static UIWindow *ipai_activeWindow(void) {
    UIWindow *fallback = nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        if (scene.activationState != UISceneActivationStateForegroundActive) continue;
        for (UIWindow *w in ((UIWindowScene *)scene).windows) {
            if (w.isKeyWindow) return w;
            if (!fallback) fallback = w;
        }
    }
    return fallback;
}

static UIViewController *ipai_topController(UIViewController *vc) {
    while (vc.presentedViewController) vc = vc.presentedViewController;
    return vc;
}

static void ipai_tryShow(int attempt) {
    if (gPresenting) return;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kShownKey]) return;
    if (attempt > 10) return;

    UIWindow *window = ipai_activeWindow();
    UIViewController *top = ipai_topController(window.rootViewController);
    if (!top || top.isBeingPresented || top.isBeingDismissed) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{ ipai_tryShow(attempt + 1); });
        return;
    }

    gPresenting = YES;
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"ipaiStore"
        message:@"نشر ipaiStore\nالتعديل من تطوير 7md\n\nDistributed by ipaiStore\nTweak developed by khattab"
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"انضم للقناة"
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction *a) {
            NSURL *url = [NSURL URLWithString:kChannelURL];
            [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
        }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"إغلاق"
        style:UIAlertActionStyleCancel handler:nil]];

    [top presentViewController:alert animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShownKey];
        gPresenting = NO;
    }];
}

%ctor {
    @autoreleasepool {
        [[NSNotificationCenter defaultCenter]
            addObserverForName:UIApplicationDidBecomeActiveNotification
            object:nil
            queue:NSOperationQueue.mainQueue
            usingBlock:^(NSNotification *n) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{ ipai_tryShow(0); });
            }];
    }
}
