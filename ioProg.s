*----------------------------------------------------------------------
*
        ORG     $0
        DC.L    $3000           * Stack pointer value after a reset
        DC.L    start           * Program counter value after a reset
        ORG     $3000           * Start at location 3000 Hex
*
*----------------------------------------------------------------------
* Macro Imports
#minclude /home/cs/faculty/riggins/bsvc/macros/iomacs.s
#minclude /home/cs/faculty/riggins/bsvc/macros/evtmacs.s
*
*----------------------------------------------------------------------
*
* Register use
*
*----------------------------------------------------------------------
*
start:  initIO                  * Initialize (required for I/O)
        setEVT                  * Error handling routines
*       initF                   * For floating point macros only

        lineout         title   * Your code goes HERE
        lineout         skipln
        lineout         prompt
        linein          buffer
        lineout         skipln          *prints out the input stage of program
        cvta2           buffer,#2       *Stores 2s comp in 2 bytes in buffer
        subi.l          #1,D0           *changes from month to index
        move.l          D0,D1           *copies the index into D1 from D0
        mulu            #10,D0          *offset for month array
        lea             month,A0
        adda.l          D0,A0           *add month array offset to point to the correct month
        move.l          (A0)+,date      *copy A0 contents (months) into the date output buffer
        move.l          (A0)+,date+4
        move.l          (A0)+,date+8
        lea             date,A0         *load output buffer into A0
        lea             length,A1       *load lengths of each month into A1
        mulu            #4,D1           *offset for length array
        adda.l          D1,A1           *add offset to select correct length
        adda.l          (A1),A0         *point to right month length. add that length
        move.b          #' ',(A0)+
        move.b          buffer+3,(A0)+  *putting date in output
        move.b          buffer+4,(A0)+
        suba.l          #2,A0           *reset pointer
        stripp          (A0),#2         *remove leading zeros from day
        adda.l          D0,A0           *move to year
        move.b          #',',(A0)+
        move.b          #' ',(A0)+
        move.b          buffer+6,(A0)+  *copy year to output
        move.b          buffer+7,(A0)+
        move.b          buffer+8,(A0)+
        move.b          buffer+9,(A0)+
        move.b          #'.',(A0)+
        clr.b           (A0)            *null terminate
        lineout         answer          *print desired output

        break                   * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations
length: dc.l    7,8,5,5,3,4,4,6,9,7,8,8
month:  dc.b    'January   '
        dc.b    'February  '
        dc.b    'March     '
        dc.b    'April     '
        dc.b    'May       '
        dc.b    'June      '
        dc.b    'July      '
        dc.b    'August    '
        dc.b    'September '
        dc.b    'October   '
        dc.b    'November  '
        dc.b    'December  '
title:  dc.b    'Program #1, Will Gebbie, cssc0200',0
skipln: dc.b    0,0
prompt: dc.b    'Enter a date in the form MM/DD/YYYY',0
answer: dc.b    'The date entered is '
date:   ds.b    24
buffer: ds.b    82


                                * Your storage declarations go
                                * HERE
        end