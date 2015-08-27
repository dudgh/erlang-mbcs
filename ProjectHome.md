## Support encodings ##
### encodings ###
cp037 | cp437 | cp500 | cp737 | cp775 | cp850 | cp852 | cp855 | cp857 | cp860 | cp861 | cp862 | cp863 | cp864 | cp865 | cp866 | cp869 | cp874 | cp875 | cp932 | cp936 | cp949 | cp950 | cp1026 | cp1250 | cp1251 | cp1252 | cp1253 | cp1254 | cp1255 | cp1256 | cp1257 | cp1258 | cp10000 | cp10006 | cp10007 | cp10029 | cp10079 | cp10081 | utf8 | utf16 | utf16le | utf16be | utf32 | utf32le | utf32be

### encoding alias table ###
| gbk   | cp936 |
|:------|:------|
| big5  | cp950 |
see mbcs.conf for encoding config details.

## Why? ##
|        Compare       | erlang-mbcs | cean-iconv |
|:---------------------|:------------|:-----------|
|unicode support       | Yes         | No         |
|regex(re.erl) support | Yes         | No         |
|error strategy        | Yes         | No         |
|pure erlang           | Yes         | No         |

## Interface ##
see mb.html http://erlang-mbcs.googlecode.com/svn/trunk/doc/mb.html and mb.erl http://erlang-mbcs.googlecode.com/svn/trunk/src/mb.erl for detail.

## Examples ##

**NOTE: these examples are running in werl，(werl think "世界，你好" as unicode)
```
Erlang R13B03 (erts-5.7.4) [smp:2:2] [rq:2] [async-threads:0]

Eshell V5.7.4  (abort with ^G)
1> l(mbcs).
{module,mb}

2> mbcs:start().
ok

3> mbcs:encode("世界，你好", gbk).
<<"ÊÀ½ç£¬ÄãºÃ">>

4> mbcs:encode("世界，你好", big5).
<<"¥@¬É¡A§A¦n">>

5> mbcs:encode("世界，你好,我爱你们", cp950).
{error,{cannot_encode,[{reson,unmapping_unicode},
                       {unicode,29233},
                       {pos,8}]}}

6> mbcs:encode("世界，你好, 我爱你们", cp950, [{error, ignore}]).
<<"¥@¬É¡A§A¦n, §Ú§A">>

7> mbcs:encode("世界，你好, 我爱你们", cp950, [{error, ignore}, {return, list}]).
"¥@¬É¡A§A¦n, §Ú§A"

8> mbcs:encode("世界，你好, 我爱你们", cp950, [{error, replace}, {return, list}]).
"¥@¬É¡A§A¦n, §Ú?§A?"

9> mbcs:encode("世界，你好, 我爱你们", cp950, [{replace, $_}, {return, list}]).
"¥@¬É¡A§A¦n, §Ú_§A_"

10> S=mbcs:encode("世界，你好", gbk).
<<"ÊÀ½ç£¬ÄãºÃ">>

11> io:format(mbcs:decode(S, gbk)).
世界，你好ok

12> mbcs:decode(S, gbk).           
[19990,30028,65292,20320,22909]

13> mbcs:decode("\xff", gbk).
{error,{cannot_decode,[{reason,undefined_character},
                       {char,255},
                       {pos,1}]}}

14> mbcs:decode("\xff", cp936, [{error, ignore}]).
[]

15> mbcs:decode("\xff", cp936, [{error, replace}]).
[65533]

16> mbcs:decode("\xff", cp936, [{replace, $_}]).
"_"
```**

## Implement ##
```
binary/bitstring syntax
term_to_binary/binary_to_term Serialization
gen_server
```