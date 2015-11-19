
--So multi-item call would resemble CALL trans((145, 'in process', 30, 'S18_1749', 136.0, 1),(145, 'in process', 50, 'S18_2248', 55.09, 2))	

	SET @custID = 142;
	START transaction;
	SET	@orderNum = (SELECT MAX(orderNumber)+1 FROM orders);
	INSERT INTO orders(orderNumber, orderDate, requiredDate, shippedDate, status, customerNumber) VALUES(@orderNum, now(), date_add(now(), INTERVAL 5 DAY), date_add(now(), INTERVAL 2 DAY), 'in process', '', @custID);	
	INSERT INTO orderdetails(orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber) VALUES(@orderNum, 'S18_1749', 30, 136, 1),(@orderNum, 'S18_2248', 50, 55.09, 2);
	COMMIT;


--2. YES!!!--CHECKED
DELIMITER |
CREATE PROCEDURE setRelocationFee(IN id int, OUT relocationFee varchar(10))
BEGIN
DECLARE cityName varchar(50);
DECLARE oCode varchar(11);
SELECT officeCode into oCode FROM employees where id = employeeNumber; 
SELECT city INTO cityName FROM offices where oCode = officeCode;

	IF (cityName = 'San Francisco') then set relocationFee = '$10000';
	elseif (cityName = 'Boston') then set relocationFee = '$8000';
	elseif (cityName = 'London') then set relocationFee = '$20000';
    else set relocationFee = '$15000';
    END IF;
END |
DELIMITER ; |

set	@employeeID	= 1501;
call setRelocationFee(@employeeID, @relocationfee);
select @employeeID, @relocationfee;

--3.--CHECKED! YES!
DELIMITER |
CREATE PROCEDURE changeCreditLimit(IN cust int, IN totpayment double)
BEGIN
DECLARE tableTotal double;
SET tableTotal = (SELECT SUM(amount) FROM payments WHERE customerNumber = cust);
IF (tableTotal >= totpayment) 
THEN UPDATE customers SET creditLimit = (creditLimit + 2000) WHERE customerNumber = cust; 
elseif (tableTotal < totpayment) 
THEN UPDATE customers SET creditLimit = (creditLimit) WHERE customerNumber = cust; 
END IF;
END |
DELIMITER ; |

set	@customer = 114;
set @totalpayment =	15000;
call changeCreditLimit(@customer,@totalpayment);

--4. 
DELIMITER |
CREATE PROCEDURE insertOdd()
BEGIN
    declare num int default 1;

    while num <= 3 do
    insert into odd(number) values(num);
    set num = num + 2;
  	end while;

  	set num = 7;
  	while num <= 13 do
    insert into odd(number) values(num);
    set num = num + 2;
  	end while;

  	set num = 17;
  	while num <= 20 do
    insert into odd(number) values(num);
    set num = num + 2;
  	end while;

    END |
   