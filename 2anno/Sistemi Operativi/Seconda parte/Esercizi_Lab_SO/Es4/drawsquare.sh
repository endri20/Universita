if test $# -ne 1
   then
   echo 'Utilizzo dello script: drawsquare <n>'
   exit 1
fi

if test $1 -le 2 -o $1 -ge 51
   then
   echo 'Il parametro deve essere un numero in [3;50]'
   exit 2
fi
x=$1 
y=$1 
while test $y -gt 0
   do
   while test $x -gt 0
   	 do
	 if test $x -eq 1 -o $x -eq $1
	    then 
	    if test $y -eq 1 -o $y -eq $1
	       then
	       echo -n "+ "
	    else
	       echo -n "| "
	    fi
	 else 
	      if test $y -eq 1 -o $y -eq $1
		 then
		 echo -n "- "
	      else
		 echo -n "  "
	      fi
	 fi
	 x=$[$x-1]
   done
   x=$1
   y=$[$y-1]
   echo
done
exit 0
