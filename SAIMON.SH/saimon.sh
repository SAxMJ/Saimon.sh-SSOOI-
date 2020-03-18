#Cabecera de autores
if test "$1" = '-g'
then
   echo Andrés Sánchez, Elena
   echo García García, Álvaro
exit
fi

#COMPROBAMOS QUE confi.cfg EXISTE
if test -f confi.cfg #comprobar que el archivo confi.cfg existe
then

#LEEMOS EL FICHERO confi.cfg PARA TOMAR LOS ULTIMOS VALORES DE COLORES Y TIEMPO
FLAG=0

cat confi.cfg | NUMCOLORES=0 TIEMPO=0 NOMBREFICHERORUTA=0
while IFS="=" read NADAS VALORNUMERICOCFG
do

if test $FLAG -eq 0
then
NUMCOLORES=$VALORNUMERICOCFG
elif test $FLAG -eq 1
then
TIEMPO=$VALORNUMERICOCFG
elif test $FLAG -eq 2
then
NOMBREFICHERORUTA=$VALORNUMERICOCFG
else
NADAS=0
fi
FLAG=$(($FLAG+1))
done < confi.cfg

#SI NO EXISTE confi.cfg INFORMAMOS DE ELLO Y SALIMOS DEL PROGRAMA
else
echo "No se encontro el archivo de configuracion (confi.cfg)"
echo "El archivo confi.cfg debe encontrarse en el mismo directorio que saimon.sh"
exit 
fi

#DECLARAMOS LOS 4 COLORES CON LOS QUE SE PODRA JUGAR
COLORC=(A V R Z)
J=0

#EL NUMERO DE COLORES Y EL TIEMPO DE MUESTRA DE CADA COLOR POR DEFECTO SERÁ 4 COLORES Y 1 SEGUNDO

function MENU
{

	INCORRECTO=1
	while test $INCORRECTO -eq 1
	do
	echo " "
	echo "       BIENVENIDOS A SIMON"
	echo " "
	echo "J)JUGAR"
	echo "C)CONFIGURAR"
	echo "E)ESTADÍSTICAS"
	echo "S)SALIR"
	echo ""
	echo "Saimon: Introduce una opcion"
	read OPCION
	case $OPCION in
	#Realizamos un case para elegir una de las opciones

	J|j )
	JUGAR
	;;
	C|c )
	CONFIGURACION
	;;   

	E|e )
	ESTADISTICAS
	;;
	S|s )
	SALIR
	;;
	* )
	echo La opcion introducida no es valida
	;;

	esac
	done  

}




#EN LA FUNCION JUGAR SE PRODUCIRÁ AQUELLO QUE VEMOS MIENTRAS JUGAMOS

