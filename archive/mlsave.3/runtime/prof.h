#define ARRAYS 0
#define ARRAYSIZE 1
#define STRINGS 2
#define STRINGSIZE 3
#define LINKS 4
#define LINKSLOTS 256
#define BIGLINKS (LINKS+LINKSLOTS)
#define CLOSURES (BIGLINKS+1)
#define CLOSURESLOTS 256
#define BIGCLOSURES (CLOSURES+CLOSURESLOTS)
#define RECORDS (BIGCLOSURES+1)
#define RECORDSLOTS 5
#define BIGRECORDS (RECORDS+RECORDSLOTS)
#define PROFSIZE (BIGRECORDS+1)
