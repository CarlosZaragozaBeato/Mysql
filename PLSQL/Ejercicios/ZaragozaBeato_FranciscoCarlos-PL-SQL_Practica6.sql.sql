

SET FOREIGN_KEY_CHECKS=0;
SET SQL_SAFE_UPDATES = 0;

/*1.	Diseña una VISTA(GAMAS_PRODUCTOS) con los siguientes datos:
IDCATEGORIA, NOMBRECATEGORIA, CANTIDADVENDIDA, IMPORTEPEDIDOS, PORC_PEDIDOS(en base al importe y 0 decimal)
Ordenados por importe de mayor a menor.*/


	CREATE OR REPLACE VIEW GAMA_PRODUCTOS AS
    select categorias.IdCategoria, categorias.nombreCategoria, sum(lineaspedido.cantidad), sum(lineaspedido.cantidad*lineaspedido.precioUnidad), format(sum(lineaspedido.cantidad*lineaspedido.precioUnidad)/(select sum(lineaspedido.cantidad*lineaspedido.precioUnidad)/100
																																																	from lineaspedido),2)
			from categorias
            inner join productos on productos.IdCategoria = categorias.IdCategoria
            inner join lineaspedido on lineaspedido.IdProducto = productos.IdProducto
			group by categorias.IdCategoria
            order by sum(lineaspedido.cantidad*lineaspedido.precioUnidad) desc
            ;
            
select * from GAMA_PRODUCTOS;
                                                                                                                                                                                                    


/*2.	Diseña  ahora una VISTA (EMPLEADOS-JEFE) de tal forma que nos salgan todos los empleados 
y su jefe con los siguientes datos(NOTA: En esta vista deben salir TODOS los empleados (los 9 empleados)):   
DATOSdelEMPLEADO(código, nombre, apellidos,cargo) y DATOSdelJEFE(código, nombre, apellidos,cargo)
Ordenados por jefe y empleados*/

	CREATE OR REPLACE VIEW EMPLEADOSJEFE AS
		select emp.idempleado as idEmpleado,emp.nombre as nombreEmpleado,emp.Apellidos as apellidosEmpleado, emp.cargo as cargoEmpleado, jf.idempleado as idJefe, jf.nombre as nombreJefe,jf.Apellidos as apellidosJefe ,jf.cargo as cargoJefe
			from empleados as jf
            right join empleados as emp on emp.jefe = jf.idempleado
			group by emp.idempleado
            order by jf.idempleado, emp.idempleado desc;
            
	select * from EMPLEADOSJEFE;


/*3.	AÑADE  desde el WorkBench el atributo IMPORTE a la tabla PEDIDOS. 
 Crea un procedimiento (CALCULARIMPORTEPEDIDOS) que se encargue de calcular y almacenar el importe para cada pedido. */

drop procedure if exists CALCULARIMPORTEPEDIDOS;
 delimiter $$ 
	create procedure CALCULARIMPORTEPEDIDOS()
		begin
        
				declare final int default 0;
                declare importePedido,codigoPedido int;
				declare cursorImporte cursor for 
                   select sum(lineaspedido.cantidad*lineaspedido.precioUnidad), lineaspedido.IdPedido
					from lineaspedido
                    group by lineaspedido.IdPedido;
                      
			declare continue handler for not found set final =1;
                    open cursorImporte;
						while final = 0 do
							fetch cursorImporte into importePedido, codigoPedido;
								update pedidos 
									set importe = importePedido
								where pedidos.idPedido = codigoPedido;
						end while;
                        close cursorImporte;
                                        
        end
 $$
 call CALCULARIMPORTEPEDIDOS;
 
/*4.	AÑADE  desde el WorkBench los siguientes atributos a la
 tabla empleados:  IMPORTEVENTAS, IMPORTECOMISION.  Crea un procedimiento (CALCULARDATOSEMPLEADOS) 
 que se encargue de calcular y almacenar esos datos para cada empleado, suponiendo una comisión del 10%. */
 
 drop procedure if exists CALCULARDATOSEMPLEADOS;
	delimiter $$
		create procedure CALCULARDATOSEMPLEADOS()
			begin 
				declare final int default 0;
                declare importeEmpleado,codigoEmpleado,comisionEmpleado int;
				declare cursorImporte cursor for 
                   select sum(lineaspedido.cantidad*lineaspedido.precioUnidad), empleados.IdEmpleado, (sum(lineaspedido.cantidad*lineaspedido.precioUnidad)*0.1) 
					from lineaspedido
                    inner join  pedidos on pedidos.IdPedido = lineaspedido.IdPedido
                    inner join empleados on empleados.IdEmpleado = pedidos.IdEmpleado
                    group by empleados.IdEmpleado;
                      
			declare continue handler for not found set final =1;
                    open cursorImporte;
						while final = 0 do
							fetch cursorImporte into importeEmpleado, codigoEmpleado,comisionEmpleado;
								
                                update empleados 
									set IMPORTEVENTAS = importeEmpleado
								where empleados.IdEmpleado = codigoEmpleado;
								
                                update empleados 
									set IMPORTECOMISION = comisionEmpleado
								where empleados.IdEmpleado = codigoEmpleado;
						end while;
                        close cursorImporte;
            end
    $$
    
    call CALCULARDATOSEMPLEADOS;