function JUGAR
{
echo $NUMCOLORES colores
I=$(($RANDOM%$NUMCOLORES))
SERIE[$J]=${COLORC[$I]}
CONT=0

clear
echo
echo "EL FUNCIONAMIENTO ES EL SIGUIENTE:"
echo
echo "Introduce color a color (EN MAYUSCULAS), es decir, introduce uno," 
echo "pulsa intro e introduce el siguiente"
echo
echo "A=Amarillo"
echo "R=Verde"
echo "V=Verde"
echo "Z=Azul"
echo
echo "Pulsa INTRO para continuar..."
echo
read

#INICIALIZAMOS EL CONTADOR DE SEGUNDOS
TIEMPOIN=$SECONDS 

clear
echo  EMPIEZA LA SECUENCIA...
echo NºCOLORES[$(($CONT+1))]
sleep 2
clear
sleep 1
echo "${COLORC[$I]}"
sleep $TIEMPO
clear
sleep 1
echo
echo Saimon, es tu turno, introduce la secuencia
echo Introduce color
#Comprobacion


for K  in ${!SERIE[*]};
        do
                read PRUEBA
                if test "$PRUEBA" = "${SERIE[$K]}"
                then
                        echo Correcto!
						CONT=$(($CONT+1))
						sleep 2
                else
                        echo Incorrecto, vuelve a empezar

						#variables que toman el valor de la fecha y la hora
						DIA=`date +%d/%m/%Y`
						HORA=`date +%H:%M`
						#igualamos el tiempo final a seconds de nuevo, restamos el valor final menos el inicial y obtebemos el tiempo en segundos
						TIEMPOFIN=$SECONDS
						TIEMPOTOTAL=$(($TIEMPOFIN-$TIEMPOIN))
						#CON $$ OBTENEMOS EL VALOR DEL PID
						PARTIDA=$$
						#GUARDAMOS LOS DATOS DE LA PARTIDA EN EL FICHERO DE LAS ESTADISTICAS Y SALIMOS DEL PROGRAMA
						echo "$PARTIDA|$DIA|$HORA|$NUMCOLORES|$TIEMPOTOTAL|$CONT|${SERIE[*]}|" >> $NOMBREFICHERORUTA
                        exit 0
                fi
        done

while  [ $CONT -lt 20 ]

        do
                #inicializamos siempre J a 0 para que muestre el vector
                #desde el principio
                J=0
                #Bucle para mostrar la secuencia anterior
				clear
				echo "SERIE CON NUEVO COLOR"
				echo NºCOLORES[$(($CONT+1))]
				sleep 2
                while [ $J -lt $CONT ]
                        do
								clear
                                echo ${SERIE[$J]}
                                sleep $TIEMPO
                                clear
                                sleep 1
                                J=$(($J+1))
                        done

                #Ya hemos sacado los COLORES ANTERIORES
                #Sacamos el NUEVO COLOR
				CONT=$(($CONT+1))
                I=$(($RANDOM%$NUMCOLORES))
                #ANHADIMOS NUEVO COLOR"
				echo "${COLORC[$I]}"
                sleep $TIEMPO
                clear
                sleep 1
                #GUARDAMOS el NUEVO COLOR en el vector
                SERIE[$J]=${COLORC[$I]}

echo
echo Saimon, es tu turno, introduce la secuencia
echo Introduce color
for K  in ${!SERIE[*]};   
do
                read PRUEBA
if test "$PRUEBA" = "${SERIE[$K]}"   
                then
                        echo Correcto!
						sleep 2
                else
                        echo Incorrecto, vuelve a empezar

						#variables que toman el valor de la fecha y la hora
						DIA=`date +%d/%m/%Y`
						HORA=`date +%H:%M`
						#Hallamos el tiempo jugado en segundos, restamos tiempo final menos el inicial para obtener los segundos
						TIEMPOFIN=$SECONDS
						TIEMPOTOTAL=$(($TIEMPOFIN-$TIEMPOIN))
						#$$ para obtener el PID
						PARTIDA=$$
						#GUARDAMOS LOS DATOS DE LA PARTIDA EN EL FICHERO DE ESTADISTICAS Y SALIMOS DEL PROGRAMA
						echo "$PARTIDA|$DIA|$HORA|$NUMCOLORES|$TIEMPOTOTAL|$CONT|${SERIE[*]}|" >> $NOMBREFICHERORUTA
                        exit 0
                fi
        done

done
#GUARDAMOS EN EL FICHERO DE LAS ESTADISTICAS CUANDO HEMOS ACERTADO TODA LA SECUENCIA
#variables que toman el valor de la fecha y la hora
DIA=`date +%d/%m/%Y`
HORA=`date +%H:%M`
#igualamos el tiempo final a seconds de nuevo, restamos el valor final menos el inicial y obtebemos el tiempo en segundos
TIEMPOFIN=$SECONDS
TIEMPOTOTAL=$(($TIEMPOFIN-$TIEMPOIN))
#CON $$ OBTENEMOS EL VALOR DEL PID
PARTIDA=$$
#GUARDAMOS TODOS LOS DATOS DE LA PARTIDA EN EL FICHERO DE ESTADISTICAS Y VOLVEMOS AL MENU
echo "$PARTIDA|$DIA|$HORA|$NUMCOLORES|$TIEMPOTOTAL|$CONT|${SERIE[*]}|" >> $NOMBREFICHERORUTA

echo "     ¡¡¡ENHORABUENA, HAS COMPLETADO LA SECUENCIA ENTERA!!!"
sleep 2
echo Volviendo al menu...
sleep 2
MENU
}


