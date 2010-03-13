%%
%% %CopyrightBegin%
%% 
%% Copyright Xiangyu LU(luxiangyu@msn.com) 2009-2010. All Rights Reserved.
%% 
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%% 
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%% 
%% %CopyrightEnd%
%%
-module(mb).
-export([start/0, encode/2, encode/3, decode/2, decode/3]).
-include_lib("mb/include/mb.hrl").

%% @spec start() -> {ok, Pid}
%%
%% @doc Start mb server, Return {ok, Pid}.

-spec start() -> ok.

start() ->
    case mb_server:start() of
        {ok, _Pid} ->
            ok;
        {error, {already_started, _App}} ->
            ok
    end.

%% ---------------------------------------------------------------------

%% @spec encode(Unicode, Encoding) -> binary() | string() | {error, Reason}
%%
%% @equiv encode(Unicode, Encoding, [])
%%
%% @see encode/3

-spec encode(unicode(), encoding()) -> binary() | string() | {error, tuple()}.

encode(Unicode, Encoding) when is_list(Unicode), is_atom(Encoding) ->
    encode(Unicode, Encoding, []);
encode(Unicode, {Encoding, Ending}) 
  when is_list(Unicode), is_atom(Encoding), is_atom(Ending) ->
    encode(Unicode, {Encoding, Ending}, []).

%% @spec encode(Unicode, Encoding, Options) -> binary() | string() | {error, Reason}
%%
%%	    Unicode  = unicode()
%%	    Encoding =  'cp037'
%%                | 'cp437'
%%                | 'cp500'
%%                | 'cp737'
%%                | 'cp775'
%%                | 'cp850'
%%                | 'cp852'
%%                | 'cp855'
%%                | 'cp857'
%%                | 'cp860'
%%                | 'cp861'
%%                | 'cp862'
%%                | 'cp863'
%%                | 'cp864'
%%                | 'cp865'
%%                | 'cp866'
%%                | 'cp869'
%%                | 'cp874'
%%                | 'cp875'
%%                | 'cp932'
%%                | 'cp936'
%%                | 'gbk'
%%                | 'cp949'
%%                | 'cp950'
%%                | 'big5'
%%                | 'cp1026'
%%                | 'cp1250'
%%                | 'cp1251'
%%                | 'cp1252'
%%                | 'cp1253'
%%                | 'cp1254'
%%                | 'cp1255'
%%                | 'cp1256'
%%                | 'cp1257'
%%                | 'cp1258'
%%                | 'cp10000'
%%                | 'cp10006'
%%                | 'cp10007'
%%                | 'cp10029'
%%                | 'cp10079'
%%                | 'cp10081'
%%                | 'utf8' 
%%                | 'utf16' 
%%                | 'utf16le' 
%%                | 'utf16be' 
%%                | 'utf32' 
%%                | 'utf32le' 
%%                | 'utf32be'
%%      Options  = [Option]
%%      Option =  {return, list} 
%%              | {return, binary}
%%              | {error, strict} 
%%              | {error, ignore}
%%              | {error, replace} 
%%              | {replace, non_neg_integer()}
%%              | {bom, true} 
%%              | {bom, false}
%%
%% @doc Return a Binary or String.
%%
%% @see encode/2

-spec encode(unicode(), encoding(), options()) -> binary() | string() | {error, tuple()}.

encode(Unicode, Encoding, Options) 
  when is_list(Unicode), is_atom(Encoding), is_list(Options) ->
    gen_server:call(mb_server, {encode, Unicode, Encoding, Options});
encode(Unicode, {Encoding, Ending}, Options) 
  when is_list(Unicode), is_atom(Encoding), is_atom(Ending), is_list(Options) ->
    gen_server:call(mb_server, {encode, Unicode, {Encoding, Ending}, Options}).

%% ---------------------------------------------------------------------

%% @spec decode(StringOrBinary, Encoding) -> unicode() | {error, Reason}
%%
%% @equiv decode(StringOrBinary, Encoding, [])
%%
%% @see decode/3

