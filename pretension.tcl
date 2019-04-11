toplevel .pretension

set fp [open "Data.txt" r]
set file_data [read $fp]
set data [split $file_data "\n"]
close $fp

image create photo fig -file "fig.png"
label .pretension.pic -image fig

######################################################
##                  initial data                    ##
######################################################
set thread_list {}
set ds 12
set M 10000     ;#tightening torque
set cf 0.2      ;#friction coeffitient
set cf1 0.2     ;#friction coeffitient
set pi 3.1415926535897931
set alfa [expr {30*$pi/180}] ;#for metric threads 30 degree

foreach thread $data {
    lappend thread_list [lindex $thread 0]
}


######################################################
##                  window layout                   ##
######################################################
ttk::combobox .pretension.s2 -values $thread_list -textvariable thread1
.pretension.s2 current 0

ttk::label .pretension.title -text "Pretension force"
ttk::label .pretension.thread -text "Choose thread"
ttk::label .pretension.lp -text "P \[mm\]"
ttk::label .pretension.ld2 -text "d2 \[mm\]"
ttk::label .pretension.lm -text "M \[Nmm\]"             ;#tightening torque
ttk::label .pretension.space -text " " -width 5
ttk::label .pretension.mu -text \u03BC                  ;#friction coeffitient
ttk::label .pretension.mu1 -text \u03BC1                ;#friction coeffitient
ttk::label .pretension.ds -text "ds \[mm\]"
ttk::label .pretension.f -text F                        ;#pretension force
.pretension.f configure -font "-weight bold"


ttk::entry .pretension.eM -textvariable M -width 10
ttk::entry .pretension.p -textvariable p -width 10 -state readonly
ttk::entry .pretension.d2 -textvariable d2 -width 10 -state readonly
ttk::entry .pretension.emu -textvariable cf -width 10
ttk::entry .pretension.emu1 -textvariable cf1 -width 10
ttk::entry .pretension.ef -textvariable Fnap -width 10 -state readonly
ttk::entry .pretension.eds -textvariable ds -width 10

#reading data from DATA.txt
ttk::button .pretension.load -text Load -command {
    set p [lindex [lindex $data [lsearch $thread_list [.pretension.s2 get]]] 1]
    set d2 [lindex [lindex $data [lsearch $thread_list [.pretension.s2 get]]] 2]
}

######################################################
##                  calculations                    ##
######################################################
ttk::button .pretension.run -text Run -command {
    set gamma [expr {atan($p/($pi*$d2))}]
    set rho [expr {atan($cf/cos($alfa))}]
    set Fnap [expr {double(round(100*(2*$M)/($ds*$cf+$d2*tan($gamma+$rho))))/100}]
}

ttk::button .pretension.close -text Close -command {destroy .pretension}

grid .pretension.pic -column 0 -rowspan 10 -row 0 -padx 5
grid .pretension.title -column 1 -columnspan 8 -row 1

grid .pretension.thread -row 3 -column 3 -columnspan 4 -sticky sw
grid .pretension.s2 -row 4 -column 3 -columnspan 3

grid .pretension.lp -row 5 -column 3
grid .pretension.p -row 5 -column 4

grid .pretension.space -column 5

grid .pretension.ld2 -row 5 -column 6 -padx 5
grid .pretension.d2 -row 5 -column 7 -padx 5

grid .pretension.mu -row 6 -column 3
grid .pretension.emu -row 6 -column 4

grid .pretension.mu1 -row 6 -column 6 -padx 5
grid .pretension.emu1 -row 6 -column 7 -padx 5


grid .pretension.lm -row 7 -column 3
grid .pretension.eM -row 7 -column 4

grid .pretension.ds -row 7 -column 6 -padx 5
grid .pretension.eds -row 7 -column 7 -padx 5

grid .pretension.f -row 8 -column 3 -columnspan 2 -sticky e
grid .pretension.ef -row 8 -column 5 -columnspan 2


grid .pretension.load -row 9 -column 4 -pady 10
grid .pretension.run -row 9 -column 5 -pady 10
grid .pretension.close -row 9 -column 6 -pady 10


tkwait window .pretension