#EN LA FUNCION ESTADISTICAS MOSTRAREMOS LAS ESTADISTICAS DE TODAS LAS PARTIDAS JUGADAS 
function ESTADISTICAS
{
echo
echo "                ESTADISTICAS"
echo 

#Definicion de las variables
ACUMULADORTIEMPO=0
LONGITUDMEDIA=0
LONGITUDTOTAL=0
PORA=0
PORR=0
PORV=0
PORZ=0
CONTA=0
CONTR=0
CONTV=0
CONTZ=0
JLARGA=0
JCORTA=20
LONGL=0
LONGC=20


#				CUENTAS PARA SACAR LOS DATOS
#            *****************************************************************
# 				 CUENTAS para las GENERALES

#Calculo del TIEMPO TOTAL  jugado
#            ************
cat $NOMBREFICHERORUTA | ACUMULADORTIEMPO=0 
while IFS="|" read NPARTIDAESTAD FECHAESTAD HORAESTAD NUMEROCOLORESESTAD TIEMPOESTAD LONGITUDSECESTAD SECUENCIAESTAD
do
ACUMULADORTIEMPO=$(($TIEMPOESTAD + $ACUMULADORTIEMPO))
done < $NOMBREFICHERORUTA

#Calculo del TOTAL de PARTIDAS jugadas
#            *****************
#Contamos las lineas del fichero y le restamos 1 que es la linea inicial que no cuenta como partida 
NPARTIDAS=$(cat $NOMBREFICHERORUTA | wc -l)
NPARTIDAS=$(($NPARTIDAS-1))

#Calculo MEDIA DE TIEMPO jugado
#        ***************
TIEMPOMEDIO=$ACUMULADORTIEMPO/$NPARTIDAS

#Calculo de la MEDIA de las SECUENCIAS
#              ***********************
cat $NOMBREFICHERORUTA | LONGITUDMEDIA=0 LONGITUDTOTAL=0
while IFS="|" read NPARTIDAESTAD FECHAESTAD HORAESTAD NUMEROCOLORESESTAD TIEMPOESTAD LONGITUDSECESTAD SECUENCIAESTAD
do
LONGITUDTOTAL=$(($LONGITUDSECESTAD+$LONGITUDTOTAL))
#echo $LONGITUDTOTAL
LONGITUDMEDIA=$(($LONGITUDTOTAL/$NPARTIDAS))
done < $NOMBREFICHERORUTA 
#********************************************************************************************************************

# 				 CUENTAS para las ESPECIALES

#Calculo dela JUGADA MAS CORTA 
#             ****************
cat $NOMBREFICHERORUTA | JCORTA=$TIEMPOESTAD  CNPARTIDAESTAD=0 CFECHAESTAD=0 CHORAESTAD=0 CNUMEROCOLORESESTAD=0 CTIEMPOESTAD=0 CLONGITUDSECESTAD=0 CSECUENCIAESTAD=0
while IFS="|" read NPARTIDAESTAD FECHAESTAD HORAESTAD NUMEROCOLORESESTAD TIEMPOESTAD LONGITUDSECESTAD SECUENCIAESTAD
do
	if test "$TIEMPOESTAD" -lt "$JCORTA"   
                then
			JCORTA=$TIEMPOESTAD
			CNPARTIDAESTAD=$NPARTIDAESTAD 
			CFECHAESTAD=$FECHAESTAD 
			CHORAESTAD=$HORAESTAD 
			CNUMEROCOLORESESTAD=$NUMEROCOLORESESTAD 
			CTIEMPOESTAD=$TIEMPOESTAD 
			CLONGITUDSECESTAD=$LONGITUDSECESTAD 
			CSECUENCIAESTAD=$SECUENCIAESTAD
	fi
done < $NOMBREFICHERORUTA

#Calculo dela JUGADA MAS LARGA
#             ****************
cat $NOMBREFICHERORUTA | JLARGA=$TIEMPOESTAD  LNPARTIDAESTAD=0 LFECHAESTAD=0 LHORAESTAD=0 LNUMEROCOLORESESTAD=0 LTIEMPOESTAD=0 LLONGITUDSECESTAD=0 LSECUENCIAESTAD=0
while IFS="|" read NPARTIDAESTAD FECHAESTAD HORAESTAD NUMEROCOLORESESTAD TIEMPOESTAD LONGITUDSECESTAD SECUENCIAESTAD 
do
	if test "$TIEMPOESTAD" -gt "$JLARGA"   
                then
			JLARGA=$TIEMPOESTAD
			LNPARTIDAESTAD=$NPARTIDAESTAD 
			LFECHAESTAD=$FECHAESTAD 
			LHORAESTAD=$HORAESTAD 
			LNUMEROCOLORESESTAD=$NUMEROCOLORESESTAD 
			LTIEMPOESTAD=$TIEMPOESTAD 
			LLONGITUDSECESTAD=$LONGITUDSECESTAD 
			LSECUENCIAESTAD=$SECUENCIAESTAD
	fi
done < $NOMBREFICHERORUTA

#Calculo dela JUGADA CON LA LONGITUD MAS CORTA
#             *********************************
cat $NOMBREFICHERORUTA | LONGC=$LONGITUDSECESTAD NNPARTIDAESTAD=0 NFECHAESTAD=0 NHORAESTAD=0 NNUMEROCOLORESESTAD=0 NTIEMPOESTAD=0 NLONGITUDSECESTAD=0 MSECUENCIAESTAD=0
while IFS="|" read NPARTIDAESTAD FECHAESTAD HORAESTAD NUMEROCOLORESESTAD TIEMPOESTAD LONGITUDSECESTAD SECUENCIAESTAD 
do
	if test "$LONGITUDSECESTAD" -lt "$LONGC"   
                then
			LONGC=$LONGITUDSECESTAD
			NNPARTIDAESTAD=$NPARTIDAESTAD 
			NFECHAESTAD=$FECHAESTAD 
			NHORAESTAD=$HORAESTAD 
			NNUMEROCOLORESESTAD=$NUMEROCOLORESESTAD 
			NTIEMPOESTAD=$TIEMPOESTAD 
			NSECUENCIAESTAD=$SECUENCIAESTAD
	fi
done < $NOMBREFICHERORUTA

#Calculo dela JUGADA CON LA LONGITUD MAS LARGA
#             *********************************
cat $NOMBREFICHERORUTA | LONGL=$LONGITUDSECESTAD MNPARTIDAESTAD=0 MFECHAESTAD=0 MHORAESTAD=0 MNUMEROCOLORESESTAD=0 MTIEMPOESTAD=0 MLONGITUDSECESTAD=0 MSECUENCIAESTAD=0
while IFS="|" read NPARTIDAESTAD FECHAESTAD HORAESTAD NUMEROCOLORESESTAD TIEMPOESTAD LONGITUDSECESTAD SECUENCIAESTAD 
do
	if test "$LONGITUDSECESTAD" -gt "$LONGL"   
                then
			LONGL=$LONGITUDSECESTAD
			MNPARTIDAESTAD=$NPARTIDAESTAD 
			MFECHAESTAD=$FECHAESTAD 
			MHORAESTAD=$HORAESTAD 
			MNUMEROCOLORESESTAD=$NUMEROCOLORESESTAD 
			MTIEMPOESTAD=$TIEMPOESTAD 
			MSECUENCIAESTAD=$SECUENCIAESTAD
	fi

done < $NOMBREFICHERORUTA
K=1
echo K=$K
#Para no contar los espacios, cada letra son dos posiciones, y restamos uno por el ultimo espacio
#Incrementamos K 2 unidades para la letra y el espacio
LONGLL=$(($LONGL*2-1))
#Calculo de los PORCENTAJES de la longitud mas larga
while test "$K" -le "$LONGLL"
	do
	LETRA=$(echo $MSECUENCIAESTAD | cut -c $K)
	case $LETRA in 
						A )
					           CONTA=$(($CONTA + 1)) 
					
						;;
						R )
				            	   CONTR=$(($CONTR + 1)) 
								
						;;

						V )
				             	  CONTV=$(($CONTV + 1))
					
						;;

						Z )
				             	  CONTZ=$(($CONTZ + 1))
						;;
				    	  esac	
					  K=$(($K + 2))
				done
				CA=0
				CA=$(($CONTA*100))
			
				CR=0
				CR=$(($CONTR*100))
	
				CV=0
				echo $CV ver
				CV=$(($CONTV*100))
				
				CZ=0
				CZ=$(($CONTZ*100))
			
				PORA=$(($CA/$LONGL))
				PORR=$(($CR/$LONGL))
				PORV=$(($CV/$LONGL))
				PORZ=$(($CZ/$LONGL))
				

