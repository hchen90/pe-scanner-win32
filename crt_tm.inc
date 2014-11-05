crt_tm	struct
	tm_sec		DWORD	? ;Seconds: 0-59 (K&R says 0-61?)
	tm_min		DWORD	?	;Minutes: 0-59 
	tm_hour		DWORD	?	;Hours since midnight: 0-23
	tm_mday		DWORD	?	;Day of the month: 1-31 
	tm_mon		DWORD	?	;Months *since* january: 0-11 
	tm_year		DWORD	?	;Years since 1900
	tm_wday		DWORD	?	;Days since Sunday (0-6) 
	tm_yday		DWORD	?	;Days since Jan. 1: 0-365
	tm_isdst	DWORD	?	;+1 Daylight Savings Time, 0 No DST, -1 don't know
crt_tm	ends