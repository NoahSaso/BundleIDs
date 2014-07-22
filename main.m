int main(int argc, char **argv) {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	int ret = UIApplicationMain(argc, argv, @"BundleIDsApplication", @"BundleIDsApplication");
	[p drain];
	return ret;
}

// vim:ft=objc
