#!/usr/bin/python3

from systemd import login, journal
import time
import datetime

def one_hour_ago():
    return datetime.datetime.fromtimestamp(time.time() - 60**2)

def journal():
    j = journal.Reader()
    j.this_boot()
    j.add_match(SYSLOG_IDENTIFIER='systemd-logind')
    return j

def logouts():
    j = journal()
    return [x for x in j if (x['MESSAGE'].startswith('Removed session') and x['_SOURCE_REALTIME_TIMESTAMP'] > one_hour_ago())]

def sessions():
    return login.sessions()

if (len(sessions()) > 0):
    exit(0)
else:
    if(len(logouts()) > 0):
        exit(0)
    else: 
        exit(1)
