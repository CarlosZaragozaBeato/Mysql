#1.- Lista las distintas provincias sin duplicidad ordenadas alfabéticamente.(comentar)
	
    select distinct provincias.provincia
    from provincias 
    order by provincias.provincia;
    


#2.- Lista todas las ventas del mes de Junio (codcli,fechaventa,numeroventa) ordenadas por codigo cliente, fechaventa y numeroventa.

	select clientes.codigo, ventas.fechav, ventas.noventa
		from ventas 
        inner join clientes on clientes.CODIGO = ventas.CODCLI
        where month(ventas.fechav) =(6)
        order by clientes.codigo, ventas.fechav, ventas.noventa;
        

#3.- Obtener un listado de existencias de las mesas de madera (codigo,descripcion,existencias) ordenadas por existencias de forma descendente.
	
    select productos.codigo, productos.descripcion, productos.existencias
		from productos 
		where productos.material = "madera" 
        and productos.descripcion = "mesa"
        order by productos.existencias desc;




#4.- Listar los clientes de andalucia con los siguientes datos: 
#	 codcli, nombre, oficina, poblacion, provincia
#	 ordenados por provincia,poblacion.

	select clientes.codigo, clientes.nombre, oficinas.codigo, poblaciones.poblacion, provincias.provincia
		from zonas
			inner join provincias on provincias.codzona = zonas.codigo
			inner join poblaciones on poblaciones.provincia = provincias.provincia 
            inner join oficinas on oficinas.poblacion = poblaciones.poblacion
            inner join clientes on clientes.codofic = oficinas.codigo
            where zonas.nombre ="Andalucia"
            order by provincias.provincia, poblaciones.poblacion;

#5.- Obtener el importe total de las ventas realizadas hasta el momento.

	select concat(format(sum(productos.pvp*lineasventa.ctd),2),"$") as importe
		from productos 
			inner join lineasventa on lineasventa.codprod = productos.codigo;



#6.- Obtener el importe de cada venta con los siguientes datos: 
#	fechaventa, numeroventa, codcli, nombrecliente, importe     ordenados por codcli,fechav,numeroventa.

	select ventas.fechav, ventas.noventa, clientes.codigo, clientes.nombre ,concat(format(sum(productos.pvp*lineasventa.ctd),2),"$") as importe
		from clientes 
			inner join ventas on ventas.codcli = clientes.codigo
            inner join lineasventa on lineasventa.noventa = ventas.noventa
            inner join productos on productos.codigo = lineasventa.codprod
            group by ventas.noventa
			order by ventas.codcli,ventas.fechav, ventas.noventa;

#7.- Obtener el numero de ventas e importe total de cada oficina: 
#	 codoficina, poblacion, numeroventas, importe
#	 ordenados por poblacion y por importe de mayor a menor.

	select oficinas.codigo, oficinas.poblacion, ventas.noventa, concat(format(sum(productos.pvp*lineasventa.ctd),2),"$") as importe
		from oficinas
			inner join clientes on clientes.codofic = oficinas.codigo
            inner join ventas on ventas.codcli = clientes.codigo
            inner join lineasventa on lineasventa.noventa = ventas.noventa
            inner join productos on productos.codigo = lineasventa.codprod
            group by oficinas.codigo
            order by oficinas.poblacion,sum(productos.pvp*lineasventa.ctd) desc;


#8.- Obtener el numero de oficinas de cada área (codarea, nombre, numerodeoficinas)

	select areas.codigo, areas.nombre, count(oficinas.codigo) as numOficinas
		from areas
			inner join zonas on zonas.codarea = areas.codigo
            inner join provincias on provincias.codzona = zonas.codigo
            inner join poblaciones on poblaciones.provincia = provincias.provincia
            inner join oficinas on oficinas.poblacion = poblaciones.poblacion
            group by areas.codigo;


#9.- Obtener el valor total de existencias

	select concat(format(sum(productos.pvp*productos.existencias),2),"$") 
		from productos;


#10.- Obtener el importe total de las ventas de cada zona: codigozona, nombre, importetotal 
#      ordenados por importe.

	select zonas.codigo, zonas.nombre, concat(format(sum(productos.pvp*lineasventa.ctd),2),"$") 
		from  zonas 
            inner join provincias on provincias.codzona = zonas.codigo
            inner join poblaciones on poblaciones.provincia = provincias.provincia
            inner join oficinas on oficinas.poblacion = poblaciones.poblacion
			inner join clientes on clientes.codofic = oficinas.codigo
            inner join ventas on ventas.codcli = clientes.codigo
            inner join lineasventa on lineasventa.noventa = ventas.noventa
            inner join productos on productos.codigo = lineasventa.codprod
            group by zonas.codigo
            order by sum(productos.pvp*lineasventa.ctd) desc;



#11.- Obtener el precio medio de cada tipo de producto: descripcion, preciomedio

	select productos.descripcion, format(avg(productos.pvp),2)as precioMedio
		from productos
        group by productos.descripcion;


#12.- lista las oficinas que hayan tenido más de 2 ventas: 
#	  codofic, poblacion, provincia, numeroventas

	
    select oficinas.codigo, oficinas.poblacion, provincias.provincia, count(ventas.noventa)
		from ventas
			inner join clientes on clientes.codigo = ventas.codcli
            inner join oficinas on oficinas.codigo = clientes.codofic
            inner join poblaciones on poblaciones.poblacion = oficinas.poblacion
            inner join provincias on provincias.provincia = poblaciones.provincia
            group by oficinas.codigo
            having count(ventas.noventa) >2;



#13.- Obtener todos aquellos pedidos que superen los 3000€ con los siguientes datos:
#		codzona,nombrezona,codofic,poblacion,provincia,noventa, fechaventa ,
#		importe ordenados por zonas y oficinas.

	select zonas.codigo, zonas.nombre, oficinas.codigo, poblaciones.poblacion, provincias.provincia, ventas.noventa, ventas.fechav, concat(format(sum(productos.pvp*lineasventa.ctd),2),"$") 
		from  zonas 
            inner join provincias on provincias.codzona = zonas.codigo
            inner join poblaciones on poblaciones.provincia = provincias.provincia
            inner join oficinas on oficinas.poblacion = poblaciones.poblacion
			inner join clientes on clientes.codofic = oficinas.codigo
            inner join ventas on ventas.codcli = clientes.codigo
            inner join lineasventa on lineasventa.noventa = ventas.noventa
            inner join productos on productos.codigo = lineasventa.codprod
            group by ventas.noventa
			having sum(productos.pvp*lineasventa.ctd)>3000
            order by  sum(productos.pvp*lineasventa.ctd) desc, zonas.codigo, oficinas.codigo;
            


#14.- Listar aquellos productos(por tipo ó descripcion): 
#	 descripcion, existencias cuyas existencias supongan menos del 25% del Total de las  existencias.

	select productos.descripcion, sum(productos.existencias) as existencias25
		from productos
		group by productos.descripcion
         having sum(productos.existencias)<=(select sum(productos.existencias)*.25
												from productos)
		order by 	existencias25 desc;

#15.- Obtener el cliente que más nos haya comprado: 
#	  codcli, nombrecli, codofic, poblacion, importe


select clientes.codigo, clientes.nombre, oficinas.codigo, oficinas.poblacion, concat(format(sum(productos.pvp*lineasventa.ctd),2),"$") as importe
	from oficinas
			inner join clientes on clientes.codofic = oficinas.codigo
            inner join ventas on ventas.codcli = clientes.codigo
            inner join lineasventa on lineasventa.noventa = ventas.noventa
            inner join productos on productos.codigo = lineasventa.codprod
            group by clientes.codigo
            order by sum(productos.pvp*lineasventa.ctd) desc
            limit 1;
    

#16.- Obtener los precios máximos por tipo de producto(descripcion) con los siguientes datos:
#	  codproducto, descripcion, preciomax

	select productos.codigo, productos.descripcion, max(productos.pvp) as precioMax
		from productos
       	
		group by productos.DESCRIPCION
		having max(productos.pvp)>=all(select max(productos.pvp)
												from productos as pr
                                                where pr.descripcion = productos.descripcion
                                                group by productos.codigo
                                                )
		order by productos.DESCRIPCION desc ;



#17.- Obtener los porcentajes de venta de cada producto: codproducto, descripcion, %venta.
	

    select productos.codigo, productos.descripcion, concat(format(sum(lineasventa.ctd*productos.pvp)/(select sum(lineasventa.ctd*productos.pvp)/100
																							from productos
																								inner join lineasventa on lineasventa.CODPROD = productos.codigo),2),'%')
		from productos
        inner join lineasventa on lineasventa.CODPROD = productos.codigo
        group by productos.codigo
        order by productos.codigo;




#18. Obtener el importe de las ventas de cada producto con los siguientes datos(¡OJO!, en esta consulta deben salir TODOS, TODOS los PRODUCTOS independientemente de que se hayan vendido o NO):
#	CODPROD, DESCRIPCION, CANTIDADVENDIDA, PVP-UNIDAD, IMPORTE
#	Ordenados por IMPORTE de mayor a menor 

	select productos.codigo, productos.descripcion, lineasventa.ctd, productos.pvp, concat(format(sum(productos.pvp*lineasventa.ctd),2),"$") as importe
		from lineasventa
			right join productos on productos.codigo = lineasventa.codprod
            group by productos.codigo
            order by sum(productos.pvp*lineasventa.ctd) desc;

#19. Obtener el %ventas de cada tipo de producto con los siguientes datos:
#	DESCRIPCION, IMPORTEVENTAS, %VENTAS
#	Ordenados por %VENTAS de mayor a menor 

	select productos.descripcion, concat(format(sum(productos.pvp*lineasventa.ctd),2),"$") as importe , sum(productos.pvp*lineasventa.ctd)/(select sum(lineasventa.ctd*productos.pvp)/100
																							from productos
																								inner join lineasventa on lineasventa.CODPROD = productos.codigo) as porcentaje
		from productos 
		inner join lineasventa on lineasventa.CODPROD = productos.codigo
        group by productos.descripcion
        order by porcentaje desc;
                                                                                                
                                                                                                

#20. Obtener un listado de las ventas del primer trimestre con los siguientes datos:
#	NOVENTA, FECHAV, IMPORTEVENTA
#	Ordenadas por FECHAV,NOVENTA

select ventas.noventa, ventas.fechav,  sum(productos.pvp*lineasventa.ctd) as importe 
	from productos 
		inner join lineasventa on lineasventa.CODPROD = productos.codigo
        inner join ventas on lineasventa.noventa = ventas.noventa
        where month(ventas.fechav) between(1) and(3)
        group by ventas.noventa
        order by ventas.fechav, ventas.noventa;

#21. Obtener el producto “estrella” de cada zona con los siguientes datos:
#	 CODZONA, NOMBREZONA, CODPROD, DESCRIPCION, IMPORTEVENTAS

select zonas.codigo, zonas.nombre, productos.codigo, productos.DESCRIPCION, sum(productos.pvp*lineasventa.ctd) as importe 
		from  zonas 
            inner join provincias on provincias.codzona = zonas.codigo
            inner join poblaciones on poblaciones.provincia = provincias.provincia
            inner join oficinas on oficinas.poblacion = poblaciones.poblacion
			inner join clientes on clientes.codofic = oficinas.codigo
            inner join ventas on ventas.codcli = clientes.codigo
            inner join lineasventa on lineasventa.noventa = ventas.noventa
            inner join productos on productos.codigo = lineasventa.codprod
            group by zonas.codigo, productos.codigo
            having sum(productos.pvp*lineasventa.ctd)>=all(select sum(pr.pvp*lineasventa.ctd)
																from  zonas  as zn
																	inner join provincias on provincias.codzona = zn.codigo
																	inner join poblaciones on poblaciones.provincia = provincias.provincia
																	inner join oficinas on oficinas.poblacion = poblaciones.poblacion
																	inner join clientes on clientes.codofic = oficinas.codigo
																	inner join ventas on ventas.codcli = clientes.codigo
																	inner join lineasventa on lineasventa.noventa = ventas.noventa
																	inner join productos as pr on pr.codigo = lineasventa.codprod
                                                                    where zn.codigo = zonas.codigo
																	group by zn.codigo, pr.codigo)
			order by zonas.codigo;

#22. Obtener el % de existencias de cada tipo de producto con los siguientes datos:
#	TIPO(DESCRIPCION), EXISTENCIAS, %EXISTENCIAS

	select productos.descripcion, sum(productos.existencias), sum(productos.existencias)/(select sum(productos.existencias)/100
																					from productos) as porcentaje
			from productos
            group by productos.DESCRIPCION
            order by productos.DESCRIPCION;


#23. Obtener el mejor cliente de cada población con los siguientes datos:
#	POBLACION, CODCLI, NOMCLI,  IMPORTEVENTAS

select poblaciones.poblacion, clientes.codigo, clientes.nombre, SUM(productos.pvp*lineasventa.ctd) as importeVenta
from clientes 
	inner join ventas  ON clientes.CODIGO = ventas.CODCLI
    inner join lineasventa ON ventas.noventa = lineasventa.noventa
    inner join productos ON lineasventa.codprod = productos.codigo
    inner join oficinas   ON clientes.codofic = oficinas.codigo
    inner join poblaciones  ON oficinas.poblacion = poblaciones.poblacion
group by clientes.codigo, poblaciones.poblacion
having importeVenta >=all (SELECT SUM(productos.PVP*lineasventa.CTD)
							FROM productos 
								INNER JOIN lineasventa ON productos.codigo = lineasventa.codprod
                                INNER JOIN ventas  ON lineasventa.noventa = ventas.noventa
                                INNER JOIN clientes as cl  ON ventas.codcli = cl.codigo
                                INNER JOIN OFICINAS  ON cl.codofic = oficinas.codigo
                                INNER JOIN poblaciones as pob  ON oficinas.poblacion = pob.poblacion
                                WHERE pob.POBLACION = poblaciones.POBLACION
                                GROUP BY cl.CODIGO, pob.POBLACION)
ORDER BY clientes.CODIGO;

                

#24. Obtener el ranking de los 5 mejores clientes (en base al IMPORTEVENTAS) con los siguientes datos:
#	CODCLI, NºVENTAS, IMPORTEVENTAS,  %VENTAS

select clientes.codigo, count(distinct ventas.noventa), sum(productos.pvp*lineasventa.ctd),sum(productos.pvp*lineasventa.ctd)/(select sum(lineasventa.ctd*productos.pvp)/100
																													from productos
																															inner join lineasventa on lineasventa.CODPROD = productos.codigo) as porcentaje
      from clientes
            inner join ventas on ventas.codcli = clientes.codigo
            inner join lineasventa on lineasventa.noventa = ventas.noventa
            inner join productos on productos.codigo = lineasventa.codprod
            group by clientes.codigo
            order by sum(productos.pvp*lineasventa.ctd) desc
            limit 5;
            



#25. Obtener la mejor oficina de cada area, con los siguientes datos:
#	CODAREA, NOMBRE, CODOFIC, POBLACION, IMPORTEVENTAS

select are.codigo, are.nombre, ofi.codigo, pob.poblacion, SUM(prod.pvp*lin.ctd) as importeVentas
from areas as are
	inner join zonas as zon on are.codigo = zon.codarea
    inner join provincias as prov on zon.codigo = prov.codzona
    inner join poblaciones as pob on prov.provincia = pob.provincia
    inner join oficinas as ofi on pob.poblacion = ofi.poblacion
    inner join clientes as cli on ofi.codigo = cli.codofic
    inner join ventas as ven on cli.codigo = ven.codcli
    inner join lineasventa as lin on ven.noventa = lin.noventa
    inner join productos as prod on lin.codprod = prod.codigo
GROUP BY are.codigo, ofi.codigo
HAVING IMPORTEVENTAS >=ALL (SELECT SUM(prod.PVP*lin.CTD)
							FROM AREAS AS are1
								INNER JOIN ZONAS AS zon ON are1.CODIGO = zon.CODAREA
								INNER JOIN PROVINCIAS AS prov ON zon.CODIGO = prov.CODZONA
								INNER JOIN POBLACIONES AS pob ON prov.PROVINCIA = pob.PROVINCIA
								INNER JOIN OFICINAS AS ofi1 ON pob.POBLACION = ofi1.POBLACION
								INNER JOIN CLIENTES AS cli ON ofi1.CODIGO = cli.CODOFIC
								INNER JOIN VENTAS AS ven ON cli.CODIGO = ven.CODCLI
								INNER JOIN LINEASVENTA AS lin ON ven.NOVENTA = lin.NOVENTA
								INNER JOIN PRODUCTOS AS prod ON lin.CODPROD = prod.CODIGO		
							WHERE are.CODIGO = are1.CODIGO
                            GROUP BY are1.CODIGO, ofi1.CODIGO);


#26. Obtener el IMPORTE de ventas de cada cliente(¡OJO!, en esta consulta deben salir 
#	TODOS, TODOS los clientes independientemente de que hayan comprado algo o no):
#	CODCLI, NOMBRE, NºVENTAS, IMPORTEVENTAS
#	Ordenados por  IMPORTE de mayor a menor.



select clientes.codigo, clientes.nombre, ventas.noventa, concat(format(sum(productos.pvp*lineasventa.ctd),2),"$") as importe
	from clientes 
		inner join ventas on ventas.codcli = clientes.codigo
        inner join lineasventa on lineasventa.noventa = ventas.noventa
        right join productos on productos.codigo = lineasventa.codprod
        group by clientes.codigo
        order by sum(productos.pvp*lineasventa.ctd) desc;
        
        
        
        
/*Actualizaciones*/ 

/*28.- Cambiar la zona de Murcia de la 4 a la 10.*/
SET FOREIGN_KEY_CHECKS=0;
SET SQL_SAFE_UPDATES = 0;

UPDATE PROVINCIAS
SET CODZONA = 10
WHERE CODZONA = (SELECT CODIGO
				FROM ZONAS
				WHERE NOMBRE = "Murcia");
                
UPDATE ZONAS
SET CODIGO = 10
WHERE NOMBRE = "Murcia";

/*29.- Adicionar 100 a los códigos de las mesas.*/

UPDATE LINEASVENTA
SET CODPROD = CODPROD + 100
WHERE CODPROD IN (SELECT CODIGO
				FROM PRODUCTOS
                WHERE DESCRIPCION = "MESA");
                
UPDATE PRODUCTOS
SET CODIGO = CODIGO + 100
WHERE DESCRIPCION = "MESA";

/*30.- Realizad las operaciones necesarias para dar de baja al cliente número 3.*/
DELETE FROM LINEASVENTA
WHERE NOVENTA IN (SELECT NOVENTA
				  FROM VENTAS
                  WHERE CODCLI = 3);
                  
DELETE FROM VENTAS
WHERE CODCLI = 3;

DELETE FROM CLIENTES
WHERE CODIGO = 3;

/*31.- Resulta que la Oficina de Alcázar ha sido “absorbida” por la Oficina de Ciudad Real y “desaparece”. 
Por tanto se pide Realizar las actualizaciones necesarias para dejar la Base de Datos integra y consistente. */

UPDATE CLIENTES
SET CODOFIC = (SELECT CODIGO
				FROM OFICINAS
                WHERE POBLACION LIKE "CIUDAD REAL")
WHERE CODOFIC = (SELECT CODIGO
				FROM OFICINAS
				WHERE POBLACION LIKE "ALCAZAR DE SAN JUAN");

DELETE FROM OFICINAS
WHERE POBLACION LIKE "ALCAZAR DE SAN JUAN";


                