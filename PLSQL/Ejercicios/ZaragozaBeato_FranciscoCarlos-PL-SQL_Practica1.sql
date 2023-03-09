

/*2.Diseñar una VISTA(PEDIDOS_2009) de los pedidos del año 2009 con los siguientes datos:
CODIGOPEDIDO, FECHAPED, ESTADO,CODCLI, NOMCLI, IMPORTEPEDIDO(en Euros y con 2 decimales)
Ordenados por cliente y pedido*/

	create or replace view PEDIDOS_2009 as
		select pedidos.codigoPedido, pedidos.FechaPedido, pedidos.estado, clientes.codigoCliente, clientes.nombreCliente, concat(format(sum(detallepedidos.cantidad*detallepedidos.precioUnidad),2),'$') as importePedido
			from pedidos 
				inner join clientes on pedidos.codigoCliente = clientes.codigoCliente
				inner join detallepedidos on pedidos.codigoPedido = detallepedidos.codigoPedido
				where year(pedidos.fechaPedido)=2009
				group by pedidos.codigoPedido
				order by clientes.codigoCliente, pedidos.codigoPedido;
	SELECT *
	FROM PEDIDOS_2009;

/*3.Diseñar una VISTA(PEDIDOS_PDTES) de los pedidos pendientes de entrega con los siguientes datos:
CODIGOPEDIDO, FECHAPED, CODCLI, NOMCLI, CP,CIUDAD, PAIS, CODOFICINA, CIUDADOFICINA, IMPORTEPEDIDO
Ordenados por PAIS, CIUDAD,CLIENTE*/

	create or replace view PEDIDOS_PDTES as
		 select pedidos.codigoPedido, pedidos.FechaPedido, clientes.codigoCliente, clientes.nombreCliente, clientes.codigoPostal, clientes.ciudad, clientes.pais,oficinas.codigoOficina,
			concat(format(sum(detallepedidos.cantidad*detallepedidos.precioUnidad),2),'$') as importePedido
				from pedidos
					inner join clientes on pedidos.codigoCliente = clientes.codigoCliente
					inner join detallepedidos on pedidos.codigoPedido = detallepedidos.codigoPedido
                    inner join empleados on empleados.CodigoEmpleado = clientes.CodigoEmpleadoRepVentas
                    inner join oficinas on oficinas.codigoOficina = empleados.codigoOficina
						where pedidos.estado ="Pendiente"
                        group by pedidos.codigoPedido
                        order by oficinas.pais, oficinas.ciudad, clientes.nombreCliente;
	 
     select * from PEDIDOS_PDTES;
     


/*4. Diseñar una VISTA(PEDIDOSCLIENTES) con el importe total de los pedidos de 
cada cliente con los siguientes datos(NOTA IMPORTANTE: en esta vista deben salir los 36 clientes¡¡):
CODCLI, NOMCLI, CP,CIUDAD, PAIS, IMPORTEPEDIDOS(en Euros y con 2 decimales)
Ordenados por PAIS,CIUDAD  e IMPORTE(de mayor a menor) */

	create or replace view PEDIDOSCLIENTES as
		select clientes.codigoCliente, clientes.nombreCliente, clientes.codigoPostal, clientes.ciudad, clientes.pais,concat(format(sum(detallepedidos.cantidad*detallepedidos.precioUnidad),2),'$') as importePedido
			from detallepedidos 
				inner join pedidos on pedidos.codigoPedido = detallepedidos.CodigoPedido
                right join clientes on clientes.codigoCliente = pedidos.CodigoCliente
                group by clientes.codigoCliente
                order by  clientes.pais, clientes.ciudad,sum(detallepedidos.cantidad*detallepedidos.precioUnidad); 
                
         select * from   PEDIDOSCLIENTES;     


