#1.	Crear una funcion llamada “PRODUCTOSDIST” que se encargue de devolver el número de tipo de productos
# distintos que tenemos(nos debe dar 4).

SET FOREIGN_KEY_CHECKS=0;
SET SQL_SAFE_UPDATES = 0;

drop function if exists PRODUCTOSDIST
delimiter $$
	create function PRODUCTOSDIST()returns varchar(200)
    deterministic
		begin
        
			return (select count(distinct( productos.DESCRIPCION)) from productos group by productos.descripcion );
        
        end
$$

select PRODUCTOSDIST();

#2.	Crea ahora un procedimiento llamado  “POBDISTINTAS”  que visualice el número de poblaciones 
#distintas con las que trabajamos(nos debe dar 18).

drop procedure if exists POBDISTINTAS
	delimiter $$
			create procedure POBDISTINTAS()
            begin 
				 select count(poblaciones.POBLACION) as poblaciones from poblaciones;
            end
    $$

call POBDISTINTAS();


#3.Crea una función(CODIGOVENTA) que nos devuelva  el último número de venta más uno (51).

drop function if exists CODIGOVENTA
	delimiter $$
		create function CODIGOVENTA()returns integer
        deterministic 		
            begin
            
				declare ultimoPedido integer;
                set ultimoPedido = (select max(ventas.noventa) from ventas);
                set ultimoPedido = ultimoPedido+1;
                return ultimoPedido;
       
            end
	$$
    
    select CODIGOVENTA();
    
#4.Crea un procedimiento(ZONACLIENTE) de tal forma que cuando se le invoque con un codigodecliente 
#nos diga a la zona que pertenece(NOTA:   SELECT … INTO variable(s): Apartado 19.2.9.3 del Manual 
#y Apartado 5.2.5 del Libro de RA-MA recomendado):

drop procedure if exists ZONACLIENTE;
	delimiter $$
		create procedure ZONACLIENTE(valor integer)
			begin 
				select zonas.nombre 
                from zonas
                inner join provincias on provincias.codzona = zonas.codigo
                inner join poblaciones on provincias.provincia = poblaciones.provincia
                inner join oficinas on oficinas.poblacion = poblaciones.poblacion
                inner join clientes on clientes.CODOFIC = oficinas.codigo
                where clientes.codigo like valor;  
            end
    $$
    
call zonaCliente(2)


#Ejemplo: el cliente número X “PEPITO”pertenece a la zona de YYYYYYYYYYY
#Ejemplo concreto:  el cliente número 2  JIMENEZ  pertenece a la zona de CASTILLA LA MANCHA

#5.	Crea una función(DATOSPRODUCTO) de tal forma que cuando se le llame 
#con el código de un Producto nos devuelva lo siguiente:
#PRODUCTO:  3  CAMA     CANTIDADVENDIDA: 99    PVP_UNIDAD: 120    IMPORTE:  11880€

drop function if exists DATOSPRODUCTO;
delimiter $$
	create function DATOSPRODUCTO(valor integer)returns varchar(300) 
    deterministic
		begin
			declare productoCodigo integer;
            declare productoDescripcion varchar(200);
            declare productoCantidadVendida integer;
            declare pvpUnidad integer;
            declare importeUnidad varchar(200);
            
            select productos.codigo, productos.descripcion, sum(lineasventa.ctd), productos.pvp, concat(sum(lineasventa.ctd*productos.pvp),"$") 
				into productoCodigo, productoDescripcion,productoCantidadVendida,pvpUnidad,importeUnidad
					from productos
						inner join lineasventa on lineasventa.codprod = productos.codigo
							where productos.codigo like valor;
			
            
            return concat("PRODUCTO",productoCodigo," 	 ",productoDescripcion,"	 CANTIDAD VENDIDA ",productoCantidadVendida,"	 PVP_UNIDAD ",pvpUnidad,"	 IMPORTE ",importeUnidad);
        end
$$
select DATOSPRODUCTO(3);


#6.Crea una función(STOCKXGAMA) de forma que cuando se le invoque con la descripción(tipo/gama)
# de producto nos devuelva el  STOCK que poseemos de ese tipo de producto.  Ej.: MESA: 130

drop function if exists STOCKXGAMA;
	delimiter $$
		create function STOCKXGAMA(valor varchar(200)) returns varchar(400)
			deterministic
				begin 
					declare tipoProducto varchar(200);
                    declare unidadesStock integer;
						select productos.descripcion, sum(productos.existencias) into tipoProducto, unidadesStock
							from productos
								where productos.descripcion like valor;

				return concat(tipoProducto,": ",unidadesStock);

				end	
    $$
