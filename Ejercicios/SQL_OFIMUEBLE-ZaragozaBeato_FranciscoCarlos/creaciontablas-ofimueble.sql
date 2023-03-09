
create database OFIMUEBLE;

create table areas(
	codigo int not null unique,
	nombre varchar(10) not null  unique,
	primary key(codigo)
);

create table zonas(
	codigo int not null unique,
	nombre varchar(20) unique ,
	codarea  int not null ,
	primary key(codigo),
	foreign key(codarea) references areas(codigo)  
);

create table provincias(
	provincia varchar(20) not null unique,
    codzona int not null ,
    primary key(provincia),
    foreign key(codzona) references zonas(codigo) 
);
create table poblaciones(
	poblacion varchar(20) not null unique,
    provincia varchar(20) not null ,
    primary key (poblacion),
    foreign key (provincia) references provincias(provincia)
);

create table oficinas(
	codigo int not null unique,
    poblacion varchar(30) not null ,
    primary key(codigo),
    foreign key(poblacion) references poblaciones(poblacion) 
);

create table clientes(
	codigo int not null unique,
    nombre varchar(30),
    telef varchar(10),
    codofic int not null ,
    primary key(codigo),
    foreign key(codofic) references oficinas(codigo)
);

create table ventas(
	noventa int not null unique,
    fechav date ,
    codcli int not null ,
    primary key(noventa),
    foreign key(codcli) references clientes(codigo)
);

create table productos(
	codigo int not null unique,
    descripcion varchar(20),
    material varchar(10),
    dimensiones varchar(15),
    existencias int, 
    pvp int
);


create table lineasventa(
	noventa int not null ,
    codprod int not null ,
    ctd int, 
	primary key(noventa,codprod),
    unique(noventa, codprod),
    foreign key(noventa) references ventas(noventa),
	foreign key(codprod) references productos(codigo)
);

create unique index IND_AREAS on areas
	(nombre);
    
create unique index IND_ZONAS on zonas
	(nombre);

create index IND_CLIENTES on clientes
(nombre);

create index IND_DESCRIP on productos
(descripcion);





