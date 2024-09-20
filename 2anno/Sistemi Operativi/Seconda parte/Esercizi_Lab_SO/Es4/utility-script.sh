echo "MENU: ";
echo "1) Visualizza i processi di un utente selezionato";
echo "2) Top minimale (con ordinamento in base alla CPU)";
echo "3) Kill -9 su un processo utente, su tutti i processi";
echo " ";
echo "Scegli una delle opzioni: ";

read opt;
if [ $opt -lt 1 -o $opt -gt 4 ]
then
echo "Scelta non valida!";
fi

case $opt in
1) echo "inserisci il nome di un utente:"
read username; ps -u $username ;;
2) top ;;
3) echo "inserisci il PID del processo da eliminare:";
read pid;kill -9 $pid ;;
esac