#import <notify.h>
#import "../CydiaHeader.h"

static inline NSString *UCLocalizeEx(NSString *key, NSString *value = nil)
{
	return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}
#define UCLocalize(key) UCLocalizeEx(@ key)

static inline void _UpdateExternalStatus(uint64_t newStatus)
{
	int notify_token;
	if (notify_register_check("com.saurik.Cydia.status", &notify_token) == NOTIFY_STATUS_OK) {
		notify_set_state(notify_token, newStatus);
		notify_cancel(notify_token);
	}
	notify_post("com.saurik.Cydia.status");
}

CydiaProgressData *cpd;

%hook CydiaProgressData

- (id)init
{
	self = %orig;
	cpd = self;
	return self;
}

%end

%hook ProgressController

%new
- (void)dp_close
{
	_UpdateExternalStatus(0);
	[(Cydia *)[UIApplication sharedApplication] returnToCydia];
	[[[self navigationController] parentOrPresentingViewController] dismissModalViewControllerAnimated:YES];
}

- (UIBarButtonItem *)rightButton
{
    return ![[cpd running] boolValue] ? [[[UIBarButtonItem alloc]
        initWithTitle:UCLocalize("CLOSE")
        style:UIBarButtonItemStylePlain
        target:self
        action:@selector(dp_close)
    ] autorelease] : %orig;
}

- (void)applyRightButton
{
	[[self navigationItem] setRightBarButtonItem:![[cpd running] boolValue] ? [self rightButton] : nil];
}

%end