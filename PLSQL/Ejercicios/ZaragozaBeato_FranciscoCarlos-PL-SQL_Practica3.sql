#Crear los siguientes procedimientos y funciones sobre la BBDD FERRETERIA:
deterministic
#1.	Crear un procedimiento llamado “HOLA” que visualice por pantalla el siguiente mensaje cuando se le invoque(llame o ejecute):
#HOLA, ESTE ES MI PRIMER PROCEDIMIENTO EN MYSQL
	
    drop procedure if exists HOLA
        DELIMITER $$
			create procedure HOLA()
				begin 
					declare mensaje varchar(50);
                    set mensaje ="ESTE ES MI PRIMER PROCEDIMIENTO EN MYSQL";
					select mensaje;
                end
        
        $$
        

		call HOLA();

/*2.	Crear  una función llamada “HOLA2” que realice lo mismo que antes, es decir que visualice por pantalla el siguiente mensaje cuando se le invoque(llame o ejecute):
HOLA, ESTA ES MI PRIMERA FUNCION EN MYSQL*/

	drop function if exists HOLA2 
    delimiter $$
		create function HOLA2()returns varchar(50)
        deterministic
				begin 
					
                    declare mensaje varchar(50);
                    set mensaje = "HOLA, ESTA ES MI PRIMERA FUNCION EN MYSQL";
                    
                    return mensaje;
                    
				end
		$$
        
        select HOLA2() as "hola2";
    

#3.	Crear una función llamada  “HOLA3” que visualice por pantalla el mensaje con que se le invoque(llame o ejecute)
	
    drop function if exists HOLA3 
		delimiter $$
			create function HOLA3(mensaje varChar(50))returns varchar(50)
            deterministic
            begin 
				return mensaje;
            end
        $$
        
        select HOLA3("hola 3") as "Hola3";

/*4.	Crear un procedimiento llamado “impar” que se encargue de determinar(visualizar) si el número con que se le invoca es impar o no de tal forma que nos visualice lo siguiente:
Si el número es impar: El número es impar
En caso contrario: el número no es impar
NOTA: utilizad la función MOD (ver manual SUPERCOMPLETO de MYSQL: 12.4)*/


	drop procedure if exists impar
		delimiter $$
			create procedure impar(numero integer)
				begin 
					declare mensaje varchar(30);
                    
					if numero %2 !=0 then set  mensaje="El número es impar";
                    else set mensaje =" el número no es impar";
                    end if;
                    select mensaje;
                end
            
        $$
        
        call impar(4);

/*5.	Crear una funcion llamada “par_impar” que se encargue de determinar(visualizar) si el número con que se le invoca es impar o no de tal forma que nos visualice lo siguiente:
Si el número es par: El número es par
En caso contrario: el número es impar
MEJORA: INTENTAD que a la hora de visualizar el mensaje nos salga(ver función CONCAT):
El número x(por ejemplo 35) es impar*/
	
    drop function if exists par_impar 
		delimiter $$
			create function par_impar(numero integer)returns varchar(50)
            deterministic
				begin 
					declare mensaje varchar(30);
                    
					if numero %2 like 0 then set  mensaje=concat(" El número ", numero ," es impar");
                    else set mensaje = concat(" El número ", numero ," no es impar");
                    end if;
                    return mensaje;
         
                end
        $$

select par_impar(22);

/*6.	Crear un procedimiento llamado  “cuentaletras” para que visualice por pantalla el número de letras que contiene el mensaje con que se le invoque(llame o ejecute)
NOTA: ver apartado 12.3 del manual SUPERCOMPLETO de MYSQL.*/

	drop procedure if exists cuentaletras 
		delimiter $$
			create procedure cuentaletras(cadena varchar(50))
				begin 
					select length(cadena) as "Cuenta Letras";
                end
			
        $$
        
        call cuentaletras("letras");

#7.	Crear una función llamada  “cuentadigitos” para que visualice por pantalla el número de dígitos(números) que contiene la función cuando se le invoque(llame o ejecute)
drop procedure if exists cuentadigitos 
		delimiter $$
			create procedure cuentadigitos(digitos integer)
				begin 
					select length(digitos) as "Cuenta dígitos";
                end
			
        $$
        
   call cuentadigitos(1000000);
   
   
   
#1. Crear una funcion llamada “ESIMPAR” que se encargue de determinar si el número con que se le invoca es impar o no(TRUE(1) o FALSE(0)):
	
    drop function if exists esimpar 
		delimiter $$
			create function esimpar(valor integer)returns boolean
            deterministic 
				begin 	
						declare condicion boolean;
                        
						if valor%2 like 0 then set condicion =true;
                        else set condicion = false;
                        end if;
                        return condicion;
				end
        $$
        
        select esimpar(4);
    
