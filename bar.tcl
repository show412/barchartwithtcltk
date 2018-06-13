
proc 3drect {w args} {
   if [string is int -strict [lindex $args 1]] {
      set coords [lrange $args 0 3]
   } else {
      set coords [lindex $args 0]
   }
   foreach {x0 y0 x1 y1} $coords break
   set d [expr {($x1-$x0)/3}]
   set x2 [expr {$x0+$d+1}]
   set x3 [expr {$x1+$d}]
   set y2 [expr {$y0-$d+1}]
   set y3 [expr {$y1-$d-1}]
   set id [eval [list $w create rect] $args]
   set fill [$w itemcget $id -fill]
   set tag [$w gettags $id]
   $w create poly $x0 $y0 $x2 $y2 $x3 $y2 $x1 $y0 \
       -fill [dim $fill 0.8] -outline black
   $w create poly $x1 $y1 $x3 $y3 $x3 $y2 $x1 $y0 \
       -fill [dim $fill 0.6] -outline black -tag $tag
}


proc dim {color factor} {
  foreach i {r g b} n [winfo rgb . $color] d [winfo rgb . white] {
     set $i [expr int(255.*$n/$d*$factor)]
  }
  format #%02x%02x%02x $r $g $b
}


proc yscale {w x0 y0 y1 min max} {
  set dy   [expr {$y1-$y0}]
  regexp {([1-9]+)} $max -> prefix
  set stepy [expr {1.*$dy/$prefix}]
  set step [expr {$max/$prefix}]
  set y $y0
  set label $max
  while {$label>=$min} {
     $w create text $x0 $y -text $label -anchor w
     set y [expr {$y+$stepy}]
     set label [expr {$label-$step}]
  }
  expr {$dy/double($max)}
}


proc roughly {n {sgn +}} {
  regexp {(.+)e([+-])0*(.+)} [format %e $n] -> mant sign exp
  set exp [expr $sign$exp]
  if {abs($mant)<1.5} {
     set mant [expr $mant*10]
     incr exp -1
  }
  set t [expr round($mant $sgn 0.49)*pow(10,$exp)]
  expr {$exp>=0? int($t): $t}
}

# So here is my little bar chart generator. Given a canvas pathname,

proc bars {w x0 y0 x1 y1 data} {
   set vals 0
   foreach bar $data {
      lappend vals [lindex $bar 1]
   }
   set top [roughly [max $vals]]
   set bot [roughly [min $vals] -]
   set f [yscale $w $x0 $y0 $y1 $bot $top]
   set x [expr $x0+30]
   set dx [expr ($x1-$x0-$x)/[llength $data]]
   set y3 [expr $y1-20]
   set y4 [expr $y1+10]
   $w create poly $x0 $y4 [expr $x0+30] $y3 $x1 $y3 [expr $x1-20] $y4 -fill gray65
   set dxw [expr $dx*6/10]
   foreach bar $data {
      foreach {txt val col} $bar break
      set y [expr {round($y1-($val*$f))}]
      set y1a $y1
      if {$y>$y1a} {swap y y1a}
      set tag [expr {$val<0? "d": ""}]
      3drect $w $x $y [expr $x+$dxw] $y1a -fill $col -tag $tag
      $w create text [expr {$x+12}] [expr {$y-12}] -text $val
      $w create text [expr {$x+12}] [expr {$y1a+2}] -text $txt -anchor n
      incr x $dx
   }
   $w lower d
}

# proc barss {w x0 y0 x1 y1} {
#    set vals 0
#    foreach bar $data {
#       lappend vals [lindex $bar 1]
#    }
#    set top [roughly [max $vals]]
#    set bot [roughly [min $vals] -]
#    set f [yscale $w $x0 $y0 $y1 $bot $top]
#    set x [expr $x0+30]
#    set dx [expr ($x1-$x0-$x)/[llength $data]]
#    set y3 [expr $y1-20]
#    set y4 [expr $y1+10]
#    $w create poly $x0 $y4 [expr $x0+30] $y3 $x1 $y3 [expr $x1-20] $y4 -fill gray65
#    set dxw [expr $dx*6/10]

#       # foreach {txt val col} $bar break
#       set y [expr {round($y1-($a*$f))}]
#       set y1a $y1
#       if {$y>$y1a} {swap y y1a}
#       set tag [expr {$a<0? "d": ""}]
#       3drect $w $x $y [expr $x+$dxw] $y1a -fill "bule" -tag $tag
#       $w create text [expr {$x+12}] [expr {$y-12}] -text $a
#       $w create text [expr {$x+12}] [expr {$y1a+2}] -text "A" -anchor n
#       incr x $dx

#    $w lower d
# }



# Generally useful helper functions:

proc max list {
   set res [lindex $list 0]
   foreach e [lrange $list 1 end] {
      if {$e>$res} {set res $e}
   }
   set res
}
proc min list {
   set res [lindex $list 0]
   foreach e [lrange $list 1 end] {
      if {$e<$res} {set res $e}
   }
   set res
}
proc swap {_a _b} {
   upvar 1 $_a a $_b b
   foreach {a b} [list $b $a] break
}


# set a [string match {[a-zA-Z]*[a|A][a-zA-Z]*} $argv]
# regexp {([A-Z,a-z]*).([A|a]*)} $argv a b
set a [regexp -all {[A|a]} $argv]
set b [regexp -all {[B|b]} $argv]
set c [regexp -all {[C|c]} $argv]
set d [regexp -all {[D|d]} $argv]
set e [regexp -all {[E|e]} $argv]
set f [regexp -all {[F|f]} $argv]
set g [regexp -all {[G|g]} $argv]
set h [regexp -all {[H|h]} $argv]
set i [regexp -all {[I|i]} $argv]
set j [regexp -all {[J|j]} $argv]
set k [regexp -all {[K|k]} $argv]
set l [regexp -all {[L|l]} $argv]
set m [regexp -all {[M|m]} $argv]
set n [regexp -all {[N|n]} $argv]
set o [regexp -all {[O|o]} $argv]
set p [regexp -all {[P|p]} $argv]
set q [regexp -all {[Q|q]} $argv]
set r [regexp -all {[R|r]} $argv]
set s [regexp -all {[S|s]} $argv]
set t [regexp -all {[T|t]} $argv]
set u [regexp -all {[U|u]} $argv]
set v [regexp -all {[V|v]} $argv]
set w [regexp -all {[W|w]} $argv]
set x [regexp -all {[X|x]} $argv]
set y [regexp -all {[Y|y]} $argv]
set z [regexp -all {[Z|z]} $argv]

set input [list "A $a blue"]
lappend input "B $b blue"
lappend input "C $c blue"
lappend input "D $d blue"
lappend input "E $e blue"
lappend input "F $f blue"
lappend input "G $g blue"
lappend input "H $h blue"
lappend input "I $i blue"
lappend input "J $j blue"
lappend input "K $k blue"
lappend input "L $l blue"
lappend input "M $m blue"
lappend input "N $n blue"
lappend input "O $o blue"
lappend input "P $p blue"
lappend input "Q $q blue"
lappend input "R $r blue"
lappend input "S $s blue"
lappend input "T $t blue"
lappend input "U $u blue"
lappend input "V $v blue"
lappend input "W $w blue"
lappend input "X $x blue"
lappend input "Y $y blue"
lappend input "Z $z blue"

pack [canvas .c -width 480 -height 560]
bars .c 10 20 480 460 $input
# barss .c 10 20 480 460
.c create text 120 10 -anchor nw -font {Helvetica 18} -text "Bar Chart"
