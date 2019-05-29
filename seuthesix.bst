%%
%% This is file `seuthesix.bst',
%% This file provides bibliography style for ``seuthesix''.
%% Copyright (c) 2007--2012 Xu Yuan, email: xuyuan.cn@gmail.com
%% Copyright (c) 2016 James Fan, email: zhimengfan1990@163.com
%% License: GNU General Public License, version 3
%%This file is part of ``seuthesix'' package.
%%``seuthesix'' is free software: you can redistribute it and/or modify
%%it under the terms of the GNU General Public License as published by
%%the Free Software Foundation, either version 3 of the License, or
%%(at your option) any later version.
%%``seuthesix'' is distributed in the hope that it will be useful,
%%but WITHOUT ANY WARRANTY; without even the implied warranty of
%%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%GNU General Public License for more details.
%%
%%You should have received a copy of the GNU General Public License
%%along with this program.  If not, see <http://www.gnu.org/licenses/>.




ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
	language
	day
	translator
	applicant % for patent applicant
	country % for patent country 
	littype% for patent literature type
	pid %for patent id
	url% website
	stdcode % standard code
	newspaper % title of newspaper
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {en.output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {zh.output.nonnull}     % Chinese version of output.nonnull
{ 's :=
  output.state mid.sentence =
    { "，" * write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output.nonnull}
{
language missing$
{en.output.nonnull}
{zh.output.nonnull}
if$
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
	{
     output.nonnull
	}
  if$
}


FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
	{
	 output.nonnull
	}
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {en.format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames #4 >
  {#4 'numnames :=}
  'skip$
  if$
  
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{vv~}{ll}{, ff}{, jj}" format.name$ 't :=
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            { numnames #2 >
                { "," * }
                'skip$
              if$
              t "others" =
			  numnames #4 =
			  or
                { " et~al." * }
                { " and " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {zh.format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames #4 >
  {#4 'numnames :=}
  'skip$
  if$
  
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{vv~}{ll}{, ff}{, jj}" format.name$ 't :=
      nameptr #1 >
        { namesleft #1 >
            { "，" * t * }
            {   "，" * 
			  numnames #4 =
                { "et~al." * }
                { t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.names}
{
language missing$
	{ en.format.names}
	{ zh.format.names}
	if$	
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    {author format.names
	}
  if$
}

FUNCTION {format.applicants}
{ applicant empty$
    { "" }
    {applicant format.names
	}
  if$
}


FUNCTION {en.format.editors}
{ editor empty$
    { "" }
	{editor format.names
      editor num.names$ #1 >
        { ", eds." * }  % change editors to eds. , editor to ed.
        { ", ed." * }
      if$
    }
  if$
}

FUNCTION {zh.format.editors}
{ editor empty$
    { "" }
	{editor format.names
        "，主编" * 
    }
  if$
}

FUNCTION {format.editors}
{
language missing$
{en.format.editors}
{zh.format.editors}
if$


}



FUNCTION {en.format.translators}
{ translator empty$
    { "" }
	{ translator format.names
      translator num.names$ #1 >
        { ", transls." * }  
        { ", transl." * }
      if$
    }
  if$
}

FUNCTION {zh.format.translators}
{ translator empty$
    { "" }
	{ translator format.names
      translator num.names$ #1 >
        { "，等译" * }  
        { "，译" * }
      if$
    }
  if$
}

FUNCTION {format.translators}
{
language missing$
{en.format.translators}
{zh.format.translators}
if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { language missing$
	{title}
	{title}
	if$
	}
  if$  
}



FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {format.year.month.day}
{ year empty$
    { month empty$
        { day empty$
		  {""}
		  'day
		  if$
	    }
        { day empty$
          'month
		  {month "-" * day *}
		  if$
        }
      if$
    }
   { month empty$
        { day empty$
		  {year}
		  {"There is year and day, but no month." warning$ 
		  year "-" * "[" *
		  language missing$
		  {month empty}
		  {缺少月份}
		  if$
		  "]-" * day *
		  }
		  if$
	    }
        { day empty$
          {year "-" * month *}
		  {year "-" * month * "-" * day *}
		  if$
        }
      if$
    }
	if$
}


FUNCTION {format.btitle}
{ format.title
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {en.format.bvolume}
{ volume empty$
    { "" }
    { "volume" volume tie.or.space.connect
      series empty$
        'skip$
        { " of " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {zh.format.bvolume}
{ volume empty$
    { "" }
    { "卷" volume tie.or.space.connect
      series empty$
        'skip$
        { " 于" * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.bvolume}
{
language missing$
'en.format.bvolume
'zh.format.bvolume
if$
}



FUNCTION {en.format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { output.state mid.sentence =
            { "number" }
            { "Number" }
          if$
          number tie.or.space.connect
          series empty$
            { "there's a number but no series in " cite$ * warning$ }
            { " in " * series * }
          if$
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {zh.format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { "期"
          number tie.or.space.connect
          series empty$
            { "there's a number but no series in " cite$ * warning$ }
            { " 于" * series * }
          if$
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.number.series}
{
language missing$
'en.format.number.series
'zh.format.number.series
if$
}

FUNCTION {en.format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
        { edition "l" change.case$ " edition" * }
        { edition "t" change.case$ " edition" * }
      if$
    }
  if$
}

FUNCTION {zh.format.edition}
{ edition empty$
    { "" }
    {edition}
  if$
}

FUNCTION {format.edition}
{
language missing$
'en.format.edition
'zh.format.edition
if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        { "pages" pages n.dashify tie.or.space.connect }
        { "page" pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.plain.pages}
{ pages empty$
    { "" }
    { pages n.dashify
    }
  if$
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null
  number empty$
    'skip$
    { "(" number * ")" * *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
        { ":" * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { "chapter" }
        { type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {en.format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { "In: " booktitle * }
        { "In: " format.editors * ", " * booktitle * }
      if$
    }
  if$
}

FUNCTION {zh.format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { "见：" booktitle * }
        { "见：" format.editors * "，" * booktitle * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{
language missing$
{en.format.in.ed.booktitle}
{zh.format.in.ed.booktitle}
if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}



FUNCTION {en.format.addr.press.year}
{
address empty$
{
publisher empty$
{year empty$
{""}
{year}
if$
}
{publisher 
year empty$
{skip$}
{", " * year *}
if$
}
if$
}

{address 
publisher empty$
year empty$
and
{skip$}
{
": " * publisher field.or.null *
year empty$
'skip$
{
", " * year field.or.null *
}
if$

}
if$
}
if$
}

FUNCTION {zh.format.addr.press.year}
{
address empty$
{
publisher empty$
{year empty$
{""}
{year}
if$
}
{publisher 
year empty$
{skip$}
{"，" * year *}
if$
}
if$
}

{address 
publisher empty$
year empty$
and
{skip$}
{
": " * publisher field.or.null *
year empty$
'skip$
{
"，" * year field.or.null *
}
if$

}
if$
}
if$
}

FUNCTION {format.addr.press.year}
{
language missing$
{en.format.addr.press.year}
{zh.format.addr.press.year}
if$

}

FUNCTION {en.format.addr.school.year}
{
address empty$
{
school empty$
{year empty$
{""}
{year}
if$
}
{school 
year empty$
{skip$}
{", " * year *}
if$
}
if$
}

{address 
school empty$
year empty$
and
{skip$}
{
": " * school field.or.null *
year empty$
'skip$
{
", " * year field.or.null *
}
if$

}
if$
}
if$
}

FUNCTION {zh.format.addr.school.year}
{
address empty$
{
school empty$
{year empty$
{""}
{year}
if$
}
{school 
year empty$
{skip$}
{"，" * year *}
if$
}
if$
}

{address 
school empty$
year empty$
and
{skip$}
{
": " * school field.or.null *
year empty$
'skip$
{
"，" * year field.or.null *
}
if$

}
if$
}
if$
}

FUNCTION {format.addr.school.year}
{
language missing$
{en.format.addr.school.year}
{zh.format.addr.school.year}
if$
}



FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  new.block
  
  format.title 
duplicate$ 
  empty$
  {"title" output.check}
{"[J]" * "title" output.check}
if$
new.block

    journal "journal" output.check
	
	 year "year" output.check
	 
     format.vol.num.pages output
  new.block
  
  note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
author empty$
{ format.editors "author and editor" output.check }
{
format.authors output.nonnull
 }
if$
 new.block 
 
format.btitle
duplicate$ 
  empty$
  {"title" output.check}
{"[M]" * "title" output.check}
if$

format.edition output
new.block

format.translators output 
new.block

format.addr.press.year output
new.block

format.plain.pages output
new.block

note output
fin.entry
}


FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  new.block
  
  title 
  duplicate$ empty$
  {skip$}
  {"[C]" * }
  if$
  "title" output.check
  new.block
  
  format.in.ed.booktitle  output 
  new.block
  
  format.addr.press.year output 
  new.block
  
  format.plain.pages output
  new.block

  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }


FUNCTION {en.mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  
  format.title 
  duplicate$ empty$
  'skip$
  {"[D]: [master's thesis]" *}
  if$
  "title" 
  output.check
  new.block
  
  format.addr.school.year "address or school or year" output.check
  new.block
  
  note output
  fin.entry
}

FUNCTION {zh.mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  
  format.title 
  duplicate$ empty$
  'skip$
  {"[D]: [硕士学位论文]" *}
  if$
  "title" 
  output.check
  new.block
  
  format.addr.school.year "address or school or year" output.check
  
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{
language missing$
{en.mastersthesis}
{zh.mastersthesis}
if$
}

FUNCTION {en.patent}
{
 output.bibitem
   format.applicants "applicants" output.check
 new.block
 
  format.title 
 duplicate$ empty$
  {skip$}
  {"[P]" *}
  if$
  "title" 
  output.check
  new.block
  
  littype output
  
  country empty$
  { skip$ }
  { country " patent" * }
  if$
  output
  pid output
  new.block
  
  format.year.month.day output
  new.block
  
  note output 
  fin.entry
}


FUNCTION {zh.patent}
{
 output.bibitem
   format.applicants "applicants" output.check
 new.block
 
 
  format.title 
  duplicate$ empty$
  {skip$}
  {"[P]" *}
  if$
  "title" output.check
  new.block
  
  littype output
  
   country empty$
  { skip$ }
  { country "专利" * }
  if$
  output
  pid output
  new.block
  
  format.year.month.day output
  new.block
  
  note output 
  fin.entry
}

FUNCTION {patent}
{
language missing$
{en.patent}
{zh.patent}
if$
}

FUNCTION {standard}
{
 output.bibitem
  format.authors "author" output.check
new.block

stdcode output

format.title 
duplicate$ empty$
{skip$}
{"[S]" * }
if$
"title" output.check
new.block

format.addr.press.year output
new.block

note output
fin.entry
}


FUNCTION {misc}
{ output.bibitem
  format.authors output
  new.block
  format.title 
  duplicate$ empty$
  'skip$
  {"[EB/OL]" * }
  if$
  output
  new.block
  
  url 
  duplicate$ empty$
  'skip$
  {pop$ "\url{" url * "}" * }
 if$
  output 
  new.block
  
  format.year.month.day output
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {en.phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  
  format.title 
  duplicate$ empty$
  'skip$
  {"[D]: [PhD thesis]" *}
  if$
  "title" 
  output.check
  new.block
  
  format.addr.school.year "address or school or year" output.check
  
  new.block
  note output
  fin.entry
}

FUNCTION {zh.phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  
  format.title 
  duplicate$ empty$
  'skip$
  {"[D]: [博士学位论文]" *}
  if$
  "title" 
  output.check
  new.block
  
  format.addr.school.year "address or school or year" output.check
  
  new.block
  note output
  fin.entry
}

FUNCTION {phdthesis}
{
language missing$
{en.phdthesis}
{zh.phdthesis}
if$
}

FUNCTION {news}
{
output.bibitem
  format.authors "author" output.check
  new.block
  
  format.title 
duplicate$ empty$
  'skip$
  {"[N]" *}
  if$
  "title" 
  output.check
  new.block
  
newspaper "newspaper" output.check

format.year.month.day output
format.plain.pages empty$
{ skip$} 
{"(" format.plain.pages * ")" * }
if$
output
new.block

  note output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
