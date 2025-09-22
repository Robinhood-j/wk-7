-- Question 1 (1NF)

-- PostgreSQL
SELECT
    pd.OrderID,
    pd.CustomerName,
    TRIM(p) AS Product
FROM ProductDetail pd,
     unnest(string_to_array(pd.Products, ',')) AS p;

-- MySQL 8+
SELECT
    pd.OrderID,
    pd.CustomerName,
    TRIM(j.product) AS Product
FROM ProductDetail pd
JOIN JSON_TABLE(
    CONCAT('["', REPLACE(pd.Products, ',', '","'), '"]'),
    '$[*]' COLUMNS (product VARCHAR(255) PATH '$')
) AS j;

-- SQL Server
SELECT
    pd.OrderID,
    pd.CustomerName,
    LTRIM(RTRIM(s.value)) AS Product
FROM ProductDetail pd
CROSS APPLY STRING_SPLIT(pd.Products, ',') s;


-- Question 2 (2NF)

-- Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- OrderItems table
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);

INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