select STOCKXGAMA("Cama");


#AVISADME cuando lleguéis aquí.

#7.	AÑADE  desde el WorkBench el atributo IMPORTE 
#(Integer)a la tabla VENTAS.  Crea un procedimiento (IMPORTEVENTAS) que se 
#encargue de calcular y almacenar el importe para cada venta.
#NOTA: Este ejercicio hay que hacerlo de 2 formas: 1) recorriendo la tabla VENTAS y 2)con TABLA TEMPORAL

drop procedure if exists IMPORTEVENTAS;
	delimiter $$
		create procedure IMPORTEVENTAS()
			begin 
            
				declare i integer default 0;
                declare valor integer;
				while(i<(select max(ventas.noventa)from ventas)) do
						
                    select sum(lineasventa.ctd * productos.pvp) into  valor
						from lineasventa 
						inner join productos on lineasventa.codprod = productos.codigo
						where lineasventa.noventa like i;
                        
					update ventas
                    set importe = valor
                    where ventas.noventa = i;
                        
					set i =i+1;    
                end while;
            end
    $$

call IMPORTEVENTAS();


drop procedure IF EXISTS IMPORTEVENTASTEMPORAL;
delimiter $$
	create procedure IMPORTEVENTASTEMPORAL()
		begin 
        
				declare i,j integer ;
                
                declare valor integer;
			
            
            
            drop temporary table ventasTemporal;
			CREATE TEMPORARY TABLE  ventasTemporal(
					codigo int not null  unique,
                    importeVenta int,
                    primary key(codigo));
                    
            insert into ventasTemporal 
				select lineasventa.noventa, sum(ctd*pvp)
					from lineasventa
						inner join productos on productos.codigo = lineasventa.codprod 
					group by lineasventa.noventa
                    order by lineasventa.noventa;
                    
                   set i = (select min(codigo)from ventasTemporal);
				   set j = (select max(codigo)from ventasTemporal);
                    
				while(i<j) do
						
					update ventas, ventasTemporal
                    set ventas.importe =  ventasTemporal.importeVenta
                    where ventas.noventa = ventasTemporal.codigo
                    and ventas.noventa =i;

					set i =i+1;    
                end while;
			end;
$$ 
call IMPORTEVENTASTEMPORAL();


#8.	AÑADE  desde el WorkBench el atributo NUMVENTAS a la tabla POBLACIONES. 
# Crea una funcion (NUMEROVENTAS) que se encargue de calcular y almacenar el numerodeventas para cada poblacion.
#NOTA: Este ejercicio hay que hacerlo de 2 formas: 1) con TABLA TEMPORAL y 2) con un CURSOR


drop function if exists NUMEROVENTAS;
	delimiter $$
		create function NUMEROVENTAS () returns varchar(100)
		deterministic
			begin
				 declare i,j int;
                 
                 drop temporary table if exists poblacionesTemporal;
					create temporary table poblacionesTemporal (
						codigo int auto_increment not null unique,
                        pob varchar(30),
                        numventas int,
                        primary key(codigo));
                        
                  insert into poblacionesTemporal(pob,numventas)
					select poblaciones.poblacion, count(distinct ventas.noventa)
						from poblaciones
							inner join oficinas on oficinas.poblacion = poblaciones.poblacion
                            inner join clientes on clientes.codofic = oficinas.codigo
                            inner join ventas on ventas.codcli = clientes.codigo
					group by poblaciones.poblacion;
                  
                  set i = (select min(poblacionesTemporal.codigo) from poblacionesTemporal);
                  set j = (select max(poblacionesTemporal.codigo) from poblacionesTemporal);
			while(i<j) do
					update poblaciones, poblacionesTemporal
                    set poblaciones.numventas =  poblacionesTemporal.numventas
                    where poblaciones.poblacion = poblacionesTemporal.pob
                    and poblacionesTemporal.codigo =i;
                    
                    set i  = i+1;
            end while;
                 
                 return ("Pa lante");
                 
			end
$$


update poblaciones set NUMVENTAS=0;
select * from poblaciones;

select NUMEROVENTAS();

