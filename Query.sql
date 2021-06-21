USE `bengkel`;
drop table if exists tabel1;
create table tabel1
	(model varchar(20), berapa int);
drop table if exists carsold;
create table carsold
	(data char(100));

USE `bengkel`;
DROP procedure IF EXISTS `car_sold`;

DELIMITER $$
USE `bengkel`$$
CREATE PROCEDURE `car_sold`(in tahun varchar(5))
BEGIN
	
    declare customer INT;
    declare months varchar(15);
    declare monthCounter int default 1;
    declare carCounter INT DEFAULT 1;
    declare dayEachCounter int default 1;
	 declare minCustomer int default 0;
    declare i int default 1;
    
     DELETE FROM carsold;
     insert into carsold (data) values (concat('Each Month Customer transaction in ',tahun));
     
	-- LOOP HOW MANY CARS ARE SOLD EACH month
    while monthCounter<=12 do
		if monthCounter = 1
			then set @a = 'January';
		elseif monthCounter = 2
			then set @a = 'February';
		elseif monthCounter = 3
			then set @a = 'March';
		elseif monthCounter = 4
			then set @a = 'April';
		elseif monthCounter = 5
			then set @a = 'May';
		elseif monthCounter = 6
			then set @a = 'June';
		elseif monthCounter = 7
			then set @a = 'July';
		elseif monthCounter = 8
			then set @a = 'August';
		elseif monthCounter = 9
			then set @a = 'September';
		elseif monthCounter = 10
			then set @a = 'October';
		elseif monthCounter = 11
			then set @a = 'November';
		elseif monthCounter = 12
			then set @a = 'December';	
		end if;
    
	 set customer = (select count(carOrderID) 
	 		from carorder co 
			LEFT JOIN transaction tr 
			ON co.transactionID = tr.transactionID 
	 		WHERE(monthname(DATE) = @a and year(DATE) = '2018')GROUP BY MONTHNAME(DATE));
	 
	 if customer = NULL
	  then SET customer = 0;
	 END if;
	 insert into carsold (data) values(concat(@a, SPACE(20-CHAR_LENGTH(@a)) ,customer));
	 
    
       
    set monthCounter = monthCounter+1;
    end while;
    
    DELETE FROM tabel1;
	 
    insert into carsold (data) values ('');
    insert into carsold (data) VALUES('*********************************************************');
    insert into carsold (data) values ('');
    insert into carsold (data) values ('Per Month Detail Customer Transaction');
    insert into carsold (data) values ('');
    set monthCounter =1;
	
    -- LOOP FOR HOW MANY CUSTOMER IN EACH month Buys What
      while monthCounter<=12 do
		delete from tabel1;
		if monthCounter = 1
			then set @a = 'January';
		elseif monthCounter = 2
			then set @a = 'February';
		elseif monthCounter = 3
			then set @a = 'March';
		elseif monthCounter = 4
			then set @a = 'April';
		elseif monthCounter = 5
			then set @a = 'May';
		elseif monthCounter = 6
			then set @a = 'June';
		elseif monthCounter = 7
			then set @a = 'July';
		elseif monthCounter = 8
			then set @a = 'August';
		elseif monthCounter = 9
			then set @a = 'September';
		elseif monthCounter = 10
			then set @a = 'October';
		elseif monthCounter = 11
			then set @a = 'November';
		elseif monthCounter = 12
			then set @a = 'December';	
		end if;
		
		
		insert into carsold (data) values(@a);
         set i = 1;
			while i<=10 do
				set carCounter = i;
			if carCounter = 1
				then set @b = 'toyota';
			elseif carCounter = 2
				then set @b = 'honda';
			elseif carCounter = 3
				then set @b = 'mitsubishi';
			elseif carCounter = 4
				then set @b = 'daihatsu';
			elseif carCounter = 5
				then set @b = 'nissan';
			elseif carCounter = 6
				then set @b = 'kia';
			elseif carCounter = 7
				then set @b = 'suzuki';
			elseif carCounter = 8
				then set @b = 'wuling';
			elseif carCounter = 9
				then set @b = 'mazda';
			elseif carCounter = 10
				then set @b = 'ford';
			END if;
		    
				set customer = (select COUNT(carOrderID) 
						FROM carorder co 
						LEFT JOIN transaction tr ON co.transactionID = tr.transactionID 
						LEFT JOIN carlist cl ON co.carID = cl.carID 
						where (MONTHNAME(DATE) = @a AND brand = @b) GROUP BY brand);
				
				insert into tabel1 (model, berapa) values (@b, customer);
				insert into carsold (data) values (concat(@b, SPACE(20-CHAR_LENGTH(@b)) ,customer));	
				
				set i = i+ 1;
			 end while;
            
		insert into carsold (data) values ('');
		set minCustomer = (select min(berapa) from tabel1);
		INSERT INTO carsold (DATA) VALUES (CONCAT('Per Month Smallest',SPACE(2),minCustomer));
		insert into carsold (data) values ('');
		set monthCounter = monthCounter+1;
    end while;
    
    insert into carsold (data) VALUES('*********************************************************');
    insert into carsold (data) values ('');
    INSERT INTO carsold (DATA) VALUES (CONCAT('This Year Smallest', SPACE(2),minCustomer));
	 insert into carsold (data) VALUES ('');
    insert into carsold (data) values ('');
	 insert into carsold (data) values ('');
   
    select data as 'Laporan' from carsold;
END$$

DELIMITER ;