#Muestra de las estadisticas
echo " Generales"
echo " **********"
echo " Numero total de partidas jugadas: $NPARTIDAS"
echo " Media de las longitudes de las secuencias de todas las partidas jugadas: $LONGITUDMEDIA" 
echo " Media de los tiempos jugados: $TIEMPOMEDIO"
echo " Tiempo total jugado: $ACUMULADORTIEMPO segundos"
echo
echo
echo " Jugadas especiales"
echo " *******************"
echo " Datos jugada mas corta:"
	echo "   PID: $CNPARTIDAESTAD" 
	echo "   Fecha: $CFECHAESTAD"
	echo "   Hora: $CHORAESTAD" 
	echo "   Numero de colores: $CNUMEROCOLORESESTA"
	echo "   Duracion: $CTIEMPOESTAD" 
	echo "   Longitud de la secuencia: $CLONGITUDSECESTAD" 
	echo "   Secuencia: $CSECUENCIAESTAD"
echo
echo " Datos jugada mas larga $JLARGA segundos"
	echo "   PID: $LNPARTIDAESTAD" 
	echo "   Fecha: $LFECHAESTAD" 
	echo "   Hora: $LHORAESTAD" 
	echo "   Numero de colores: $LNUMEROCOLORESESTAD" 
	echo "   Duracion: $LTIEMPOESTAD"
	echo "   Longitud de la secuencia: $LLONGITUDSECESTAD" 
	echo "   Secuencia: $LSECUENCIAESTAD"