/*5.	AÑADE  desde el WorkBench los siguientes atributos a la tabla CATEGORIAS:  CANTIDADVENDIDA e IMPORTEPEDIDOS.  
Crea un procedimiento (CALCULARDATOSGAMAS) que se encargue de calcular y almacenar esos datos*/


drop procedure if exists CALCULARDATOSGAMAS;
delimiter $$
	create procedure CALCULARDATOSGAMAS()
		begin
				declare final int default 0;
                declare ctdVendida,codigoCategoria,importePedido int;
				declare cursorImporte cursor for 
                   select sum(lineaspedido.cantidad*lineaspedido.precioUnidad), categorias.IdCategoria, (sum(lineaspedido.cantidad))
					from lineaspedido
						inner join productos on productos.IdProducto = lineaspedido.IdProducto
                        inner join categorias on categorias.IdCategoria = productos.IdCategoria
                    group by categorias.IdCategoria;
                      
			declare continue handler for not found set final =1;
                    open cursorImporte;
						while final = 0 do
							fetch cursorImporte into importePedido, codigoCategoria,ctdVendida;
								
                                update categorias 
									set IMPORTEPEDIDOS = importePedido
								where categorias.IdCategoria = codigoCategoria;
								
                               update categorias 
									set CANTIDADVENDIDA = ctdVendida
								where categorias.IdCategoria = codigoCategoria;
						end while;
                        close cursorImporte;
		end
$$
call CALCULARDATOSGAMAS();

/*6.	Crea una función(FUNCION1) de forma que cuando se le invoque con el código de 
un determinado producto nos devuelva la cantidadvendida y su importe correspondiente*/

drop function if exists FUNCION1;
	delimiter $$
		create function FUNCION1(codigo int )returns varchar(200)
			deterministic
				begin 
						declare ctdVendida,importe int;
                        
                        set ctdVendida = (select sum(lineaspedido.cantidad)
													from lineaspedido
                                                    inner join productos on productos.IdProducto=lineaspedido.IdProducto
                                                    where codigo = productos.IdProducto);
                                                    
                        set importe =  (select sum(lineaspedido.cantidad+lineaspedido.PrecioUnidad)
													from lineaspedido
                                                    inner join productos on productos.IdProducto=lineaspedido.IdProducto
                                                    where codigo = productos.IdProducto);
                                                    
						return concat("La cantidad vendida es ",ctdVendida," ,y su importe es ",importe );
                        
                end
                
    
    $$
    
select FUNCION1(1);
/*7.	Crea una función(FUNCION2) de forma que cuando se le invoque con el código de un determinado producto 
nos devuelva la posición que ocupa en el ranking de ventas(en base al importe)*/

drop function if exists FUNCION2;
	delimiter $$
		create function FUNCION2(id int)returns varchar(200)
			deterministic
				begin
			declare posicion int;
                    
            drop temporary table if exists rankingTemporal;
			CREATE TEMPORARY TABLE rankingTemporal(
					codigoAuto int auto_increment not null unique,
					codigo int,
                    importe int,
                    primary key(codigoAuto));
                    
            insert into rankingTemporal (codigo,importe)
				select lineaspedido.IdProducto, sum(lineaspedido.cantidad*lineaspedido.PrecioUnidad)
					from lineaspedido
					group by lineaspedido.IdProducto
                    order by sum(lineaspedido.cantidad*lineaspedido.PrecioUnidad) desc;
                
                
                set posicion = (select codigoAuto
								from rankingTemporal 
                                where codigo = id);
			
                return posicion;
                end
	$$
    
    select FUNCION2(1) 
    
