#ifndef APPVERSION_H_
#define APPVERSION_H_

// Application version.
// Its a token, replaced by Nant during the build process.
#define VERSION = @APP_VERSION@
#define APP_VERSION "@APP_VERSION@"

// Application name
#define APP_NAME "WPN-XM Server Control Panel"

// Application name and version
#define APP_NAME_AND_VERSION "WPN-XM Server Control Panel v@APP_VERSION@"

#endif /* APPVERSION_H_ */