echo
echo " Datos de la jugada con menor longitud de colores $LONGC"
	echo "   PID: $NNPARTIDAESTAD"
	echo "   Fecha: $NFECHAESTAD" 
	echo "   Hora: $NHORAESTAD" 
	echo "   Numero de colores: $NUMEROCOLORESESTAD" 
	echo "   Duracion: $NTIEMPOESTAD" 
	echo "   Longitud de la secuencia: $LONGC" 
	echo "   Secuencia: $NSECUENCIAESTAD"
echo
echo " Datos de la jugada con mayor longitud de colores $LONGL"
	echo "   PID: $MNPARTIDAESTAD" 
	echo "   Fecha: $MFECHAESTAD" 
	echo "   Hora: $MHORAESTAD" 
	echo "   Numero de colores: $MUMEROCOLORESESTAD" 
	echo "   Duracion: $MTIEMPOESTAD"
	echo "   Longitud de la secuencia: $LONGL"
	echo "   Secuencia: $MSECUENCIAESTAD"
echo
echo " Porcentaje de los diferentes colores de la jugada con mayor longitud de colores"
	echo "   Porcentaje amarillo: $PORA %"
	echo "   Porcentaje rojo: $PORR %"
	echo "   Porcentaje verde: $PORV %"
	echo "   Porcentaje azul: $PORZ %"
echo
echo





}








