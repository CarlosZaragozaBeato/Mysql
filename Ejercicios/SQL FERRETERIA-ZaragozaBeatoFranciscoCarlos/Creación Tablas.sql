create database ferreteria;
use ferreteria;

create table proveedores(
	codprov int not null unique,
	nombre varchar(20) not null unique,
	poblacion varchar(20),
	primary key (codprov));

create table piezas(
	codpieza int not null unique, 
    nompieza varchar(30), 
    peso int,
    color varchar(20),
    existencias int, 
    precio int, 
    primary key(codpieza)); 

create table pedidos(
	numped int not null unique, 
    fechap date,
    codprov int not null,
    primary key(numped), 
    foreign key(codprov) references proveedores(codprov));

create table remesas( 
	numped int not null,
    codpieza int not null, 
    ctd int, 
    primary key (numped, codpieza),
    unique(numped, codpieza),
    foreign key(numped)references pedidos(numped), 
    foreign key(codpieza) references piezas(codpieza)
);

create index IND_PROV on proveedores(nombre);
create index IND_PIEZAS on piezas(nompieza);