/*5.	Diseñar una VISTA(MEJORCLIxOFICINA) con los siguientes datos,
 es decir de cada OFICINA debemos obtener el mejor cliente  del año 2009(en base al importe de sus pedidos):
CODIGOOFICINA,CIUDAD,PAIS, CODCLI,NOMCLI, IMPORTEPEDIDOS(en Euros y con 2 decimales)*/


	create or replace view MEJORCLIxOFICINA as 
		select oficinas.CodigoOficina, oficinas.ciudad, oficinas.pais, clientes.CodigoCliente, clientes.NombreCliente,concat(format(sum(detallepedidos.cantidad*detallepedidos.precioUnidad),2),'$') as importePedido
			from oficinas
				inner join empleados on empleados.CodigoOficina = oficinas.CodigoOficina
                inner join clientes on clientes.CodigoEmpleadoRepVentas = empleados.CodigoEmpleado
                inner join pedidos on pedidos.CodigoCliente = clientes.CodigoCliente
                inner join detallepedidos on detallepedidos.CodigoPedido = pedidos.CodigoPedido
                where year(pedidos.fechaPedido)=2009
					group by clientes.codigoCliente
						having sum(detallepedidos.cantidad*detallepedidos.precioUnidad) >= all(select sum(dp.cantidad*dp.precioUnidad)
																									from detallepedidos as dp
																										inner join pedidos as pd on pd.CodigoPedido=dp.CodigoPedido
                                                                                                        inner join clientes as cl on cl.CodigoCliente = pd.CodigoCliente
                                                                                                        inner join empleados as emp on emp.CodigoEmpleado = cl.CodigoEmpleadoRepVentas
                                                                                                        inner join oficinas as ofc on ofc.CodigoOficina = emp.CodigoOficina
                                                                                                        where ofc.CodigoOficina = oficinas.CodigoOficina
                                                                                                        and year(pd.fechaPedido) = 2009
                                                                                                        group by cl.CodigoCliente);
                                                                                                        
			select * from MEJORCLIxOFICINA;
            
            
            
            
            
/*6.	Diseñar una VISTA(RANKING_PRODUCTOS) con los siguientes datos(NOTA IMPORTANTE: en esta vista deben salir todos los productos,  los 276 productos¡¡):
ARTICULO(CODIGOPRODUCTO,GAMA,NOMBRE),CANTIDAD,IMPORTEPEDIDOS(en Euros y con 2 decimales), PORC_PEDIDOS(en base al importe, 0 decimales y con el símbolo %)
Ordenados por importe de mayor a menor.
*/

	create or replace view RANKING_PRODUCTOS as 
		select productos.CodigoProducto, productos.Gama, productos.Nombre, detallepedidos.Cantidad, concat(format(sum(detallepedidos.cantidad*detallepedidos.precioUnidad),2),'$') as importePedido, 
			concat(format(sum(detallepedidos.cantidad*detallepedidos.precioUnidad)/(select sum(detallepedidos.cantidad*detallepedidos.precioUnidad)/100
															from detallepedidos),2),"%")
						from productos 
							left join detallepedidos on detallepedidos.CodigoProducto = productos.CodigoProducto
                        
					group by productos.CodigoProducto
					order by sum(detallepedidos.cantidad*detallepedidos.precioUnidad) desc;
                            
		select * from RANKING_PRODUCTOS;

/*

NOTA: para las 2 siguientes prácticas os remito al libro de Garceta apartado 4.9.
7.	Diseñar una VISTA(VISTAJEFES) de tal forma que nos salgan los jefes y los empleados que tienen a su cargo con los siguientes datos:   
CODIGOOFICINA,PUESTO(del Jefe), CODIGOJEFE, NOMBREyAPELLIDOSdelJEFE,   CODIGOEMPLEADO, NOMBREyAPELLIDOS(del empleado y PUESTO (del empleado(s) a su cargo)        
Ordenados por jefe y empleado
*/

	create or replace view VISTAJEFES as
		select oficinas.CodigoOficina, jefes.CodigoJefe, concat(jefes.nombre," ",jefes.Apellido1," ",jefes.Apellido2),empleados.codigoEmpleado, concat(empleados.nombre," ",empleados.Apellido1," ",empleados.Apellido2),empleados.Puesto
			from oficinas
				inner join empleados on empleados.CodigoOficina = oficinas.CodigoOficina
				inner join empleados as jefes on jefes.CodigoEmpleado = empleados.CodigoJefe
                group by empleados.CodigoEmpleado
                order by jefes.CodigoJefe, empleados.CodigoEmpleado;
                
             select * from   VISTAJEFES;
			
        

/*
8.	Diseñar ahora una VISTA similar a la anterior(VISTAEMPLEADOS-JEFE) de tal forma que nos salgan los todos los empleados y su jefe con los siguientes datos:   
DATOSdelEMPLEADO(código, nombre, apellidos,puesto) y DATOSdelJEFE(código, nombre, apellidos,puesto)
Ordenados por jefe y empleados
 
*/   