drop function if exists NUMEROVENTASCURSORES;
	delimiter $$
		create function NUMEROVENTASCURSORES () returns varchar(300)
			deterministic 
				begin 
					declare final,numventa int default 0;
                    declare pobls varchar(200);
                    declare cursorVentas cursor for
						select poblaciones.poblacion, count(distinct ventas.noventa)
							from poblaciones
								inner join oficinas on oficinas.poblacion = poblaciones.poblacion
                                inner join clientes on clientes.codofic = oficinas.codigo
                                inner join ventas on ventas.codcli = clientes.codigo
                                group by poblaciones.poblacion;
                
					
                    declare continue handler for not found set final =1;
                    open cursorVentas;
                    
						while final =0 do
							fetch cursorVentas into pobls,numventa;
								update poblaciones
								set poblaciones.NUMVENTAS = numventa
                                where poblaciones.poblacion = pobls;
                            
						end while;
                        close cursorVentas;
                      return "Pa lante 2.0";
                end
    $$

select NUMEROVENTASCURSORES();

#9.	AÑADE  desde el WorkBench el atributo IMPORTE a la tabla PROVINCIAS. 
# Crea un procedimiento (IMPORTEPROVS) que se encargue de calcular y almacenar el importe para cada provincia.
#NOTA: Este ejercicio hay que hacerlo de 2 formas: 1) con TABLA TEMPORAL y 2) con un CURSOR

drop procedure if exists  IMPORTEPROVS;
	delimiter $$
		create procedure IMPORTEPROVS()
			begin 
				declare i,j int;
                
                drop temporary table importeProveedoresTemporal;
					create temporary table importeProveedoresTemporal(
						codigo int not null auto_increment unique,
                        prov varchar(30),
                        importeTemporal int,
                        primary key(codigo));
				
                insert into importeProveedoresTemporal(prov,importeTemporal)
						select provincias.provincia, sum(lineasventa.ctd*productos.pvp)
							from provincias
								inner join poblaciones on poblaciones.provincia = provincias.provincia
                                inner join oficinas on oficinas.poblacion = poblaciones.poblacion 
                                inner join clientes on clientes.codofic = oficinas.codigo
                                inner join ventas on ventas.codcli = clientes.codigo
                                inner join lineasventa on lineasventa.noventa = ventas.noventa
                                inner join productos on productos.codigo = lineasventa.codprod
							group by provincias.provincia;
							
				set i = (select min(importeProveedoresTemporal.codigo) from importeProveedoresTemporal);
                set j = (select max(importeProveedoresTemporal.codigo) from importeProveedoresTemporal);
                
                while(i<j) do
					
                    update provincias, importeProveedoresTemporal
                    set provincias.IMPORTE =  importeProveedoresTemporal.importeTemporal
                    where provincias.provincia = importeProveedoresTemporal.prov
                    and importeProveedoresTemporal.codigo =i;
	
                    set i = i+1;
                end while;
            end
    $$
    
    
drop procedure if exists IMPORTEPROVINCIACURSOR;
	delimiter $$
		create procedure IMPORTEPROVINCIACURSOR()
			begin 
				declare final,importePr int default 0;
                declare provi varchar(200);
                declare  cursorProvinciaImporte cursor for 
					select provincias.provincia, sum(lineasventa.ctd*productos.pvp)
						from provincias 
							inner join poblaciones on poblaciones.provincia = provincias.provincia
                            inner join oficinas on oficinas.poblacion = poblaciones.poblacion
                            inner join clientes on clientes.codofic = oficinas.codigo
                            inner join ventas on ventas.codcli = clientes.codigo
                            inner join lineasventa on lineasventa.noventa = ventas.noventa
                            inner join productos on productos.codigo = lineasventa.codprod
						group by provincias.provincia;

				declare continue handler for not found set final = 1;
                open cursorProvinciaImporte;
					while final=0 do
						fetch cursorProvinciaImporte into provi, importePr;
                        
                        update provincias 
                        set provincias.IMPORTE = importePr
                        where provincias.provincia = provi;
					end while;
                    close cursorProvinciaImporte;
            
            end
    $$
    
select * from provincias;    
update provincias set IMPORTE=0;
call IMPORTEPROVINCIACURSOR();






