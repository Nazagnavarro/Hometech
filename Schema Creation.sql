CREATE SCHEMA tienda; ## Creacion del Schema a utilizar 

-- Para este proyecto de una tienda de ventas, la información a utilizar sera del primer semestre del 2024

-- Creación de la tabla principal 'orders' las cual tiene 6 columnas y order_id sera su Primary Key 
CREATE TABLE tienda.orders (

order_id INT PRIMARY KEY, ## primary key
order_type VARCHAR (20), ## La orden puede ser Online / En Tienda
customer_id INT, ## foreign key - Cliente que hizo la compra
product_id INT, ## Foreign key to product table - ID del producto
seller_id INT , ## Foreign key to seller table  - ID del vendedor 
order_time TIMESTAMP, ## Horario en el que se hizo la venta. Las ordenes corresponden al primer semestre del 2024
quantity_purchased INT, ## Cantidad de Items comprados 
total_price DECIMAL (10,2),## Precio Total de la orden (Quantity_purchased * products.unitprice)
payment_type VARCHAR (30), ## Medio de pago elegido (Tarjeta de Debito - Paypal - Efectivo)
delivery_type VARCHAR (30), ## La entrega se hizo a través de envio o se retiró en tienda. 

);
-- Creación de la tabla de products la cual contiene la información de los productos que se venden en la tienda así como las categorías
CREATE TABLE tienda.products (

product_id INT PRIMARY KEY, ## primary key
product_category VARCHAR (30),
product_name VARCHAR (40),
unit_price DECIMAL (5,2),
supplier_price DECIMAL (5,2),
revenue DECIMAL (5,2)
);

-- Creación de la tabla customers la cual tiene la información de registro de los clientes 
CREATE TABLE tienda.customers (
customer_id INT PRIMARY KEY, ## Primary Key
customer_name VARCHAR(80), 
gender VARCHAR(12),
age INT,
address VARCHAR(60),
city VARCHAR (30),
state VARCHAR (30),
postal_code INT
);

-- Creación de la tabla sellers la cual contiene la información del vendedor que realizo la venta
CREATE TABLE tienda.sellers (

seller_id INT PRIMARY KEY, ## primary key
seller_name VARCHAR (60)

);
-- Asignación de las Foreign Keys para relacionar las tablas entre sí. 
ALTER TABLE tienda.orders
ADD FOREIGN KEY (customer_id)references customers(customer_id),
ADD FOREIGN KEY (seller_id) references sellers(seller_id),
ADD FOREIGN KEY (product_id) references products(product_id)

;

-- Utilizando un JOIN relacionamos el precio unitario de cada uno de los productos en la tabla product_id para configurar el valor total de la orden.
UPDATE tienda.orders AS  o
JOIN tienda.products AS  p ON o.product_id = p.product_id
SET o.total_price = p.unit_price * o.quantity_purchased;


;
-- Creamos un trigger que cada vez que se actualice la tabla orders se corra el codigo que crea el valor total de la orden.
USE tienda;
DELIMITER //

CREATE TRIGGER calculate_total_price
BEFORE INSERT ON tienda.orders
FOR EACH ROW
BEGIN
    DECLARE unit_price DECIMAL(10, 2);

    -- Obtener el unit_price del producto
    SELECT p.unit_price INTO unit_price
    FROM tienda.products p
    WHERE p.product_id = NEW.product_id;

    -- Calcular el total_price
    SET NEW.total_price = unit_price * NEW.quantity_purchased;
END //

DELIMITER ;