/*8.	Crea una función(FUNCION3) de forma que cuando se le invoque con el código de un cliente nos devuelva lo
 siguiente: numerodepedidos, importepedidos y la posición que ocupa en el ranking de ventas(en base al importe).*/
drop function if exists FUNCION3;
	delimiter $$
		create function FUNCION3(codigoCliente varchar(100))returns varchar(300)
        deterministic
			begin 
				declare numeroPedidos,codigoProducto,importePedidos,posicion int;
		
                set numeroPedidos = (select sum(pedidos.idPedido)
											from pedidos 
                                            where pedidos.IdCliente = codigoCliente);
                                            
				set importePedidos = (select sum(lineaspedido.PrecioUnidad+lineaspedido.cantidad)
										from pedidos 
                                        inner join lineaspedido on lineaspedido.IdPedido = pedidos.IdPedido
									where pedidos.IdCliente = codigoCliente);
                                    
				set posicion = (select rankingClientes(codigoCliente));


                
                return concat("El total de numero de pedidos es ",numeroPedidos," su importe total es ",importePedidos," y la posicion del ranking es ",posicion);
            end
    $$
select 	FUNCION3("QUICK");



drop function if exists rankingClientes;
	delimiter $$
		create function rankingClientes(codigo varchar(100))returns varchar(200)
        deterministic
			begin
            declare posicion int;
             drop temporary table if exists rankingTemporalClientes;
			CREATE TEMPORARY TABLE rankingTemporalClientes(
					codigoAuto int auto_increment not null unique,
					codigoCliente varchar(200),
                    importe int,
                    primary key(codigoAuto));
                    
            insert into rankingTemporalClientes (codigoCliente,importe)
				select pedidos.IdCliente, sum(lineaspedido.cantidad*lineaspedido.PrecioUnidad)
					from lineaspedido
                    inner join pedidos on lineaspedido.IdPedido = pedidos.idPedido
                    group by pedidos.IdCliente
                    order by sum(lineaspedido.cantidad*lineaspedido.PrecioUnidad) desc;
                    
			set posicion = (select codigoAuto
								from rankingTemporalClientes 
                                where codigoCliente = codigo);
			
                return posicion;
            end	
           $$ 
/*9.	Crea un trigger llamado DISPARADOR1 de forma que a la hora de introducir un nuevo pedido se encargue 
 de: almacenar el IMPORTE en la tabla pedidos y actualizar los atributos CANTIDADVENDIDA  e IMPORTEPEDIDOS en la tabla
 CATEGORIAS(debiendo adicionar y NO recalcular).*/
 
drop trigger if existS DISPARADOR1;
DELIMITER $$
create trigger DISPARADOR1 before insert
on lineaspedido for each row
	begin


            
			update pedidos
			set importe = (new.cantidad*new.PrecioUnidad) 
            where idPedido = new.idPedido;
            
            
            update categorias
            set IMPORTEPEDIDOS =(new.cantidad*new.PrecioUnidad)+IMPORTEPEDIDOS
            where  IdCategoria = (select productos.IdCategoria	
									from pedidos
                                    inner join lineaspedido on lineaspedido.IdPedido = pedidos.IdPedido
                                    inner join productos on productos.IdProducto = lineaspedido.IdProducto
									where pedidos.IdPedido = new.IdPedido);
			
            
            update categorias
            set CANTIDADVENDIDA = new.cantidad+CANTIDADVENDIDA
            where  IdCategoria = (select productos.IdCategoria	
									from pedidos
                                    inner join lineaspedido on lineaspedido.IdPedido = pedidos.IdPedido
                                    inner join productos on productos.IdProducto = lineaspedido.IdProducto
									where pedidos.IdPedido = new.IdPedido);
    end
$$



/*10.	AÑADE desde el Workbench el atributo IMPORTELINEA en la tabla LINEASPEDIDO. Crea un trigger 
llamado DISPARADOR2 de forma que a la hora de introducir un nuevo pedido se encargue de:  almacenar el IMPORTE en la tabla 
pedidos, almacenar el PRECIOUNIDAD en LINEASPEDIDO  y calcular y almacenar  automáticamente el  IMPORTELINEA.*/


drop trigger if existS DISPARADOR2;
DELIMITER $$
create trigger DISPARADOR2 before insert
on lineaspedido for each row
	begin	

	set new.precioUnidad = (select productos.PrecioUnidad
								from productos
                                where productos.IdProducto = new.IdProducto);


    set new.importeLinea = (new.PrecioUnidad*new.Cantidad);
 
        
	end














