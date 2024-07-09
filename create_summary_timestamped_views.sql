 drop procedure create_summary_timestamped_views;

DELIMITER //

CREATE PROCEDURE create_summary_timestamped_views(IN date_val DATE)
BEGIN
    DECLARE timestamp_str VARCHAR(20);
    DECLARE file_path VARCHAR(255);
    SET timestamp_str = DATE_FORMAT(DATE(date_val), '%m_%Y');
    SET file_path = 'C:\\\\ProgramData\\\\MySQL\\\\MySQL Server 8.0\\\\Uploads\\\\summary_data';

    -- Create dynamic SQL for dropping and creating timestamped tables with specific columns
    SET @drop_savings = CONCAT('DROP VIEW IF EXISTS savings_', timestamp_str, '; ');
    SET @savings = CONCAT('CREATE VIEW savings_', timestamp_str, ' AS ',
                          'SELECT account_number, account_name, account_type, account_open_date, initial_deposit ',
                          'FROM accounts WHERE DATE(account_open_date) BETWEEN DATE_SUB(''', date_val, ''', INTERVAL 1 MONTH) AND ''', date_val, ' '' ' , 
                     'AND account_type = ''Savings'';');
    
    SET @drop_checking = CONCAT('DROP VIEW IF EXISTS checking_', timestamp_str, '; ');
    SET @checking = CONCAT('CREATE VIEW checking_', timestamp_str, ' AS ',
                           'SELECT account_number, account_name, account_type, account_open_date, initial_deposit ',
                           'FROM accounts WHERE DATE(account_open_date) BETWEEN DATE_SUB(''', date_val, ''', INTERVAL 1 MONTH) AND ''', date_val, ' '' ' , 
                     'AND account_type = ''Checking'';');
    
    
    SET @drop_loan = CONCAT('DROP VIEW IF EXISTS loan_', timestamp_str, '; ');
    SET @loan = CONCAT('CREATE VIEW loan_', timestamp_str, ' AS ',
                       'SELECT account_number, account_name, account_type, account_open_date, initial_deposit ',
                      'FROM accounts WHERE DATE(account_open_date) BETWEEN DATE_SUB(''', date_val, ''', INTERVAL 1 MONTH) AND ''', date_val, ' '' ' , 
                     'AND account_type = ''Loan'';');
    
    SET @drop_credit = CONCAT('DROP VIEW IF EXISTS credit_', timestamp_str, '; ');
    SET @credit = CONCAT('CREATE VIEW credit_', timestamp_str, ' AS ',
                         'SELECT account_number, account_name, account_type, account_open_date , initial_deposit ',
                         'FROM accounts WHERE DATE(account_open_date) BETWEEN DATE_SUB(''', date_val, ''', INTERVAL 1 MONTH) AND ''', date_val, ' '' ' , 
                     'AND account_type = ''Credit'';');
                            
    -- Execute the dynamic SQL statements
    -- -- SAVINGS
    PREPARE stmt_savings FROM @drop_savings;
    EXECUTE stmt_savings;
    DEALLOCATE PREPARE stmt_savings;
    PREPARE stmt_savings FROM @savings;
    EXECUTE stmt_savings;
    DEALLOCATE PREPARE stmt_savings;
    
   
	-- CHECKINGS
	PREPARE stmt_checking FROM @drop_checking;
    EXECUTE stmt_checking;
    DEALLOCATE PREPARE stmt_checking;
    PREPARE stmt_checking FROM @checking;
    EXECUTE stmt_checking;
    DEALLOCATE PREPARE stmt_checking;
    
    -- LOAN
    PREPARE stmt_loan FROM @drop_loan;
    EXECUTE stmt_loan;
    DEALLOCATE PREPARE stmt_loan;
    
    PREPARE stmt_loan FROM @loan;
    EXECUTE stmt_loan;
    DEALLOCATE PREPARE stmt_loan;
    
    -- CREDIT
    PREPARE stmt_credit FROM @drop_credit;
    EXECUTE stmt_credit;
    DEALLOCATE PREPARE stmt_credit;
    
    PREPARE stmt_credit FROM @credit;
    EXECUTE stmt_credit;
    DEALLOCATE PREPARE stmt_credit;

    -- Delete all contents of the union_table
    TRUNCATE TABLE summary;

    -- Insert data into the union_table using UNION ALL
SET @summary_sql = CONCAT(
'INSERT INTO summary (account_type, count, total, average) ',
  'SELECT ', '  account_type, ', '  COUNT(*) AS count, ',
  '  SUM(initial_deposit) AS total, ', '  AVG(initial_deposit) AS average ',
  'FROM ( ',
  '  SELECT account_type, initial_deposit FROM savings_', timestamp_str,
  '  UNION ALL ',
  '  SELECT account_type, initial_deposit FROM checking_', timestamp_str,
  '  UNION ALL ',
  '  SELECT account_type, initial_deposit FROM loan_', timestamp_str,
  '  UNION ALL ',
  '  SELECT account_type, initial_deposit FROM credit_', timestamp_str,
  ') AS united_views ',
  'GROUP BY account_type'
);

    -- Execute insertion into the union_table
    PREPARE summary_sql FROM @summary_sql;
    EXECUTE summary_sql;
    DEALLOCATE PREPARE summary_sql;

    -- Export the union_table to a CSV file
   SET @export_sql = CONCAT(
    "SELECT 'account_type', 'count', 'total', 'average initial deposit' ",
    "UNION ALL SELECT * FROM summary ",
    "INTO OUTFILE '", file_path, "_", timestamp_str, ".csv' ",
    "FIELDS TERMINATED BY ',' ENCLOSED BY '\"' ",
    "LINES TERMINATED BY '\n';"
);


    -- Execute the export statement
    PREPARE export_stmt FROM @export_sql;
    EXECUTE export_stmt;
    DEALLOCATE PREPARE export_stmt;
    
END //

DELIMITER ;


-- CALL create_summary_timestamped_views('2024-06-18'); 
