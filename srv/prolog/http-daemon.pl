/*  File:    http-daemon.pl
    Author:  Roy Ratcliffe
    Created: Sep 25 2022
    Purpose: HTTP Unix Daemon
*/

:- module(http_daemon, []).
:- use_module(library(http/http_unix_daemon)).
:- use_module(library(settings), [convert_setting_text/3]).

:- autoload(library(main), [argv_options/3]).
:- autoload(library(optparse), [opt_help/2]).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Note that the Windows distribution of Prolog does *not* include the Unix
daemon for obvious reasons. Loading these files in Windows therefore
gives undefined-predicate errors; predicate http_daemon/1 will appear
as red in the Emacs editor, for example.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

:- initialization(up, main).

up :-
    current_prolog_flag(argv, Argv),
    argv_options(Argv, _, Options0),
    httpd_env([user(atom), port(nonneg)], Options0, Options),
    http_daemon([fork(false)|Options]).

httpd_env([], Options, Options).
httpd_env([H0|T0], Options0, [Option|Options_]) :-
    H0 =.. [Name, Type],
    httpd_env_(Name, Type, Option),
    !,
    httpd_env(T0, Options0, Options_).
httpd_env([_|T0], Options0, Options) :-
    httpd_env(T0, Options0, Options).

httpd_env_(Name, Type, Option) :-
    atomic_concat(httpd_, Name, Name0),
    string_upper(Name0, Name_),
    getenv(Name_, Value0),
    convert_setting_text(Type, Value0, Value),
    Option =.. [Name, Value].
