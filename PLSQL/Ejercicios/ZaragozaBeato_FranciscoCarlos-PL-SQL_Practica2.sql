/*1.	Crear un procedimiento llamado “HOLA” que visualice por 
pantalla el siguiente mensaje cuando se le invoque(llame o ejecute):
HOLA, ESTE ES MI PRIMER PROCEDIMIENTO EN MYSQL*/

drop procedure if exists HOLA;
delimiter $$
	create procedure HOLA()
		begin 
			
            select("Hola");
            
		end
$$

call HOLA

/*2.Crear  una función llamada “HOLA2” que realice lo mismo que 
antes, es decir que visualice por pantalla el siguiente mensaje cuando se le invoque(llame o ejecute):
HOLA, ESTA ES MI PRIMERA FUNCION EN MYSQL*/

drop function if exists HOLA2;
	delimiter $$
	 create function HOLA2()returns varchar(200)	
     deterministic
        begin 
			return "HOLA, ESTA ES MI PRIMERA FUNCION EN MYSQL";
        end 
    $$

select HOLA2() as funcionHola2;


/*3.	Crear una función llamada  “HOLA3” que visualice por 
pantalla el mensaje con que se le invoque(llame o ejecute)*/

drop function if exists HOLA3;
	delimiter $$
		create function HOLA3(mensaje varchar(200)) returns varchar(200)
			deterministic 
				begin 
					return mensaje;
                end 
    $$

select HOLA3("HOLA, ESTA ES MI PRIMERA FUNCION EN MYSQL") as mensaje;

/*4.	Crear un procedimiento llamado “impar” que se encargue de
 determinar(visualizar) si el número con que se le invoca es impar o no de tal forma que nos visualice lo siguiente:
Si el número es impar: El número es impar
En caso contrario: el número no es impar
NOTA: utilizad la función MOD (ver manual SUPERCOMPLETO de MYSQL: 12.4)*/

drop procedure if exists impar;
	delimiter $$
		create procedure impar(valor integer)
			begin
				declare mensaje varchar(200) default "";
            
					if(valor%2 != 0) then set mensaje ="El número es impar";
                    else set mensaje ="el número no es impar";
                    end if;
            
            select mensaje as impar;
            
            end
    
    $$


call impar(5);

/*5.	Crear una funcion llamada “par_impar” que se encargue de determinar(visualizar) 
si el número con que se le invoca es impar o no de tal forma que nos visualice lo siguiente:
Si el número es par: El número es par
En caso contrario: el número es impar
MEJORA: INTENTAD que a la hora de visualizar el mensaje nos salga(ver función CONCAT):
El número x(por ejemplo 35) es impar*/

drop function if exists par_impar;
	delimiter $$
		create function par_impar(valor integer)returns varchar(300)
		 deterministic
			begin 
				declare mensaje varchar(300) default "";
					if (valor%2 like 0) then set mensaje =concat("el número ", valor," es par");
                    else set mensaje =concat("el número ", valor," es impar");
                    end if;
                    
                    return mensaje;
            end
    $$
    
    select par_impar(5) as Par_Impar;

/*6.	Crear un procedimiento llamado
 “cuentaletras” para que visualice por pantalla el número de letras
 que contiene el mensaje con que se le invoque(llame o ejecute)
NOTA: ver apartado 12.3 del manual SUPERCOMPLETO de MYSQL.*/


drop procedure if exists cuentalentras;
	delimiter $$
		create procedure cuentalentras(cadena varchar(200))
			 begin 
					select length(cadena);	
			 end
    $$
    
    call cuentaletras("mensaje");

/*7.	Crear una función llamada  “cuentadigitos” para que visualice por pantalla el número 
de dígitos(números) que contiene la función cuando se le invoque(llame o ejecute)*/

drop function if exists cuentadigitos;
	delimiter $$
		create function cuentadigitos(numero integer)returns integer
        deterministic
			 begin 
					return length(numero);	
			 end
    $$
    
    select cuentadigitos(455);