-spec decode(string()|binary(), encoding()) -> unicode() | {error, tuple()}.

decode(String, Encoding) when is_list(String), is_atom(Encoding) ->
    decode(String, Encoding, []);
decode(Binary, Encoding) when is_binary(Binary), is_atom(Encoding) ->
    decode(Binary, Encoding, []);
decode(String, {Encoding, Ending}) 
  when is_list(String), is_atom(Encoding), is_atom(Ending) ->
    decode(String, {Encoding, Ending}, []);
decode(Binary, {Encoding, Ending})
  when is_binary(Binary), is_tuple(Encoding), is_atom(Ending) ->
    decode(Binary, {Encoding, Ending}, []).

%% @spec decode(StringOrBinary, Encoding, Options) -> unicode()
%%
%%	    StringOrBinary  = string()|binary()
%%	    Encoding =  'cp037'
%%                | 'cp437'
%%                | 'cp500'
%%                | 'cp737'
%%                | 'cp775'
%%                | 'cp850'
%%                | 'cp852'
%%                | 'cp855'
%%                | 'cp857'
%%                | 'cp860'
%%                | 'cp861'
%%                | 'cp862'
%%                | 'cp863'
%%                | 'cp864'
%%                | 'cp865'
%%                | 'cp866'
%%                | 'cp869'
%%                | 'cp874'
%%                | 'cp875'
%%                | 'cp932'
%%                | 'cp936'
%%                | 'gbk'
%%                | 'cp949'
%%                | 'cp950'
%%                | 'big5'
%%                | 'cp1026'
%%                | 'cp1250'
%%                | 'cp1251'
%%                | 'cp1252'
%%                | 'cp1253'
%%                | 'cp1254'
%%                | 'cp1255'
%%                | 'cp1256'
%%                | 'cp1257'
%%                | 'cp1258'
%%                | 'cp10000'
%%                | 'cp10006'
%%                | 'cp10007'
%%                | 'cp10029'
%%                | 'cp10079'
%%                | 'cp10081'
%%                | 'utf8' 
%%                | 'utf16' 
%%                | 'utf16le' 
%%                | 'utf16be' 
%%                | 'utf32' 
%%                | 'utf32le' 
%%                | 'utf32be'
%%      Options  = [Option]
%%      Option =  {return, list} 
%%              | {return, binary}
%%              | {error, strict} 
%%              | {error, ignore}
%%              | {error, replace} 
%%              | {replace, non_neg_integer()}
%%              | {bom, true} 
%%              | {bom, false}
%%
%% @doc Return a Unicode.
%%
%% @see decode/2

-spec decode(string()|binary(), encoding(), options()) -> unicode() | {error, tuple()}.

decode(String, Encoding, Options) 
  when is_list(String), is_atom(Encoding), is_list(Options) ->
    case catch list_to_binary(String) of
        {'EXIT',{badarg, _}} ->
            {error, {illegal_list, [{list, String}, {line, ?LINE}]}};
        Binary ->
            decode(Binary, Encoding, Options)
    end;
decode(String, {Encoding, Ending}, Options) 
  when is_list(String), is_atom(Encoding), is_atom(Ending), is_list(Options) ->
    case catch list_to_binary(String) of
        {'EXIT',{badarg, _}} ->
            {error, {illegal_list, [{list, String}, {line, ?LINE}]}};
        Binary ->
            decode(Binary, {Encoding, Ending}, Options)
    end;
decode(Binary, Encoding, Options) 
  when is_binary(Binary), is_atom(Encoding), is_list(Options) ->
    gen_server:call(mb_server, {decode, Binary, Encoding, Options});
decode(Binary, {Encoding, Ending}, Options) 
  when is_binary(Binary), is_atom(Encoding), is_atom(Ending), is_list(Options) ->
    gen_server:call(mb_server, {decode, Binary, {Encoding, Ending}, Options}).
