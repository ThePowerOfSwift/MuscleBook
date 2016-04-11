//
//  CBLParseDate.h
//  CouchbaseLite
//
//  Created by Jens Alfke on 9/8/13.
//
// https://github.com/couchbase/couchbase-lite-ios/blob/cdc9c418a9eeb28f604d94bc87ca4a4763404ac5/Source/CBLParseDate.h

#ifndef CouchbaseLite_CBLParseDate_h
#define CouchbaseLite_CBLParseDate_h

/** Parses a C string as an ISO-8601 date-time, returning a UNIX timestamp (number of seconds
 since 1/1/1970), or a NAN if the string is not valid. */
double CBLParseISO8601Date(const char* dateStr);

#endif