create or replace view VISTAJEFES as
		select oficinas.CodigoOficina, jefes.CodigoJefe, concat(jefes.nombre," ",jefes.Apellido1," ",jefes.Apellido2),empleados.codigoEmpleado, concat(empleados.nombre," ",empleados.Apellido1," ",empleados.Apellido2),empleados.Puesto
			from oficinas
				inner join empleados on empleados.CodigoOficina = oficinas.CodigoOficina
				left join empleados as jefes on jefes.CodigoEmpleado = empleados.CodigoJefe
                group by empleados.CodigoEmpleado
                order by jefes.CodigoJefe, empleados.CodigoEmpleado;
                
             select * from   VISTAJEFES;
             
             
             
             
/*NOTA:  Para las prácticas de usuarios os remito también al libro de Garceta, apartados 5.13 y 5.14.
USUARIOS:*/

#9.	Realiza la PRÁCTICA 5.6 (página 225) del libro

#1. Crea un usuario llamado paco@localhost con la sintaxis create user con permisos de solo conexión y comprueba que se pueda conectar.

	create user  paco@localhost ;

#2. Crea un usuario llamado juan@localhost con la sintaxis grant con permisos de
#solo conexión y comprueba que se pueda conectar.
	create user juan@localhost;
 
    
#3. Otorga al usuario paco@localhost permisos de select en la tabla jardineria.Clientes
#y comprueba que se pueda consultar la tabla.
	
    grant select 
    on jardineria.clientes
    to paco@localhost;
	
#4. Otorga al usuario juan@localhost permisos de select, insert y update en las
#tablas de la base de datos jardineria con opcion GRANT.
	
    grant select, insert, update
    on jardineria.*
    to juan@localhost;

#5. Conéctate con el usuario juan y otorga permisos a paco de selección en la tabla
#jardineriaEmpleados.
	
grant select
on jardineria.empleados
to paco@localhost;


	
    
#6. Quítale ahora los permisos a paco de selección sobre la tabla jardineria.Clientes.
		
        revoke select 
		on jardineria.clientes
		from paco@localhost;
        
#7. Conéctate con root y elimina todos los permisos que has concedido a Paco y Juan.
	
    revoke all privileges
    on *.*
    from paco@localhost;
    
	revoke all privileges
    on *.*
    from juan@localhost;

/*8. Otorga a juan los permisos de SELECT sobre las columnas CodigoOcina y
Ciudad de la tabla Ocinas de la base de datos jardineria*/

	grant select(codigoOficina, ciudad) 
    on jardineria.oficinas
    to juan@localhost;
    
/*9. Conéctate con juan y ejecuta la query SELECT * from jardineriaOcinas
¿Qué sucede?.
*/
#select * from jardineria.oficinas; Da error porque no tiene privilegios
#10. Borra el usuario paco@localhost.

 drop user paco@localhost;

#10.	Realiza la PRÁCTICA 5.7 (página 226) del libro


#Crea un nuevo usuario llamado usuarioíldireccionip donde direccion_ip es una
#máquina de un compañero tuyo y usuario su nombre.



/*. Crea un nuevo usuario llamado usuario@direccionip donde direccion_ip es una
máquina de un compañero tuyo y usuario su nombre.*/

create  user david@192.168.1.249;

/*. Otórgale permisos de seleccion en todas las tablas de la base de datos jardineria.
Ten cuidado, es posible que tu servidor solo permita conexiones desde
el ordenador local, para permitir conexiones remotas debes comentar la linea
bind-adress de tu chero mycnf que impide conexiones desde otros sitios que
no sea el especificado(127.0.0.1). Asegúratede reiniciar el servidor.*/

grant select on jardineria.* TO david@192.168.1.249;

/*. Pide a tu compañero que se conectedesde sumáquina y que averigue qué permisos le has otorgado. 
El a tí te pedirá lo mismo, es decir, que te conectes a
su máquina, indica qué instrucción sql ejecutas para conocer los permisos que
tienes.*/

show grants;


/*. Revócale los permisos concedidos al usuario usuario@direccion_ip.*/
revoke all privileges on *.* from  david@192.168.1.249;

/*. Concédele ahora permisos de creación de tablas en una nueva base de datos
que has creado*/

grant create on *.* to david@192.168.1.249;

/*.Solicítale que se conecte y que pruebe a crear una tabla. ¿Puede consular la
informaciónï .*/

#No porque solo tiene derecho a crear, no a consultar.

/*7. Borra ahora el usuario usuario@direccion_ip.*/
drop user david@192.168.1.249;
    
/*Con la bbdd mysql consulta qué privilegios tiene el usuario juan@localhost
a nivel de servidor, a nivel de base de datos, a nivel de tablas y a nivel de
columnas. Utiliza el comando show grants for usuario.*/

show grants for juan@localhost;
