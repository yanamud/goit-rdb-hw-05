use hw_3;

##### 1 #####
# Напишіть SQL запит, який буде відображати таблицю order_details та поле customer_id з таблиці orders

select *, (select customer_id from orders where id = order_details.order_id) as customer_id 
from order_details;

##### 2 #####
# Напишіть SQL запит, який буде відображати таблицю order_details. 
# Відфільтруйте результати так, щоб відповідний запис із таблиці orders виконував умову shipper_id=3.

select * from order_details
where (select shipper_id from orders where id = order_details.order_id) = 3;

##### 3 #####
# Напишіть SQL запит, вкладений в операторі FROM, який буде обирати рядки з умовою 
# quantity>10 з таблиці order_details. 
# Для отриманих даних знайдіть середнє значення поля quantity — групувати слід за order_id.

select tot.* from 
	(select order_details.* from order_details
		inner join 
		(select order_id, avg(quantity) as avg_quantity from order_details
			group by order_id 
			having avg_quantity > 10
            ) as av
		on order_details.order_id = av.order_id
		) as tot;
	
##### 4 #####
# Розв’яжіть завдання 3, використовуючи оператор WITH
with avg_quantity as(
	select order_details.*, avg_quantity from order_details
		inner join 
		(select order_id, avg(quantity) as avg_quantity from order_details
			group by order_id) as av
		on order_details.order_id = av.order_id
	)
select id, order_id, product_id, avg_quantity from avg_quantity
where avg_quantity > 10;

##### 5 #####
# Створіть функцію з двома параметрами, яка буде ділити перший параметр на другий. 
# Обидва параметри та значення, що повертається, повинні мати тип FLOAT.
# Використайте конструкцію DROP FUNCTION IF EXISTS. 
# Застосуйте функцію до атрибута quantity таблиці order_details . 
# Другим параметром може бути довільне число на ваш розсуд.

DROP FUNCTION IF EXISTS CalcDivision;
DELIMITER //

CREATE FUNCTION CalcDivision(number1 FLOAT, number2 FLOAT)
RETURNS FLOAT
DETERMINISTIC 
NO SQL
BEGIN
    DECLARE result FLOAT;
    SET result = number1 / number2;
    RETURN result;
END //
DELIMITER ;
SELECT * , CalcDivision(order_details.quantity, 3) as quantity_division from order_details