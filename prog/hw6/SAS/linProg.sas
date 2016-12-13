/* set up data path */
FILENAME inputs '../data/inputs.xls';
FILENAME outputs '../data/outputs.xls';

/* import inputs and outputs */
PROC IMPORT DATAFILE = inputs
    DBMS = xls
    OUT = WORK.inputs;
    GETNAMES = no;
PROC IMPORT DATAFILE = outputs
    DBMS = xls
    OUT = WORK.outputs;
    GETNAMES = no;
RUN;

/* question 1 */
proc IML;
    use work.inputs;
    read all into I; /* read inputs matrix I */
    use work.outputs;
    read all into O; /* read outputs matrix O */
    m = nrow(I);
    n1 = ncol(I);
    n2 = ncol(O);
    a_d = repeat(0, m, n2) || I;
    b_d = O || repeat(0, m, n1);
    c_d = O || - I;
    OI = O || I;
    rowsense = repeat('L', m, 1) // 'E';
    cntl= 1; /* for minimization */
    /* placeholder of x */
    x = repeat(0, m, n1 + n2);
    b = repeat(0, m, 1) // 1;
    do i = 1 to m;
        A = c_d // b_d[i, ];
        call lpsolve(rc, obj, sol, dual, redu, a_d[i, ], A, b, cntl, rowsense, ,
            repeat(0, 1, n1 + n2));
        x[i, ] = sol`;
        end;
    res_1 = x # OI;
    x_1 = res_1[, 1 : n2];
    x_2 = res_1[, (n2 + 1) : (n1 + n2)];
    numer = x_1[, +];
    denom = x_2[, +];
    efficiency = numer / denom;
    print numer, denom, efficiency;
run;

/* question 2 */
proc IML;
    use work.inputs;
    read all into I; /* read inputs matrix I */
    use work.outputs;
    read all into O; /* read outputs matrix O */
    m = nrow(I);
    n1 = ncol(I);
    n2 = ncol(O);
    a_d = repeat(0, m, n2) || I;
    /* b_d = O || repeat(0, m, n1); */
    c_d = O || - I;
    OI = O || I;
    rowsense = repeat('L', m, 1) // 'E';
    cntl= - 1; /* for maximization */
    /* placeholder of x */
    x = repeat(0, m, n1 + n2);
    b = repeat(0, m, 1) // 1;
    do i = 1 to m;
        A = c_d // a_d[i, ];
        call lpsolve(rc, obj, sol, dual, redu, c_d[i, ], A, b, cntl, rowsense, ,
            repeat(0, 1, n1 + n2));
        x[i, ] = sol`;
        end;
    res_2 = x # OI;
    x_1 = res_2[, 1 : n2];
    x_2 = res_2[, (n2 + 1) : (n1 + n2)];
    inSum = x_2[, +];
    outSum = x_1[, +];
    diff = outSum - inSum;
    efficiency = outSum / inSum;
    print inSum, outSum, diff, efficiency;
run;
