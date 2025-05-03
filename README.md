# utl-dumify-a-crossover-clinical-trial-design-sas-with-and-without-macro-arrays
Dumify a crossover clinical trial design sas with and without macro arrays
    %let pgm=utl-dumify-a-crossover-clinical-trial-design-sas-with-and-without-macro-arrays;

    %stop_submission;

    Dumify a crossover clinical trial design sas with and without macro arrays

             CONTENTS

               1 sas no macro arrays
               2 sas macro arrays
               3 zero array maco on end and
                 https://tinyurl.com/y9nfugth

    github
    https://tinyurl.com/smr2uzyd
    https://github.com/rogerjdeangelis/utl-dumify-a-crossover-clinical-trial-design-sas-with-and-without-macro-arrays

    communities.sas.com
    https://tinyurl.com/2r4mb3r2
    https://communities.sas.com/t5/SAS-Programming/How-to-reformat-data-from-long-to-wide-with-dichotomizing-and/m-p/816425#M322247

    macros
    https://tinyurl.com/y9nfugth
    https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

    related repos
    https://github.com/rogerjdeangelis/utl-creating-dummy-variables-for-classification-variable-in-modeling
    https://github.com/rogerjdeangelis/utl-dummification-for-model-building-based-on-column-variable
    https://github.com/rogerjdeangelis/utl_how_to_turn_categorical_variable_into_dummies


    /***************************************************************************************************************************/
    /*                INPUT           |         PROCESS                             | OUTPUT                                   */
    /*                =====           |         =======                             | ======                                   */
    /*                                |                                             |                                          */
    /*            ARM1_    ARM2_      | Think of eight week crossover               |INPUT           ARM1_    ARM2_            */
    /* SUBJECT     WEEK     WEEK      | clinical trial. Four weeks for              |    SUBJECT     WEEK     WEEK             */
    /*                                | first arm and then another four             |      1          2         4              */
    /*    1         2        4        | weeks for arm2.                             |                                          */
    /*    2         1        3        | Dosing is done on different                 | Subject 1 is dosed on week2 for arm1     */
    /*    3         2        4        | weeks for arm1 and arm2.                    | and week 4 for arm2                      */
    /*    4         3        4        |                                             |                                          */
    /*    5         1        3        | Loosely realted to a latin square           |    ARM1 DOSE WEEK      ARM2 DOSE WEEK    */
    /*                                | statistical sesign.                         | S  =================   ================  */
    /* data have;                     |                                             | U   A    A    A    A   A    A    A    A  */
    /*  input  subject $1.            |                                             | B   R    R    R    R   R    R    R    R  */
    /*  (arm1_week arm2_week)(hex2.); |                                             | J   M    M    M    M   M    M    M    M  */
    /*     arm1_week =arm1_week -9;   |    SUBJECT     WEEK     WEEK                | E   1    1    1    1   2    2    2    2  */
    /*     arm2_week =arm2_week -9;   |      1          2         4                 | C   W    W    W    W   W    W    W    W  */
    /*   cards4;                      |                                             | T   1    2    3    4   1    2    3    4  */
    /* 1 B D                          | Subject 1 is dosed on week2 for arm1        | --------------------   ----------------  */
    /* 2 A C                          | and week 4 for arm2                         | 1   0    1*   0    0   0    0    0    1* */
    /* 3 B D                          |                                             | 2   1    0    0    0   0    0    1    0  */
    /* 4 C D                          |                SOLUTION                     | 3   0    1    0    0   0    0    0    1  */
    /* 5 A C                          |                                             | 4   0    0    1    0   0    0    0    1  */
    /* ;;;;                           | S.       ARM1                ARM2           | 5   1    0    0    0   0    0    1    0  */
    /* run;quit;                      | == ================+    =================   |                                          */
    /*                                |     W1   W2   W3   W4    W1   W2   W3   W4  |                                          */
    /*                                |                                             |                                          */
    /* proc print data=want           |  1  0    1*   0    0     0    0    0    1   |                                          */
    /* heading=vertical;              |  2  1    0    0    0     0    0    1    0   |                                          */
    /* run;quit;                      |  3  0    1    0    0     0    0    0    1   |                                          */
    /*                                |  4  0    0    1    0     0    0    0    1   |                                          */
    /*                                |  5  1    0    0    0     0    0    1    0   |                                          */
    /*                                |                                             |                                          */
    /*                                |  *            ARM1_    ARM2_                |                                          */
    /*                                |    SUBJECT     WEEK     WEEK                |                                          */
    /*                                |      1          2         4                 |                                          */
    /*                                |                                             |                                          */
    /*                                | Subject 1 is dosed on week2 for arm1        |                                          */
    /*                                | and week 4 for arm2                         |                                          */
    /*                                |                                             |                                          */
    /*                                |                                             |                                          */
    /*                                |                                             |                                          */
    /*                                | 1 SAS NO MACRO ARRAYS                       |                                          */
    /*                                | ======================                      |                                          */
    /*                                |                                             |                                          */
    /*                                | * Untility;                                 |                                          */
    /*                                | %macro zero_array(ary);                     |                                          */
    /*                                |   /*---- to hard to remember ----*/         |                                          */
    /*                                |   call stdize(                              |                                          */
    /*                                |        'replace'                            |                                          */
    /*                                |        ,'mult='                             |                                          */
    /*                                |        ,0                                   |                                          */
    /*                                |        , of &ary[*]                         |                                          */
    /*                                |        , _N_);                              |                                          */
    /*                                | %mend zero_array;                           |                                          */
    /*                                |                                             |                                          */
    /*                                | data want;                                  |                                          */
    /*                                |    length subject $1.;                      |                                          */
    /*                                |    array weeks[1:2,1:4]                     |                                          */
    /*                                |         arm1w1 arm1w2 arm1w3 arm1w4         |                                          */
    /*                                |         arm2w1 arm2w2 arm2w3 arm2w4 (8*0);  |                                          */
    /*                                |    set have;                                |                                          */
    /*                                |    array arms[1:2] arm1_week arm2_week;     |                                          */
    /*                                |    %zero_array(weeks);                      |                                          */
    /*                                |    do arm=1 to dim(arms);                   |                                          */
    /*                                |      do week=1 to dim(weeks,2);;            |                                          */
    /*                                |        weeks[arm,arms[arm]]=1;              |                                          */
    /*                                |      end;                                   |                                          */
    /*                                |    end;                                     |                                          */
    /*                                |    drop arm1_week arm2_week arm week;       |                                          */
    /*                                | run;quit;                                   |                                          */
    /*                                |                                             |                                          */
    /*                                |                                             |                                          */
    /*                                |                                             |                                          */
    /*                                | 1 SAS MACRO ARRAYS                          |                                          */
    /*                                | ==================                          |                                          */
    /*                                |                                             |                                          */
    /*                                | %array(_arms,values=1-2);                   |                                          */
    /*                                | %array(_weeks,values=1-4);                  |                                          */
    /*                                |                                             |                                          */
    /*                                | data want;                                  |                                          */
    /*                                |  length subject $1.;                        |                                          */
    /*                                |  array weeks[1:&_armsn,1:&_weeksn]          |                                          */
    /*                                |       %do_over(_weeks,phrase=arm1w?)        |                                          */
    /*                                |       %do_over(_weeks,phrase=arm2w?)        |                                          */
    /*                                |  ;                                          |                                          */
    /*                                |  set have;                                  |                                          */
    /*                                |  array arms[1:&_armsn] arm1_week arm2_week; |                                          */
    /*                                |  %zero_array(weeks);                        |                                          */
    /*                                |  do arm=1 to dim(arms);                     |                                          */
    /*                                |    do week=1 to dim(weeks,&_arms1);;        |                                          */
    /*                                |      weeks[arm,arms[arm]]=1;                |                                          */
    /*                                |    end;                                     |                                          */
    /*                                |  end;                                       |                                          */
    /*                                |  drop arm1_week arm2_week arm week;         |                                          */
    /*                                | run;quit;                                   |                                          */
    /***************************************************************************************************************************/

    /*                   _
    (_)_ __  _ __  _   _| |_
    | | `_ \| `_ \| | | | __|
    | | | | | |_) | |_| | |_
    |_|_| |_| .__/ \__,_|\__|
            |_|
    */

    data have;
     input  subject $1.
     (arm1_week arm2_week)(hex2.);
        arm1_week =arm1_week -9;
        arm2_week =arm2_week -9;
      cards4;
    1 B D
    2 A C
    3 B D
    4 C D
    5 A C
    ;;;;
    run;quit;

    /**************************************************************************************************************************/
    /*             ARM1_    ARM2_                                                                                             */
    /*  SUBJECT     WEEK     WEEK                                                                                             */
    /*                                                                                                                        */
    /*     1         2        4                                                                                               */
    /*     2         1        3                                                                                               */
    /*     3         2        4                                                                                               */
    /*     4         3        4                                                                                               */
    /*     5         1        3                                                                                               */
    /**************************************************************************************************************************/

    /*
    / |  ___  __ _ ___   _ __   ___    _ __ ___   __ _  ___ _ __ ___    __ _ _ __ _ __ __ _ _   _
    | | / __|/ _` / __| | `_ \ / _ \  | `_ ` _ \ / _` |/ __| `__/ _ \  / _` | `__| `__/ _` | | | |
    | | \__ \ (_| \__ \ | | | | (_) | | | | | | | (_| | (__| | | (_) || (_| | |  | | | (_| | |_| |
    |_| |___/\__,_|___/ |_| |_|\___/  |_| |_| |_|\__,_|\___|_|  \___/  \__,_|_|  |_|  \__,_|\__, |
                                                                                            |___/
    */

    %macro zero_array(ary);
      /*---- to hard to remember ----*/
      call stdize(
           'replace'
           ,'mult='
           ,0
           , of &ary[*]
           , _N_);
    %mend zero_array;

    data want;
       length subject $1.;
       array weeks[1:2,1:4]
            arm1w1 arm1w2 arm1w3 arm1w4
            arm2w1 arm2w2 arm2w3 arm2w4 (8*0);
       set have;
       array arms[1:2] arm1_week arm2_week;
       %zero_array(weeks);
       do arm=1 to dim(arms);
         do week=1 to dim(weeks,2);;
           weeks[arm,arms[arm]]=1;
         end;
       end;
       drop arm1_week arm2_week arm week;
    run;quit;


    /**************************************************************************************************************************/
    /* Obs    SUBJECT    ARM1W1    ARM1W2    ARM1W3    ARM1W4    ARM2W1    ARM2W2    ARM2W3    ARM2W4                         */
    /*                                                                                                                        */
    /*  1        1          0         1         0         0         0         0         0         1                           */
    /*  2        2          1         0         0         0         0         0         1         0                           */
    /*  3        3          0         1         0         0         0         0         0         1                           */
    /*  4        4          0         0         1         0         0         0         0         1                           */
    /*  5        5          1         0         0         0         0         0         1         0                           */
    /**************************************************************************************************************************/

    /*___
    |___ \   ___  __ _ ___   _ __ ___   __ _  ___ _ __ ___    __ _ _ __ _ __ __ _ _   _
      __) | / __|/ _` / __| | `_ ` _ \ / _` |/ __| `__/ _ \  / _` | `__| `__/ _` | | | |
     / __/  \__ \ (_| \__ \ | | | | | | (_| | (__| | | (_) || (_| | |  | | | (_| | |_| |
    |_____| |___/\__,_|___/ |_| |_| |_|\__,_|\___|_|  \___/  \__,_|_|  |_|  \__,_|\__, |
                                                                                  |___/

    */

    %array(_arms,values=1-2);
    %array(_weeks,values=1-4);

    data want;
     length subject $1.;
     array weeks[1:&_armsn,1:&_weeksn]
          %do_over(_weeks,phrase=arm1w?)
          %do_over(_weeks,phrase=arm2w?)
     ;
     set have;
     array arms[1:&_armsn] arm1_week arm2_week;
     %zero_array(weeks);
     do arm=1 to dim(arms);
       do week=1 to dim(weeks,&_arms1);;
         weeks[arm,arms[arm]]=1;
       end;
     end;
     drop arm1_week arm2_week arm week;
    run;quit;


    /**************************************************************************************************************************/
    /* Obs    SUBJECT    ARM1W1    ARM1W2    ARM1W3    ARM1W4    ARM2W1    ARM2W2    ARM2W3    ARM2W4                         */
    /*                                                                                                                        */
    /*  1        1          0         1         0         0         0         0         0         1                           */
    /*  2        2          1         0         0         0         0         0         1         0                           */
    /*  3        3          0         1         0         0         0         0         0         1                           */
    /*  4        4          0         0         1         0         0         0         0         1                           */
    /*  5        5          1         0         0         0         0         0         1         0                           */
    /**************************************************************************************************************************/

    /*____
    |___ /   _______ _ __ ___     __ _ _ __ _ __ __ _ _   _  _ __ ___   __ _  ___ _ __ ___
      |_ \  |_  / _ \ `__/ _ \   / _` | `__| `__/ _` | | | || `_ ` _ \ / _` |/ __| `__/ _ \
     ___) |  / /  __/ | | (_) | | (_| | |  | | | (_| | |_| || | | | | | (_| | (__| | | (_) |
    |____/  /___\___|_|  \___/   \__,_|_|  |_|  \__,_|\__, ||_| |_| |_|\__,_|\___|_|  \___/
                                                      |___/
    */

    /*---- save in autocall library ----*/

    filename ft15f001 "c:/oto/zero_array.sas";
    parmcards4;
    %macro zero_array(ary);
      /*---- to hard to remember ----*/
      call stdize(
           'replace'
           ,'mult='
           ,0
           , of &ary[*]
           , _N_);
    %mend zero_array;
    ;;;;
    run;quit;


    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */
