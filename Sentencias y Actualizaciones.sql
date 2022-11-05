/#1 TABLA

/#1.- Obtener todos los datos de todos los proveedores.

	select proveedores.* 
    from proveedores;

/#2.- Obtener el código y el nombre de todos los proveedores.
	
    select pr.codprov, pr.nombre 
    from proveedores as pr;

/#3.- Obtener todos los datos de las piezas.

	select piezas.*
    from piezas;

/#4.- Obtener un listado de existencias con los siguientes datos: código, nombre y existencias.

	select pz.codpieza, pz.nompieza, pz.existencias
    from piezas as pz;

/#5.- Obtener un listado con los precios de las piezas: codigo, nombre, precio.
	
    select pz.codpieza, pz.nompieza, pz.precio
    from piezas as pz;

/#6.- Obtener un listado de todos los pedidos ordenados por numero pedido(ORDER BY).

	select pedidos.*
    from pedidos
    order by numped;
    
/#7.- Obtener un listado de pedidos: numpedido, fechapedido ordenados por fecha y numero pedido.
    
    select pd.numped, pd.fechap
    from pedidos as pd
    order by pd.fechap, pd.numped;

/#8.- Obtener un listado de todas las remesas.

	select remesas.*
    from remesas;

/#9.- Seleccionar todos los proveedores de Madrid ordenados por codigo proveedor

	select pr.*
    from proveedores as pr
    where pr.POBLACION = 'MADRID'
    order by pr.codprov;

/#10.- Obtener el codigo y el nombre de todas aquellas piezas cuyas existencias estén bajo mínimo(<5)

	select pz.codpieza, pz.nompieza 
    from piezas as pz
    where pz.EXISTENCIAS<5;

/#11.- Obtener los códigos de todas las piezas suministradas(sin duplicidad).

	select distinct pz.codpieza
    from piezas as pz;
    
/#12.- Obtener los códigos de los proveedores que nos han suministrado piezas(sin duplicidad).

	select distinct pr.codprov 
    from proveedores as pr;
    
/#2 TABLAS

/#13.- Obtener un listado con todos los datos de los proveedores que nos han suministrado
/# 	   piezas(sin duplicidad). 

	select distinct pr.*
    from proveedores as pr
    inner join pedidos as pd
    on pd.CODPROV = pr.CODPROV;

/#14.- Obtener un listado con el codigo, nombre de la pieza y cantidad  
/#	   de todas las piezas suministradas.

	select pz.codpieza, pz.nompieza,rm.ctd 
    from piezas as pz
    inner join remesas as rm
    on rm.codpieza = pz.codpieza
    order by pz.codpieza;

/#15.- Obtener  un listado de pedidos con los siguientes datos:
/#	   numero pedido, codigo pieza, nombre pieza, cantidad suministrada

	select rm.numped, pz.codpieza, pz.nompieza, rm.ctd
    from piezas as pz
    inner join remesas as rm
    on rm.codpieza = pz.codpieza
    order by rm.numped;

/#16.- Obtener todos los datos de los tornillos suministrados junto con la cantidad.

	select pz.*, rm.ctd
    from piezas as pz 
    inner join remesas as rm
    on rm.codpieza = pz.codpieza
    where pz.nompieza ="TORNILLO"; 

/#17.- obtener un listado de todas las puntillas 
/#	   suministradas de color dorado, cuyo peso sea superior a 50 
/#     y cuya cantidad suministrada sea igual o superior a 100
/#     ordenados por numero pedido con los siguientes datos:
/#	   CODPIEZA, CANTIDAD

	select pz.*
    from piezas as pz 
    inner join remesas as rm
    on rm.codpieza = pz.codpieza
    where pz.color = 'DORADO'
	and pz.peso >50
    and rm.ctd >100
    order by pz.codpieza, rm.ctd;

/#18.- obtener un listado de todos aquellos pedidos de los proveedores
/# 	   de ALCAZAR a partir de marzo del 2012 
/#     ordenados por fecha,codigo proveedor, y numero de pedido con los siguientes datos:
/#     fecha, codigo proveedor, nombre proveedor, numero pedido.

	select pd.fechap, pr.codprov, pr.nombre, pd.numped
    from pedidos as pd
    inner join proveedores as pr
    on pd.codprov = pr.codprov
    where pr.poblacion ='ALCAZAR'
	and pd.fechap> '2021/03/01'
    order by pd.fechap, pr.codprov, pd.numped;


/#3 TABLAS:

/#19.- Obtener las remesas del proveedor FERSA con los siguientes datos: 
/#fecha pedido, numero pedido, codigo pieza, cantidad.    
/#(ordenados por la fecha del pedido)
	
    select pd.fechap,pd.numped,rm.codpieza, rm.ctd
    from pedidos as pd
    inner join remesas as rm
    on rm.NUMPED = pd.NUMPED
    inner join proveedores as pr
    on pr.codprov = pd.codprov
    where pr.nombre = "Fersa"
	order by pd.fechap
    ;
/#4 TABLAS


/#21.- Seleccionar las tuercas suministradas por los proveedores de MADRID y de ALCAZAR
/#	   ordenados por población y  numero pedido, con los siguientes datos: 
/#	   codigo proveedor, nombre proveedor, poblacion, numero pedido, codigo pieza, cantidad.

	select pr.codprov, pr.nombre, pr.poblacion, pd.numped, pz.codpieza, rm.ctd
    from proveedores as pr
    inner join pedidos as pd
    on pd.codprov = pr.codprov 
    inner join remesas as rm
    on rm.numped = pd.numped 
    inner join piezas as pz
    on pz.codpieza = rm.codpieza
    where pz.nompieza ="TUERCA"
    and 
    (pr.poblacion ="MADRID" or pr.poblacion = "ALCAZAR")
    order by pr.poblacion, pd.numped;



/#22.- Seleccionar todos aquellos pedidos que no sean de 
/#		marzo(NOT BETWEEN)  ordenados por poblacion, codigo proveedor, fecha pedido, 
/#		numero pedido con los siguientes datos: 
/#		poblacion, codigo proveedor, nombre proveedor, fecha pedido, 
/#		numero pedido, codigo pieza, nombre pieza, cantidad

	select pr.poblacion, pr.codprov, pr.nombre, pd.fechap, pd.numped, pz.codpieza, pz.nompieza,rm.ctd
    from proveedores as pr
    inner join pedidos as pd
    on pd.codprov = pr.codprov 
    inner join remesas as rm
    on rm.numped = pd.numped
    inner join piezas as pz
    on rm.codpieza = pz.codpieza
	where pd.fechap not between "2021/03/01" and "2021/03/31" 
    order by pr.poblacion, pr.codprov, pd.fechap
    ;



/#Modificaciones

#24.Añadir los siguientes datos(registros) correspondientes al proveedor numero 6
/#	en sus respectivas tablas: 
/#	PROVEEDORES(6, NUEVO, ALCAZAR); 
/#	PEDIDOS(13, 25/04/2012)
/#	2 remesas:	REMESAS(13, 2, 100) y 
/#	REMESAS(13, 3, 50)*/

	INSERT INTO PROVEEDORES
	VALUES (6, 'NUEVO', 'ALCAZAR');

	INSERT INTO PEDIDOS
	VALUES (13, '2021/04/25', 6);
	
	INSERT INTO REMESAS
	VALUES (13, 2, 100),
	(13,3,50);
    
/#24.- Cambiar  la poblacion del proveedor FERSA de ALCAZAR a MADRID. 

	UPDATE PROVEEDORES
	SET POBLACION = "MADRID"
	WHERE NOMBRE = "FERSA";

/#25.- Cambiar el precio a 25 a la pieza numero 1.

	UPDATE PIEZAS
	SET PRECIO = 25
	WHERE CODPIEZA = 1;

/#26.- Modificar el codigo de pieza 1 al codigo 101.

	UPDATE PIEZAS
	SET CODPIEZA = 101
	WHERE CODPIEZA = 1;

/#27.- Realizar las operaciones pertinentes para borrar la pieza numero 6.

	DELETE FROM PIEZAS
	WHERE CODPIEZA = 6;

/#27b.- Intentad borrar todo lo relacionado con el Proveedor numero 2
/#		(lo normal es que NO seáis capaces de conseguirlo por el momento)

	SET SQL_SAFE_UPDATES = 0;

	DELETE FROM remesas
	WHERE numped IN (select numped
				from pedidos as p
				where codprov = 2);

	DELETE FROM pedidos
	WHERE codprov = 2;

	DELETE FROM PROVEEDORES
	WHERE codprov = 2;


/#28.- Realizar las operaciones pertinentes para borrar el pedido numero 5. 

	DELETE FROM PEDIDOS
	WHERE NUMPED = 5;


/#29.- Realizar las operaciones pertinentes para cambiar el codigo del 
/#	   proveedor FERSA al 110(NOTA: esto se debe hacer
/#	   sin conocer el código del proveedor FERSA). 

UPDATE PROVEEDORES
SET CODPROV = 100
WHERE NOMBRE = "FERSA";		

/#23.- Seleccionar todos los pedidos de enero y abril (con importes)  
/#	   del proveedor FERSA con los siguientes datos(ordenados por fecha y numero pedido):
/#	   fecha pedido, numero pedido, codigo pieza, nombre pieza, precio, cantidad, 
/#	   importe(campo calculado)

	select distinct pd.fechap, pd.numped, pz.codpieza, pz.nompieza, pz.precio, rm.ctd, (rm.ctd*pz.precio)
    from proveedores as pr
    inner join pedidos as pd
    on pd.codprov = pr.codprov 
    inner join remesas as rm
    on rm.numped = pd.numped
    inner join piezas as pz
    on rm.codpieza = pz.codpieza
    where pd.fechap between "2021/01/01" and "2021/04/30"
    and 
    pr.nombre ="FERSA"
    order by pd.fechap, pd.numped;
    


/#20.- Seleccionar todas las piezas suministradas durante el mes de 
/#enero(BETWEEN)  y con un importe superior a 1000, con los siguientes datos:
/#codigo pieza, nombre pieza, fecha pedido, precio, cantidad, importe

	select  pz.codpieza, pz.nompieza, pd.fechap, pz.precio, rm.ctd, (rm.ctd*pz.precio)
    from piezas as pz 
	inner join remesas as rm
    on rm.codpieza = pz.codpieza
    inner join pedidos as pd
    on pd.numped = rm.numped
	where pd.fechap between "2021/01/01" and "2021/01/31"
    and
    ((rm.ctd*pz.precio)>1000)
	order by pz.codpieza
    ;


/#SUM(expresion)	AVG(expresion)	MIN(expresion)	MAX(expresion)  
/#COUNT(expresion) | COUNT(*) | COUNT(DISTINCT expresion)


/#30.- Obtener el número de proveedores que tenemos.

	select count(pr.codprov) as numProv
		from proveedores as pr;

/#31.- Obtener el número de piezas que tenemos.

	select count(pz.codpieza) as numPiezas
		from piezas as pz;

/#31.BIS.- Obtener el número de tipos de piezas
	
    select count( distinct pz.nompieza) as tipoPieza
		from piezas as pz;
	
    
/#32.-  Obtener el numero de poblaciones.

	select count(pr.poblacion) as numPoblaciones
		from proveedores as pr;
    
/#32.BIS.- Obtener el número de poblaciones distintas

	select count(distinct pr.poblacion) as numPob
		from proveedores as pr;

/#33.- Obtener el número de pedidos realizados hasta el momento.

	select count(pd.numped) as numPed
		from pedidos as pd;

/#34.- Obtener el valor total del stock de piezas.

	select sum(pz.precio*pz.existencias) as valorStck
		from piezas as pz;

/#35.- Obtener el importe total de todas las remesas realizadas hasta el momento.

	select sum(pz.precio*rm.ctd) as importRM
		from remesas as rm
		inner join piezas as pz
		on pz.codpieza = rm.codpieza;
    
/#36.- Obtener el valor total de las remesas de tuercas.
	
    select sum(pz.precio*rm.ctd) as importRM
		from remesas as rm
		inner join piezas as pz
		on pz.codpieza = rm.codpieza
		where pz.nompieza ="tuerca";
    
/#37.- Obtener el importe total de los pedidos de Marzo.
	
    select sum(rm.ctd*pz.precio) as importePedMarzo
       from remesas as rm
	   inner join piezas as pz
	   on pz.codpieza = rm.codpieza
       inner join pedidos as pd
       on pd.NUMPED = rm.numped
       where pd.fechap between "2021/03/01" and "2021/03/30";
       
/#38.- Obtener el importe total de las remesas del proveedor TARSA.
/#       Obtener también: 
/#		 38a.- pesomin-pieza, 
/#		 38b.- preciomedio-piezas, 
/#		 38c.- exist-min_piezas, 
/#		 38d.- importe-remesa-max, 
/#		 38e.- precio-max-pieza

	select 
    sum(rm.ctd*pz.precio) as importeTarsa,
    min(pz.peso) as pesoMin,
    avg(pz.precio) as precioMedio,
    min(pz.existencias) as existenciasMin,
	max(rm.ctd*pz.precio) as importeMax,
    max(pz.precio) as precioMax
       from remesas as rm
	   inner join piezas as pz
	   on pz.codpieza = rm.codpieza
	   inner join pedidos as pd
       on pd.numped = rm.numped
       inner join proveedores as pr
       on pr.codprov = pd.codprov
       where pr.nombre="tarsa";  


/#Ejercicios con patrones(operador de patrón LIKE y REGEXP)

/#39.- Seleccionar el código y el nombre de los proveedores que empiecen por FE.
	
    select pr.codprov, pr.nombre
		from proveedores as pr
		where pr.nombre like "FE%"
		order by pr.codprov;

/#40.- Seleccionar el nombre de las piezas que contengan la N (sin duplicidad).
	
    select distinct pz.nompieza 
		from piezas as pz
        where pz.nompieza like "%N%";

/#41.- Seleccionar el codigo y el nombre de aquellos proveedores que contengan SA
	
    select pr.codprov, pr.nombre
		from proveedores as pr
		where pr.nombre like"%SA%"
        order by pr.codprov;
        
/#42.-  Seleccionar el nombre de las piezas cuya sexta letra coincida con la L
/#		(sin duplicidad)

	select distinct pz.nompieza
		from piezas as pz
		where pz.nompieza like "%______L%"; 
        
/#GROUP BY


/#43.- Obtener el precio medio de cada tipo ó nombre de pieza.

	select pz.nompieza ,avg(pz.precio) as precioMedio
		from piezas as pz
		group by pz.nompieza;
    
/#44.- Obtener el stock total por tipo ó nombre de pieza
/#     (nombre pieza, stocktotal) ordenados por stock
	
    select pz.nompieza, sum(pz.existencias) as stock
		from piezas as pz
        group by pz.nompieza
        order by pz.existencias;

/#45.- Obtener el codigo pieza, nombre pieza y cantidad total de las piezas 
/#	   suministradas.

	select pz.codpieza, pz.nompieza, sum(rm.ctd) as cantidadTotal
		from piezas as pz
        inner join remesas as rm
        on rm.codpieza = pz.codpieza
        group by pz.codpieza
        order by cantidadTotal desc;
        
/#46.- Obtener el número de pedidos de cada proveedor
/#	 (codigo proveedor, nombre proveedor, totalpedidos).
	
    select pr.codprov, pr.nombre, count(pd.numped)
		from proveedores as pr
        inner join pedidos as pd
        on pd.codprov = pr.codprov
        group by pr.codprov
        order by pd.numped;
	
/#47.- Obtener el IMPORTE de cada pedido con los siguientes datos
/#	(ordenados por fecha pedido):
/#	fechap, numped, codprov, nombre proveedor, IMPORTE_PEDIDO

	select pd.fechap, pd.numped, pr.codprov, pr.nombre, sum(pz.precio*rm.ctd) as valorPedido
		from pedidos as pd
        inner join proveedores as pr
        on pd.codprov = pr.codprov
        inner join remesas as rm
        on rm.numped = pd.numped
        inner join piezas as pz
        on pz.codpieza = rm.codpieza
        group by pd.numped
        order by pd.fechap;
        

/#48.- Obtener la remesa de mayor valor de cada proveedor con los siguientes datos:
/#	   codigo proveedor,importe.

	select pr.codprov, max(pz.precio*rm.ctd)
		from pedidos as pd
        inner join proveedores as pr
        on pd.codprov = pr.codprov
        inner join remesas as rm
        on rm.numped = pd.numped
        inner join piezas as pz
        on pz.codpieza = rm.codpieza
        group by pr.codprov
        order by pr.codprov;   
        
/#Group By + Having

/#49.- Obtener Proveedores con más de 2 pedidos
/#	 (codigo proveedor, nombre prov, numeropedidos)

	select pr.codprov, pr.nombre, count(pd.numped)
		from proveedores as pr
		inner join pedidos as pd
        on pr.codprov = pd.codprov
        group by pr.codprov 
        having count(pd.numped)>2;

/#50.- Obtener los pedidos(numero pedido, fechap, cantidad)
/# 	   que excedan de 400 en cantidad total.

	select pd.numped, pd.fechap,sum(rm.ctd)
		from pedidos as pd
        inner join proveedores as pr
        on pr.codprov = pd.codprov 
        inner join remesas as rm
        on rm.numped = pd.numped
        group by pd.numped 
        having sum(rm.ctd)>400;
        
/#51.- Obtener los nombres de las piezas y existencias de aquellos tipos de piezas 
/#que no excedan de 100.
	
    select pz.nompieza, sum(pz.existencias) 
		from piezas as pz
        group by pz.nompieza
        having sum(pz.existencias)<=100;
        
/#52.- Obtener todos los datos de los proveedores  de aquellos
/#	 que nos hayan suministrado por un valor superior 
/#	 a 80000 €.
	
    select pr.codprov, pr.nombre, sum(rm.ctd*pz.precio) as totalImpProveedore
		from pedidos as pd
        inner join proveedores as pr
        on pr.codprov = pd.codprov 
        inner join remesas as rm
        on rm.numped = pd.numped
        inner join piezas as pz 
        on pz.codpieza = rm.codpieza
        group by pr.codprov 
        having sum(rm.ctd*pz.precio)>80000;
        
/#53.- Obtener los codigos, nombres de las piezas 
/#	 y existencias cuyas existencias representen más del 15% de la cantidad pedida.

	select pz.codpieza, pz.nompieza, pz.existencias
		from piezas as pz 
        inner join remesas as rm
        on rm.codpieza = pz.codpieza
        group by pz.codpieza 
        having (pz.existencias) > (sum(rm.ctd)*0.15);
        
/#54.- Obtener los pedidos cuyo importe supere las 50000 € con los siguientes datos:
/#		codprov, nombreprov, fechap, numped, importe     
/#        (ordenados por codprov, fechap, numped).

	select pr.codprov, pr.nombre, pd.fechap, pd.numped, sum(rm.ctd*pz.precio) as importe
		from proveedores as pr
        inner join pedidos as pd
        on  pd.codprov = pr.codprov
        inner join remesas as rm 
        on rm.numped = pd.numped
        inner join piezas as pz 
        on pz.codpieza = rm.codpieza
		group by pd.numped
        having sum(rm.ctd*pz.precio) >50000
        order by pr.codprov; 
        
/#SUBCONSULTAS

/#55.- Repetir los ejercicios 19,21,29 y 38 como subconsultas. 

/#19.- Obtener las remesas del proveedor FERSA con los siguientes datos: 
/#	   fecha pedido, numero pedido, codigo pieza, cantidad.     
/#	   (ordenados por la fecha del pedido)


SELECT  pd.fechap, pd.numped, pz.codpieza, rm.ctd 
	from remesas as rm
	inner join pedidos as pd
	on pd.numped = rm.numped
	inner join piezas as pz 
	on pz.CODPIEZA = rm.CODPIEZA
	where pd.codprov = (
	select  pr.codprov
	from proveedores  as pr
	where pr.nombre= "Fersa");

/#21.- Seleccionar las tuercas suministradas
/#     por los proveedores de MADRID y de ALCAZAR ordenados por población
/#	   y  numero pedido, 
/#	   con los siguientes datos:codigo proveedor, 
/#     nombre proveedor, poblacion, numero pedido, codigo pieza, cantidad. */
 
select pr.nombre, pr.poblacion, pd.numped, rm.codpieza, rm.ctd
	from proveedores as pr
	inner join pedidos as pd 
	on pd.codprov = pr.codprov
	inner join remesas as rm 
    on rm.numped = pd.numped
    where pr.codprov in(
		select pr.codprov
		from proveedores as pr
        where pr.poblacion = "alcazar" || pr.poblacion="madrid"
        )
     and rm.codpieza in(
		select pz.codpieza
        from piezas as pz
        where pz.nompieza="tuerca"
        )
        order by pr.poblacion, pd.numped;
    
/#38.- Obtener el importe total de las remesas del proveedor TARSA.
/#     Obtener también: 
/#	   38a.- pesomin-pieza, 

	select (pz.precio*rm.ctd) as importe, min(pz.peso)
		from piezas as pz
        inner join remesas as rm
        on rm.codpieza = pz.codpieza 
        inner join pedidos as pd 
        on pd.numped = rm.numped
        where pd.codprov in (
			select pr.codprov 
			from proveedores as pr
            where pr.nombre="tarsa");


/#56.- Obtener el codigo pieza, nombre pieza  y 
/#	   precio de menor valor(cotejar con la 38e).

	select pz.codpieza, pz.nompieza, pz.precio
		from piezas as pz 
        where pz.precio =(
        select min(pz.precio) 
        from piezas as pz);
		

/#57.- Obtener el codigo pieza, nombre pieza  y  peso de mayor peso.

	select pz.codpieza, pz.nompieza, pz.peso
		from piezas as pz 
        where pz.peso=(	
			select max(pz.peso)
				from piezas as pz);
/#58.- Obtener el codigo pedido, fechapedido, codproveedor, nombre proveedor e
/#	   importe del pedido de mayor valor.

	select pd.numped, pd.fechap, pr.codprov, pr.nombre, sum(rm.ctd*pz.precio) as importeMax
		from pedidos as pd 
        inner join proveedores as pr
        on pr.codprov = pd.codprov 
        inner join remesas as rm 
        on rm.numped = pd.numped
        inner join piezas as pz
        on pz.codpieza = rm.codpieza
		group by pd.numped
			having importeMax>= all(
				select sum(rm.ctd*pz.precio)
					from piezas as pz
                    inner join remesas as rm
					on rm.codpieza = pz.codpieza
                    inner join pedidos as pd
                    on pd.numped = rm.numped
                    group by pd.numped
                    );
      
	
/#59.-  Obtener los nombre de las piezas
/#y 	su cantidad cuyas existencias representen más del 30% del stock de almacén, 
/#		ordenados por existencias de forma descendente.

	select pz.nompieza, sum(pz.existencias) as piezasSuperiores 
		from piezas as pz
        group by pz.nompieza
        having sum(pz.existencias) > (
			select sum(existencias)*0.30
				from piezas);

 
/#60.- Obtener los datos del proveedor(codprov,nombre) 
/#	   que más pedidos nos haya suministrado, junto con el número de pedidos.
	
    select  pr.codprov, pr.nombre, count(pd.numped) as maxPedidos 
		from proveedores as pr
        inner join pedidos as pd
        on pd.codprov = pr.codprov
		group by pd.codprov 
		limit 1;

/*61.- Obtener el pedido de mayor valor de cada proveedor con los siguientes datos:
codigo proveedor,numped,importe.*/

	select pr.codprov, pd.numped,sum(rm.ctd*pz.precio) as importe
		from proveedores as pr
		inner join pedidos as pd
		on pd.codprov = pr.codprov
		inner join remesas as rm
		on rm.numped = pd.numped
		inner join piezas as pz
		on pz.codpieza = rm.codpieza
		group by pd.numped 
		having importe >=all(select (rm.ctd*pz.precio)
						from proveedores as pr
						inner join pedidos as pd
							on pd.codprov = pr.codprov
							inner join remesas as rm
							on rm.numped = pd.numped
							inner join piezas as pz
							on pz.codpieza = rm.codpieza
							)
		order by pr.codprov; 

    
/#ACTUALIZACIONES

set FOREIGN_KEY_CHECKS=0;
set SQL_SAFE_UPDATES = 0;

/#62.- Sumarle 500 al código de las tuercas.

update piezas as pz 
	set  pz.codpieza = pz.codpieza+500
    where pz.nompieza ="tuerca";

/#63.- Realizar las operaciones pertinentes para borrar los pedidos de enero.

	SET SQL_SAFE_UPDATES = 0;

	delete from remesas
	where numped in (select numped
					from pedidos as pd
					where pd.fechap between "2021/01/01" and "2021/01/30");
                    
    delete from pedidos as pd
	where pd.fechap between "2021/01/01" and "2021/01/30";	
    
    
    
/#64.- Realizar las operaciones pertinentes para borrar el proveedor 2.

	SET SQL_SAFE_UPDATES = 0;


	delete from pedidos
	where codprov in (select codprov
					from proveedores as pr
					where pr.codprov=2);
                    
	delete from proveedores as pr
		where pr.codprov =2; 



/#65.- Analizar, especificar y detallar el proceso más óptimo a seguir debido a  un desfase en las remesas de tornillos.
/#	   (Por cada 10 unidades ha habido un desfase de 1 unidad.)

select pz.nompieza, (sum(rm.ctd))
	from piezas as pz
	inner join remesas as rm
	on rm.codpieza = pz.codpieza
    where pz.nompieza ="tornillo";

	update piezas as pz
    set pz.existencias = pz.existencias+(select sum(ctd)*0.1
										from remesas 
                                        where remesas.codpieza = pz.codpieza)
					where pz.nompieza ="Tornillo";                          
                                         
                                        
	update remesas, piezas 
		set ctd = ctd +(ctd * 0.1)
		where remesas.codpieza = piezas.nompieza
		and  nompieza="Tornillo";
        
/#PRACTICAS ADICIONALES:

/#66.- Obtener los importes de las remesas de cada Pieza: CODPIEZA, TIPOPIEZA, importe

	select pz.codpieza, pz.nompieza, sum(rm.ctd*pz.precio) as importe
    from piezas as pz
    inner join remesas as rm
    on rm.codpieza = pz.codpieza
    group by pz.codpieza;


/#67.- Obtener el importe de las remesas del tipo de pieza de mayor cuantia(valor): tipoPieza, Importemax
	
    select pz.nompieza, sum(rm.ctd*pz.precio) as importeMax
		from piezas as pz 
			inner join remesas as rm
			on rm.codpieza = pz.codpieza
			group by pz.nompieza
			having  sum(pz.PRECIO)>
					(select sum(pz.PRECIO)
					from piezas as pz)
			order by pz.precio desc
			limit 1;

/#68.- Obtener el importe del pedido de mayor cuantia de cada población:
/#	   POBLACION, CODPROV, NOMBREPROV, NOPEDIDO, FECHAP, MAYORIMPORTE


select pr.poblacion, pr.codprov, pr.nombre, pd.numped, pd.fechap, sum(pz.precio*rm.ctd) as importeMax 
	from proveedores as pr
    inner join pedidos as pd 
    on pd.codprov = pr.codprov 
    inner join remesas as rm
    on rm.numped = pd.numped 
    inner join piezas as pz
    on pz.codpieza = rm.codpieza
		group by pd.numped
        having importeMax >=all
								(select sum(piezas.precio*remesas.ctd)
								from piezas 
								inner join remesas 
								on remesas.codpieza = piezas.codpieza
								inner join pedidos 
								on pedidos.numped = remesas.numped
								inner join proveedores 
								on pedidos.codprov = proveedores.codprov    
								where pr.poblacion=proveedores.poblacion
								group by pedidos.numped);

	

								

#69.- Obtener los porcentajes de compra de cada pieza:
#	  CODPIEZA, NOMPIEZA, IMPORTE, %COMPRA

	select pz.codpieza, pz.nompieza,sum(pz.precio*rm.ctd)
								   ,sum(pz.precio*rm.ctd)/(select sum((piezas.precio*remesas.ctd)/100)
															from piezas
                                                            inner join remesas 
                                                            on  piezas.codpieza= remesas.codpieza 
                                                          ) as porcentaje
	from piezas as pz 
    inner join remesas as rm
    on rm.codpieza = pz.codpieza
    group by pz.codpieza ;     
    
#JOIN y sus modalidades: 

#NOTA: Se exige que salgan en estos ejercicios todos los proveedores,
# todas las piezas, etc, etc. Independientemente de que se les haya comprado o no:

#70.-  Obtener un listado con el codigo, 
#	   nombre de la pieza y cantidad  global suministrada.

	select pz.codpieza, pz.nompieza, sum(rm.ctd)
		from piezas as pz 
		inner join remesas as rm
        on rm.codpieza = pz.codpieza
        group by pz.CODPIEZA
        order by pz.codpieza;
		
        
        
#71.- Obtener el importe de cada pedido:  NUMPED, FECHAP, IMPORTE
	
    select pd.numped, pd.fechap, sum(rm.ctd*pz.precio) as importe
		from pedidos as pd 
        left join remesas as rm
        on rm.numped = pd.numped
        inner join piezas as pz
        on pz.codpieza = rm.codpieza
        group by pd.numped;

#72.- Obtener el número de pedidos de cada proveedor(codigoproveedor, nombreproveedor, totalpedidos).
	
    select pr.codprov, pr.nombre, sum(pd.numped) as totalPedidos
		from proveedores as pr
			left join pedidos as pd 
            on pd.codprov = pr.codprov
            group by pr.codprov;
            

#73.-  Obtener el importe de las remesas de cada proveedor: CODPROV, NOMBRE, POBLACION, IMPORTE

	select pr.codprov, pr.nombre, pr.poblacion, (pz.precio*rm.ctd) as importe
		from proveedores as prpedidos
        inner join piezas as pz;
        
	
#74.- Obtener los porcentajes de compra de cada pieza:
#	  CODPIEZA, NOMPIEZA, CANTIDAD, IMPORTE, %COMPRA

	select pz.codpieza, pz.nompieza,rm.ctd,sum(pz.precio*rm.ctd)
								   ,sum(pz.precio*rm.ctd)/(select sum((piezas.precio*remesas.ctd)/100)
															from piezas
                                                            inner join remesas 
                                                            on remesas.codpieza = piezas.codpieza
                                                          ) as porcentaje
	from piezas as pz 
    inner join remesas as rm
    on rm.codpieza = pz.codpieza
    group by pz.codpieza ;
    
    
    
    
            
        
