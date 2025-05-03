%macro zero_array(ary);
  /*---- to hard to remember ----*/
  call stdize(
       'replace'
       ,'mult='
       ,0
       , of &ary[*]
       , _N_);
%mend zero_array;