#10.AÑADE  desde el WorkBench los atributos  IMPORTE(Integer) y STATUS(varchar(20))  a la tabla CLIENTES.
#Crea un procedimiento (ACTUALIZACLIENTES) que se encargue de calcular y almacenar el IMPORTE  y el STATUS para cada cliente, 
#según los siguientes criterios:
#STATUS menos de 2500: MALO
#STATUS entre 2500 y 5000: NORMAL
#STATUS entre 5000 y 10000: BUENO
#STATUS mas de 10000: EXCELENTE
#NOTA: Este ejercicio hay que hacerlo de 2 formas: 1)recorriendo la tabla CLIENTES y 2) con un CURSOR
#OPINIÓN PERSONAL: como le pilléis el “punto” a los CURSORES, donde se “ponga” un cursor que  se “quiten” las
# otras 2 posibilidades:  recorrer la tabla o utilizar una TABLA TEMPORAL, es más lógico, cómodo  y fácil para mí.
 

drop procedure if exists ACTUALIZACLIENTES;
	delimiter $$
		create procedure ACTUALIZACLIENTES()
			begin 
				declare final int default 0;
				declare importeCli,codigoCl int;
                declare i, j int;
                declare statusInfo varchar(200);
                declare importeTemporal int;
                
                
                declare  cursorClienteImporte cursor for 
					select clientes.codigo, sum(lineasventa.ctd*productos.pvp)
						from clientes 
                            inner join ventas on ventas.codcli = clientes.codigo
                            inner join lineasventa on lineasventa.noventa = ventas.noventa
                            inner join productos on productos.codigo = lineasventa.codprod
						group by clientes.codigo;

				declare continue handler for not found set final = 1;
                open cursorClienteImporte;
					while final=0 do
						fetch cursorClienteImporte into codigoCl, importeCli;
                        
                        update clientes 
                        set clientes.IMPORTE = importeCli
                        where clientes.codigo = codigoCl;
					end while;
                    close cursorClienteImporte;
            
				set i = (select min(clientes.codigo) from clientes);
                set j = (select max(clientes.codigo) from clientes);
                
                while(i<j) do			
						if((select clientes.importe from clientes where clientes.codigo=i)<2500 )
									THEN  update clientes 
									set clientes.status = "MALO"
									where clientes.codigo = i;
						elseif((select clientes.importe from clientes where clientes.codigo=i)<5000)
									THEN  update clientes 
									set clientes.status = "NORMAL"
									where clientes.codigo = i;   
						elseif((select clientes.importe from clientes where clientes.codigo=i)<10000)
									THEN  update clientes 
									set clientes.status = "BUENO"
									where clientes.codigo = i;    
						elseif((select clientes.importe from clientes where clientes.codigo=i)>10000)
									THEN  update clientes 
									set clientes.status = "EXCELENTE"
									where clientes.codigo = i;    
                                    
					end if;
                set i = i+1;
                end while;
            
            end
    $$
    
    call ACTUALIZACLIENTES();

select * from clientes;




Crear los siguientes procedimientos y funciones sobre la BBDD NBA:
NOTA: Examinad DETENIDAMENTE la BBDD “NBA”.  Crear el MER utilizando la ingeniería inversa de la BBDD “nba”. Borrad de la BBDD “NBA”
 todo lo que no sea de la temporada “07/08”. Por tanto habrá que borrar tanto en PARTIDOS como en ESTADISTICAS.
¡¡OJO!!: Aquí nos podemos encontrar “SALTOS” en la codificación, jugadores y equipos que no han jugado, etc.,etc.


Delete 
from partidos
where partidos.temporada != "07/08";

Delete 
from estadisticas
where estadisticas.temporada != "07/08";

#11.	Crea una función(TOTALPARTIDOS) de forma que nos devuelva el número de partidos disputados en la temporada(870).

drop function if exists TOTALPARTIDOS;
	delimiter $$
		create function TOTALPARTIDOS ()returns int
        deterministic 
			begin
				return (select count(partidos.codigo) from partidos where partidos.temporada ="07/08");
            end
    $$
    select TOTALPARTIDOS();

#12.	AÑADE  desde el WorkBench el atributo STATUS(varchar(20)) a la tabla JUGADORES.  
#Crea un procedimiento (CALIFJUGADOR) de forma que califique a cada jugador  de acuerdo a sus PUNTOS_POR_PARTIDO de 
#la tabla “estadisticas” según el siguiente baremo:
#(0,5(: MALO
#(5,10(: NORMAL
#(10,20(: BUENO
#Más de 20: EXCELENTE
#NOTA: en caso de no haber jugado se debe quedar en blanco(null).