function CONFIGURACION
{

#LEEMOS LOS VALORES DE confi.cfg PARA VER CUAL ES LA CONFIGURACION ACTUAL
FLAG=0

cat confi.cfg | NUMCOLORES=0 TIEMPO=0 NOMBREFICHERORUTA=0
while IFS="=" read NADAS VALORNUMERICOCFG
do

if test $FLAG -eq 0
then
NUMCOLORES=$VALORNUMERICOCFG
elif test $FLAG -eq 1
then
TIEMPO=$VALORNUMERICOCFG
elif test $FLAG -eq 2
then
NOMBREFICHERORUTA=$VALORNUMERICOCFG
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
echo Ruta y nombre del fichero de estadisticas $NOMBREFICHERORUTA
echo "Quieres cambiar la configuracion? S/N"

read OPCION
case $OPCION in
S|s)
	echo "Elige que quieres cambiar"
	echo "C Cambio de colores"
	echo "T Cambio de tiempo"
	echo "F Fichero y ruta"
	echo "N Al final no quiero cambiar nada"
	read ELECCION
	case $ELECCION in
		C|c )
			#FLAG PARA CONTROLAR SI INTRODUCIMOS VALOR INCORRECTO 
			INCORRECTO=1
			while test $INCORRECTO -eq 1
			do 
			echo "Con cuantos quieresjugar"
			echo "2"
			echo "3"
			echo "4"
			echo
			read ELECCIONCOLORES
			case $ELECCIONCOLORES in
				2 ) 
					NUMCOLORES=2
					echo "NUMCOLORES=$NUMCOLORES" > confi.cfg
					echo "ENTRETIEMPO=$TIEMPO" >> confi.cfg
					echo "ESTADISTICAS=$NOMBREFICHERORUTA" >> confi.cfg
					echo Numero de colores cambiados a 2
					echo Volviendo a Configuracion...
					sleep 2
					CONFIGURACION
					break
					;;
				3 ) 
					NUMCOLORES=3
					echo "NUMCOLORES=$NUMCOLORES" > confi.cfg
					echo "ENTRETIEMPO=$TIEMPO" >> confi.cfg
					echo "ESTADISTICAS=$NOMBREFICHERORUTA" >> confi.cfg
					echo Numero de colores cambiados a 3
					echo Volviendo a Configuracion...
					sleep 2
					CONFIGURACION
					break
					;;
				4 ) 
					NUMCOLORES=4
					echo "NUMCOLORES=$NUMCOLORES" > confi.cfg
					echo "ENTRETIEMPO=$TIEMPO" >> confi.cfg
					echo "ESTADISTICAS=$NOMBREFICHERORUTA" >> confi.cfg
					echo Numero de colores cambiados a 4
					echo Volviendo a Configuracion...
					sleep 2
					CONFIGURACION
					break
					;;
				* ) 
					echo No entiendo, introduce 2,3,4
					echo
					;;
			esac
			done 
			;;	
			#cerramos swtch case de seleccion de colores
			
		T|t )
			#FLAG PARA CONTROLAR SI INTRODUCIMOS VALOR INCORRECTO 
			INCORRECTO=1
			while test $INCORRECTO -eq 1
			do
			echo "¿Que tiempo quieres?"
			echo "1"
			echo "2"
			echo "3"
			echo "4"
			read ELECCIONTIEMPO
			case $ELECCIONTIEMPO in
				1) 
					TIEMPO=1
					echo "NUMCOLORES=$NUMCOLORES" > confi.cfg
					echo "ENTRETIEMPO=$TIEMPO" >> confi.cfg
					echo "ESTADISTICAS=$NOMBREFICHERORUTA" >> confi.cfg
					echo Tiempo cambiado a 1 segundo
					echo Volviendo a Configuracion...
					sleep 2
					CONFIGURACION
					break
					;;
				2) 
					TIEMPO=2
					echo "NUMCOLORES=$NUMCOLORES" > confi.cfg
					echo "ENTRETIEMPO=$TIEMPO" >> confi.cfg
					echo "ESTADISTICAS=$NOMBREFICHERORUTA" >> confi.cfg
					echo Tiempo cambiado a 2 segundos
					echo Volviendo a Configuracion...
					sleep 2
					CONFIGURACION
					break
					;;
				3) 
					TIEMPO=3
					echo "NUMCOLORES=$NUMCOLORES" > confi.cfg
					echo "ENTRETIEMPO=$TIEMPO" >> confi.cfg
					echo "ESTADISTICAS=$NOMBREFICHERORUTA" >> confi.cfg
					echo Tiempo cambiado a 3 segundos
					echo Volviendo a Configuracion...
					sleep 2
					CONFIGURACION
					break
					;;
				4) 
					TIEMPO=4
					echo "NUMCOLORES=$NUMCOLORES" > confi.cfg
					echo "ENTRETIEMPO=$TIEMPO" >> confi.cfg
					echo "ESTADISTICAS=$NOMBREFICHERORUTA" >> confi.cfg
					echo Tiempo cambiado a 4 segundos
					echo Volviendo a Configuracion...
					sleep 2
					CONFIGURACION
					break
					;;
				*) 
					echo No entiendo, introduce 1,2,3,4,5
					echo
					;;
			
			esac
			done
			;;
		F|f)

			echo "Inserta ruta, espacio y nombre del fichero"
			echo "/ruta/nombre_fichero.txt"
			read NOMBREFICHERORUTA
			echo "NUMCOLORES=$NUMCOLORES" > confi.cfg
			echo "ENTRETIEMPO=$TIEMPO" >> confi.cfg
			echo "ESTADISTICAS=$NOMBREFICHERORUTA" >> confi.cfg
			echo Ruta y nombre del fichero $NOMBREFICHERORUTA
			echo Volviendo a Configuracion...
			sleep 2
			CONFIGURACION
			break
			;;
			
            #cerramos switch case de seleccion de tiempo
		N|n ) 
			echo Volviendo al menu...
			sleep 2
			MENU
			;;
		* )
			echo No entiendo
			;;
	esac #Cerramos switch case de lo que queremos cambiar
	;;

N|n)
	echo Volviendo al menu...
	sleep 2
	MENU
	;;
*)
	echo "No es una opcion correcta"
	;;
esac
}






function SALIR
{
echo "¿Seguro que quieres salir? (S/N): "
read RESPUESTA
case $RESPUESTA in

s|S)
echo "¡¡HASTA PRONTO!!"
exit
;;

n|N)
echo Volviendo al menu...
sleep 2
MENU
;;

*)
SALIR
;;

esac
}

#EJECUTAMOS LA FUNCION MENU
MENU




