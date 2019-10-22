DELIMITER //
#1. Run this.
DROP PROCEDURE IF EXISTS min_max //
#2. Run this.
CREATE PROCEDURE min_max()
BEGIN
DECLARE ch_done INT DEFAULT 0;
DECLARE col_name VARCHAR(64);
DECLARE col_names CURSOR FOR
SELECT column_name
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE table_name = 'customer'
  ORDER BY ordinal_position;
  
  #DECLARE CONTINUE HANDLER FOR NOT FOUND SET ch_done = 1;

OPEN col_names;
SET @num_rows=0;
SET @i=0;
#SET @colname = col_name;

select FOUND_ROWS() into @num_rows;

the_loop: LOOP

   IF @i > @num_rows THEN
        CLOSE col_names;
        LEAVE the_loop;
    END IF;
    
    FETCH col_names 
    INTO col_name;   
    
    #Option 1
    #SET @A = CONCAT('Select CONCAT(MIN(', col_name, '), " -> " , MAX(', col_name, ')) as min_max from customer INTO OUTFILE \'C:\Users\myname\Documents\result.txt\' FIELDS ENCLOSED BY '"' TERMINATED BY ';' ESCAPED BY '"' LINES TERMINATED BY \'\r\n\'');
	
    #Option 2
    SET @A = CONCAT('Select CONCAT(MIN(', col_name, '), " -> " , MAX(', col_name, ')) as min_max from customer;');
	Prepare stmt FROM @A;
	EXECUTE stmt;

    SET @i = @i + 1;
END LOOP the_loop;
END 
//
DELIMITER ;

#3. Run this.
call min_max();
