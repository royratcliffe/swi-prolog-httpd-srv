:- use_module(library(http/http_log), [http_schedule_logrotate/2]).

:- http_schedule_logrotate(weekly(sun, 05:05), [keep_logs(26)]).