#2. Crear un procedimiento llamado  “VERIMPAR”  de tal forma que invoque a la función ESIMPAR y visualice por pantalla:
#Si el número es impar: El número X es impar
#En caso contrario: El número X es par

	drop procedure if exists verimpar;
		delimiter $$
			create procedure verimpar(funcion integer)
				begin 
					select funcion;
                end
        $$

	call verimpar(esimpar(6));
    
#3. Crear una función(CODIGOPEDIDO) que nos devuelva  el último número de pedido más uno

	drop function if exists codigopedido;
	delimiter $$
		create function codigopedido(valor integer)returns integer
			deterministic
            begin
				set valor = valor+1;
                return valor;
            end 
	$$
    
    select(codigopedido(pedidos.CodigoPedido))
		from pedidos;
        
#4. Crear una función llamada “EXISTCLI” de tal forma que nos 
#indique si ese cliente con el que se le invoca existe o no(TRUE(1) o FALSE(0))
	
    drop function if exists existCli;
    delimiter $$
		create function existCli(nombre varchar(200))returns varchar(200)
			deterministic 
				begin 
                
                declare condicion boolean;
                
                
                if nombre  like (select clientes.NombreCliente from clientes where clientes.NombreCliente=nombre limit 1) 
							then set condicion = true;
					else set nombre = "no";
                end if;
                
                return nombre;
                end
            
    $$
    
    select existCli("DGPRODUCTIONS GARDEN");
    
#5. Crear ahora un procedimiento llamado  “VERIFCLI”  
#de tal forma que invoque a la función EXISTCLI y nos visualice por pantalla en caso de que no exista que: 
#El cliente número X NO EXISTE en la base de datos
		
	drop procedure if exists VERIFCLI;
		delimiter $$
			create procedure VERIFCLI(nombre varchar(200))
				begin 
					if nombre like (select  clientes.NombreCliente from clientes where clientes.NombreCliente=nombre limit 1) 
						then set nombre = concat("El nombre del cliente es ",nombre);
                    else set nombre = "El cliente que ha introducido no existe.";
                    end if;
                    
                    select nombre;
                    
						
                end
        $$
    
call VERIFCLI(existCli("DGPRODUCTIONS GARDEN"));
 
#6. Crear una función llamada CALIFICACION1 de tal forma que nos 
#indique si estás suspenso o aprobado en función de la nota con que se le invoque, visualizando lo siguiente:
#LO SIENTO, ESTÁS SUSPENSO 	o
#ENHORABUENA, ESTÁS APROBADO

	drop function if exists CALIFICACION1;
		delimiter $$
			create function CALIFICACION1(nota integer)returns varchar(200)
            deterministic
				begin 
						
                        declare mensaje varchar(200);
                        
                        
                        if nota>=5 then set mensaje = concat("Usted esta aprobado con un ",nota);
                        else set mensaje= concat("Usted ha suspendido con un ", nota );
                        end if; 
                        
                        return mensaje;
                    
				end 
		
        $$

	select CALIFICACION1(10);

#7. Crear ahora un procedimiento con el IF llamado CALIFIF y otro con el CASE:
#CALIFCASE de tal forma que califique la nota con que se le invoque, las posibilidades son:
#INSUFICIENTE: (0,5(
#SUFICIENTE: (5,6(
#BIEN: (6,7(
#NOTABLE: (7,9(
#SOBRE: (9,10(
#MATRICULA DE HONOR: 10
#CALIFICACION ERRONEA: en cualquier otro caso.

drop procedure if exists CALIFIFswitch()
	delimiter $$
		create procedure CALIFIFswitch(nota integer)
			begin 
				declare mensaje varchar(200);
                
                CASE
					WHEN nota>0 and nota<5 THEN set mensaje ="suspenso";
					WHEN nota like 5 then set  mensaje= "Suficiente";
					WHEN  nota like 6 then set mensaje ="Bien";
                    WHEN  nota like 7 or nota like 8 then set mensaje ="Notable";
                    WHEN nota like 9 or nota like 10 then set mensaje ="Sobresaliente";
					ELSE SET  mensaje ="Introduzca una nota valida";
				END CASE;
				
                select mensaje;
        
			end
    $$

	call CALIFIFswitch(1); 

	drop procedure if exists CALIFIF;
		delimiter $$
			create procedure CALIFIF(nota integer)
					begin 
						  declare mensaje varchar(200);
                        
								if nota>0 && nota<5 then set mensaje="Suspenso";
									elseif nota like 5 then set  mensaje= "Suficiente";
									elseif nota like 6 then set mensaje ="Bien";
									elseif nota like 7 or nota like 8 then set mensaje ="Notable";
									elseif nota like 9 or nota like 10 then set mensaje ="Sobresaliente";
								else set mensaje ="Introduzca una nota valida";
								end if;
                                
                                select mensaje;
                    end 

					$$

	call CALIFIF(5);
    
    

	
