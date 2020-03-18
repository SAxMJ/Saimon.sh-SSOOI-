FLAG=0

#echo "NUMCOLORES=$NUMCOLORES" > confi.cfg
#echo "ENTRETIEMPO=$TIEMPO" >> confi.cfg

cat confi.cfg | NUMCOLORES=0 TIEMPO=0 RUTA=0
while IFS="="  read NADAS VALORNUMERICOCFG
do

if test $FLAG -eq 0
then
NUMCOLORES=$VALORNUMERICOCFG
elif test $FLAG -eq 1
then
TIEMPO=$VALORNUMERICOCFG
elif test $FLAG -eq 2
then
RUTA=$VALORNUMERICOCFG
else
NADAS=0
fi
FLAG=$(($FLAG+1))
done < confi.cfg



echo
echo "           CONFIGURACION"
echo " **********************************"
echo Estamos jugando con $NUMCOLORES colores
echo El tiempo de espera es de $TIEMPO segundos
echo La ruta del fichero log es $RUTA