drop procedure if exists CALIFJUGADOR;
delimiter $$
		create procedure CALIFJUGADOR()
			begin
				declare i,j int default 0;
				set i = (select min(jugadores.codigo) from jugadores);
                set j = (select max(jugadores.codigo) from jugadores);
                
                while(i<j) do
		
						if((select avg(estadisticas.Puntos_por_partido) from estadisticas where estadisticas.jugador like i )<5.0 ) then
							update jugadores
                            set jugadores.STATUS ="Malo"
                            where jugadores.codigo = i;
						elseif((select avg(estadisticas.Puntos_por_partido) from estadisticas where estadisticas.jugador like i )<10.0 ) then
							update jugadores
                            set jugadores.STATUS ="NORMAL"
                            where jugadores.codigo = i;
						elseif((select avg(estadisticas.Puntos_por_partido) from estadisticas where estadisticas.jugador like i )<20.0) then
							update jugadores
                            set jugadores.STATUS ="BUENO"
                            where jugadores.codigo = i;
						elseif((select avg(estadisticas.Puntos_por_partido) from estadisticas where estadisticas.jugador like i)>20.0) then
							update jugadores
                            set jugadores.STATUS ="EXCELENTE"
                            where jugadores.codigo = i;
                        else 
							update jugadores
                            set jugadores.STATUS =""
                            where jugadores.codigo = i;
                            end if;						
                set i= i+1;
                end while;

			end
$$

call CALIFJUGADOR();
select * from jugadores;

#13.	Crea una función(DISPUTA) de forma  que cuando se le invoque con un equipo nos devuelva 1(TRUE) 
#	si ha jugado algún partido o 0(FALSE)  si no ha jugado ningún partido

drop function if exists DISPUTA;
delimiter $$
	create function DISPUTA(equipo varchar(50))returns int
		deterministic
			begin
				
                declare valor int; 
                if((select count(partidos.codigo) from partidos where partidos.equipo_local like equipo or partidos.equipo_visitante like equipo)>0 ) 
					then set valor=1;
				else 
					set valor=0;
				end if;
				return valor;
            end
$$
select DISPUTA("Lakers");

#14.	Crea ahora una función(PUNTOSEQUIPO) de forma  que cuando
#se le invoque con un equipo nos devuelva los puntos totales que lleva(tanto a nivel local como visitante)

drop function if exists pntEquipo;
	delimiter $$
		create function pntEquipo(valor varchar(100)) returns int 
			deterministic 
				begin
				     declare puntosLocal,puntosVisitante,total int;
                      set puntosLocal = (select sum(partidos.puntos_local)
											from partidos 
                                                where  partidos.equipo_local like valor);
				       set puntosVisitante = (select sum(partidos.puntos_visitante)
											from partidos 
                                                where  partidos.equipo_visitante like valor);
					   set total = puntosLocal+puntosVisitante;
                             
					return total;
               end	
    $$
    
    select pntEquipo("Bucks");


#15.AÑADE  desde el WorkBench el atributo PUNTOSTOTALES(Integer) a la tabla EQUIPOS.  
#Crea un procedimiento (PUNTOS) de forma que invoque a la función 
#anterior y se encargue de almacenar los puntos para cada equipo(tanto locales como visitante)

 drop procedure if exists PUNTOS;
	delimiter $$
		create procedure PUNTOS()
			begin
				declare final int default 0;
                declare codigo varchar(200);
				declare cursorPartidos cursor for 
                   select equipos.nombre
					from equipos
                    group by equipos.nombre;
                      
			declare continue handler for not found set final =1;
                    open cursorPartidos;
                    
						while final =0 do
							fetch cursorPartidos into codigo;
								update equipos
								set equipos.PUNTOSTOTALES = pntEquipo(codigo)
                                where equipos.Nombre = codigo;
                            
						end while;
                        close cursorPartidos;
                   
          
            end
    $$
 
 call PUNTOS();

#16.	Crea una función(OBTENERCODIGOJUGADOR) de forma que obtenga y devuelva el primer “hueco”
# 		en la codificación de los Jugadores.

drop function if exists  OBTENERCODIGOJUGADOR;
DELIMITER $$
CREATE FUNCTION OBTENERCODIGOJUGADOR() RETURNS INT(3)
DETERMINISTIC
BEGIN
	DECLARE final,contador, min, resultado INT DEFAULT 0;
    SET min = (SELECT MIN(jugadores.codigo)
							FROM JUGADORES);
    set contador = min;
    while final = 0 DO
		if (contador != min) then
			SET final = 1;
		else
			set resultado = contador;
            set contador = contador +1;
		end if;
	end while;
    
    return 15;
end
$$

SELECT OBTENERCODIGOJUGADOR();


