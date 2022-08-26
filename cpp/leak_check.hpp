#if defined(__has_feature) && (__has_feature(leak_sanitizer) || __has_feature(address_sanitizer))
	
	#define leak_check() __lsan_do_recoverable_leak_check()
#else
	#define leak_check() ((void) 0)
#endif
