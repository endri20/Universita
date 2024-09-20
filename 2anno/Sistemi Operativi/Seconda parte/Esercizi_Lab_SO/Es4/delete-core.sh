if test $# -ne 1
then
echo 'Utilizzo dello script: rmcore <dir>'
exit 1
fi

if ! test -d $1 # Gestione degli errori.
then
echo "$1 deve essere una directory"
exit 2
fi

find $1 -name core -exec rm {} \; 2>/dev/null

exit 0