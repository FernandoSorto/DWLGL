USE master
GO

IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = N'DWLGL'
)
BEGIN
    ALTER DATABASE DWLGL SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE DWLGL
END

CREATE DATABASE DWLGL
GO

USE DWLGL
GO

CREATE TABLE [DimTiempo] (
	[tiempo_key] INT PRIMARY KEY,
	[fecha] DATETIME NOT NULL,
    [nombre_dia] VARCHAR(70) NOT NULL,
    [nombre_mes] VARCHAR(70) NOT NULL,
	[dia] TINYINT NOT NULL,
	[mes] TINYINT NOT NULL,
	[anio] SMALLINT NOT NULL
)
GO

CREATE TABLE [DimUbicacion] (
    [ubicacion_key] INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_dim_ubicacion PRIMARY KEY,
    [municipio_id] INT NOT NULL,
    [departamento_id] INT NOT NULL, 

    [codigo_iso_departamento] VARCHAR(6) NOT NULL,
    [nombre_municipio] VARCHAR(191) NOT NULL,
    [nombre_departamento] VARCHAR(191) NOT NULL,
    [nombre_completo_ubicacion] VARCHAR(400) NOT NULL
)
GO

CREATE TABLE [DimCliente] (
    [cliente_key] INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_dim_cliente PRIMARY KEY,
    [cliente_id] INT NOT NULL,

    [nombre_cliente] VARCHAR(191) NOT NULL,
    [created_at] DATETIME NULL
)
GO

CREATE TABLE [DimVendedor] (
    [vendedor_key] INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_dim_vendedor PRIMARY KEY,
    [vendedor_id] INT NOT NULL,

    [nombre_vendedor] VARCHAR(191) NOT NULL,
    [apellido_vendedor] VARCHAR(191) NOT NULL,
    [nombre_completo] VARCHAR(400) NOT NULL
)
GO

CREATE TABLE [DimProducto] (
    [producto_key] INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_dim_producto PRIMARY KEY,
    [producto_id] INT NOT NULL,

    [codigo] VARCHAR(50) NULL,
    [nombre] VARCHAR(191) NOT NULL,
    [categoria] VARCHAR(50) NOT NULL,
    [tipo] VARCHAR(50) NOT NULL,
    [costo] DECIMAL(8,2) NOT NULL,
    [producto_activo] BIT NOT NULL
)
GO

CREATE TABLE [FactVentas] (
    [id] INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_fact_ventas PRIMARY KEY,
    [venta_id] INT NOT NULL,
    
    [fecha_key] INT NOT NULL,
    [ubicacion_key] INT NOT NULL,
    [cliente_key] INT NOT NULL,
    [vendedor_key] INT NULL,
    [producto_key] INT NOT NULL,

    [venta_total] DECIMAL(12,4) NOT NULL,
    [venta_total_con_impuestos] DECIMAL(12,4) NULL,
    [suma] DECIMAL(12,4) NULL,
    [cantidad_productos] INT NOT NULL,
    
    CONSTRAINT fk_fact_ventas_dim_ubicacion FOREIGN KEY (ubicacion_key) REFERENCES DimUbicacion(ubicacion_key),
    CONSTRAINT fk_fact_ventas_dim_cliente FOREIGN KEY (cliente_key) REFERENCES DimCliente(cliente_key),
    CONSTRAINT fk_fact_ventas_dim_vendedor FOREIGN KEY (vendedor_key) REFERENCES DimVendedor(vendedor_key),
    CONSTRAINT fk_fact_ventas_dim_producto FOREIGN KEY (producto_key) REFERENCES DimProducto(producto_key),
    CONSTRAINT fk_fact_ventas_dim_tiempo FOREIGN KEY (fecha_key) REFERENCES DimTiempo(tiempo_key),
)
GO

CREATE INDEX IX_fact_ventas_fecha ON factVentas(fecha_key);
CREATE INDEX IX_fact_ventas_ubicacion ON factVentas(ubicacion_key);
CREATE INDEX IX_fact_ventas_cliente ON factVentas(cliente_key);
CREATE INDEX IX_fact_ventas_producto ON factVentas(producto_key);
CREATE INDEX IX_fact_ventas_venta_id ON factVentas(venta_id);