#8. Crea una función llamada SUMA100 con la sentencia LOOP de forma que nos visualice
# la suma de los 100 primeros números(nos debe dar: 5050)

	drop function if exists SUMA100;
		delimiter $$
			create function SUMA100()returns  integer
				deterministic	
					begin 
						declare numero,contador integer;
                 
						set numero=1,contador=0;
         
                 contador : LOOP
                    leave contador;
                    
						if contador like 100 then iterate contador;end if;
							set numero= numero+numero;
							set numero= numero+1; 
							set contador = contador+1;
						
					end loop contador; 

					return numero;
					
                    end
        $$

	select SUMA100();

#9. Crea un procedimiento llamado SUMAX con la sentencia WHILE 
#de forma que nos calcule la suma de los primeros  X números con que se le invoque

	drop procedure if exists sumax;
		delimiter $$
			create procedure sumax(numeros integer, numeroDenumeros integer) 
				begin 
					declare condicion,suma integer;
						set condicion =0;
                        set suma=0;
                        
						WHILE condicion<numeroDenumeros DO
							set suma = suma+numeros;
                            set condicion = condicion+1;
                            set numeros =numeros+1;
						END WHILE;
                        
                        select suma;
                    
                end
        $$
	call sumax(5,2);

#10. Crea un procedimiento llamado FACTORIAL  con la sentencia  REPEAT de forma que nos calcule 
#el factorial del número con que se le invoca

drop procedure if exists FACTORIAL;
	delimiter $$
		create procedure FACTORIAL(numero integer)
			begin 
			declare factorial integer;
            set factorial =numero;
				REPEAT
                	set numero = numero-1;
					set factorial=factorial*numero ;
				
					UNTIL numero like 1
				END REPEAT;
                
                select factorial;
            end
    $$
call FACTORIAL(4);
	
#11. Crea un procedimiento llamado QUINIELA de forma que nos haga una quiniela de futbol 
#con 14 resultados, según el siguiente formato:
#RESULTADO :  1	  X  2  1  X  2  1  1  X  2  1  X  X  1

	drop procedure if exists QUINIELA;
		delimiter $$
			create procedure QUINIELA()
				begin 
                
                    declare contador integer default 0;
                   declare  numero varchar(40);
                    declare quinielaTexto varchar(200) default "";
				
            
             
             while contador < 13 do
                 set numero = truncate(rand()*3,0);
				if (numero like 0) then set numero = "X";
                end if;
                
                set quinielaTexto = concat(quinielaTexto," ",numero); 
                set contador = contador +1;
             end while;   
			select quinielaTexto;
           end
        $$
        call QUINIELA();


#12. Crea ahora una función llamado QUINIELAF  de forma que nos haga lo 
#mismo que el procedimiento anterior, es decir, generar una quiniela de futbol con 14 resultados:
#RESULTADO :  1  1  2  X  1  X  X  2  1  2  1  X  1  2

	drop function if exists QUINIELAF;
		delimiter $$
			create function QUINIELAF()returns varchar(300) 
            deterministic
					begin 
                    
                    declare contador integer default 0;
					declare  numero varchar(40);
                    declare quinielaTexto varchar(200) default "";
        
					
                    while contador<13 do
						set numero = truncate(rand()*3,0);
						if(numero like 0) then set numero ="X";
                        end if;
                        set quinielaTexto =concat(quinielaTexto," ",numero);
                        set contador = contador+1;
                        
                    end while;
	
					return quinielaTexto;
                    end 
        $$


	            select QUINIELAF() as QUINIELAF;



/*13. Crea ahora un procedimiento  llamado QUINIELAMULTIPLE  
teniendo en cuenta que se deberá llamar al procedimiento con el número de columnas
 a rellenar(ejemplo para 3 columnas):
COLUMNA   1: 	X  1  2  1  1  X  X  2  2  2  1  1  X  2 
COLUMNA   2: 	1  1  2  X  1  X  X  2  1  2  1  X  1  2 
COLUMNA   3: 	2  2  2  1  1  1  X  1  2  X  X  1  1  2 
…..*/


	drop procedure if exists QUINIELAMULTIPLE;
		delimiter $$
			create procedure QUINIELAMULTIPLE(valor integer)
				 begin
                 
                 declare contador, numero1, numero2,contadorPrincipal integer default 0;
                 declare quinielaTexto varchar(300) default ""; 
                 declare quinielaTotal varchar(600) default "";
               
				while contador <valor do 
					
                    set quinielaTexto = concat("Columna: ",contador+1, QUINIELAF(),"\n");
                    set quinielaTotal = concat(quinielaTexto,quinielaTotal);
                    
                    set contador = Contador+1;
                end while;
                
								
                 select quinielaTotal;
                 
                 end
        $$

call QUINIELAMULTIPLE(3);



/*14. Crea ahora un procedimiento  llamado MULTIQUINIELA de forma que llame(invoque)  
a la función creada en el ejercicio12(QUINIELAF)  y teniendo en cuenta que se deberá llamar 
al procedimiento con el número de columnas a rellenar(ejemplo para 3 columnas).
NOTA: es parecido al ejercicio anterior pero invocando(llamando)  a una función. Vereis que es más simple entonces que el anterior.
COLUMNA   1: 	X  1  2  1  1  X  X  2  2  2  1  1  X  2 
COLUMNA   2: 	1  1  2  X  1  X  X  2  1  2  1  X  1  2 
COLUMNA   3: 	2  2  2  1  1  1  X  1  2  X  X  1  1  2 
…..*/

	drop procedure if exists MULTIQUINIELA;
		delimiter $$
			create procedure MULTIQUINIELA(valor integer)
				begin 
					declare contador integer;
                    declare quinielaTexto varchar(300);
                    declare quiniela varchar(7000);
                    set contador =1;
                    set quiniela ="";
                
					while contador<=valor do	
		
                        
						set quinielaTexto = concat("Columna: ",contador," ",QUINIELAF(),"\n" );
                        set quiniela = concat(quiniela,quinielaTexto);
                        
                         set contador = contador+1;
                    end while;
                    
                    select quiniela;
			
                end
        $$
        
        call MULTIQUINIELA(6);


/*15. Crea un procedimiento llamado PRIMITIVA de forma que nos haga una primitiva con 6 resultados 
(del   1 al 49), según el siguiente formato:
RESULTADO:  23  5  37  6  12  44*/

drop procedure if exists PRIMITIVA;
delimiter $$
	create procedure PRIMITIVA()
		begin 
			declare numero,contador integer default 0;
            declare primitiva varchar(600) default "";
	
	
		while contador < 6 do
			    	 set numero = truncate(rand()*49,0);
                    if(locate(numero, primitiva)>0) then set contador = contador-1;
					
                    else set primitiva = concat(numero," ",primitiva);
                        
                    end if;
			set contador = contador+1;
        end while;
        
			
                
            select primitiva;
        end
$$

call PRIMITIVA();


#Apartado de MEJORA: NO se debe permitir que se puedan repetir  números. Para ello os puedo recomendar que utilicéis la función (Manual supercompleto de MySQL: apartado 12.3 pagina 468), aunque no es la única opción o posibilidad.

/*16. Crea ahora una función llamada PRIMITIVAF de forma que nos haga lo mismo que antes, es decir generar una primitiva:
RESULTADO:  13  4  25  48  17  9*/

	drop function if exists PRIMITIVAF;
		delimiter $$ 
			create function PRIMITIVAF() returns varchar(200)
            deterministic
				begin 
					declare contador, numero integer default 0;
                    declare primitiva varchar(200) default "";
                    
                    while contador < 6 do 
							set numero = truncate(rand()*49,0);
                            if(locate(numero,primitiva)>0) then set contador = contador-1;
								else set primitiva = concat(numero," ",primitiva) ;
                            end if;
                           set contador = contador+1; 
					end while;
                    
                    return primitiva;
                end  
        $$
		
        select PRIMITIVAF();


#17. Crea ahora un procedimiento  llamado MULTIPRIMITIVA de forma que llame(invoque) 
# a la función creada anteriormente(PRIMITIVAF)  y 
# teniendo en cuenta que se deberá llamar al procedimiento con el número de 
# columnas a rellenar(ejemplo para 3 columnas).
#COLUMNA   1: 	9  35  12  4  38  44 
#COLUMNA   2: 	6  47  14  2  8   29 
#COLUMNA   3: 	46  32  5  19  28  13


drop procedure if exists MULTIPRIMITIVA;
	delimiter $$
			create procedure MULTIPRIMITIVA(valor integer)
				begin
					declare contador integer default 0;
                    declare primitiva, primitivaTotal varchar(400) default "";
						while contador < valor do
								set primitiva = concat("COLUMNA ", contador+1, ": ",PRIMITIVAF(), "\n");
				
								set primitivaTotal = concat(primitivaTotal,primitiva); 
                                    
								set contador = contador+1;
						end while;
					select primitivaTotal;
                end
    $$
call MULTIPRIMITIVA(3);