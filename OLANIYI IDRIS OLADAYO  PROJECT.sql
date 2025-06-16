--Inner Join: Retrieve sales order details with customer information.
SELECT *
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID;

--Left Join: Get all products with their corresponding sales order details, if any.
SELECT *
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID;

--Right Join: Retrieve all sales order details with their corresponding products, if any.
SELECT *
FROM Sales.SalesOrderDetail sod
RIGHT JOIN Production.Product p ON sod.ProductID = p.ProductID;

--Full Outer Join: Get all products and sales order details, including those without matches.
SELECT *
FROM Production.Product p
FULL OUTER JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID;

--Subquery in WHERE: Find products with a list price greater than the average list price.
SELECT *
FROM Production.Product
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product);



--Subquery in FROM: Get sales order details with product information.
SELECT *
FROM (
    SELECT ProductID, SUM(OrderQty) AS TotalQuantity
    FROM Sales.SalesOrderDetail
    GROUP BY ProductID
) AS subquery
INNER JOIN Production.Product p ON subquery.ProductID = p.ProductID;

--Correlated Subquery: Find products with a list price greater than the average list price of their product subcategory.
SELECT *
FROM Production.Product p
WHERE ListPrice > (
    SELECT AVG(ListPrice)
    FROM Production.Product
    WHERE ProductSubcategoryID = p.ProductSubcategoryID
);


--Join with Subquery in FROM: Get sales order details with product information and total quantity sold.
SELECT *
FROM (
    SELECT ProductID, SUM(OrderQty) AS TotalQuantity
    FROM Sales.SalesOrderDetail
    GROUP BY ProductID
) AS subquery
INNER JOIN Production.Product p ON subquery.ProductID = p.ProductID
INNER JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID;

-- Join with Subquery in WHERE: Find sales orders with a total due greater than the average total due of orders placed by customers in a specific territory.
SELECT *
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
WHERE TotalDue > (
    SELECT AVG(TotalDue)
    FROM Sales.SalesOrderHeader
    WHERE CustomerID IN (
        SELECT CustomerID
        FROM Sales.Customer
        WHERE TerritoryID = 1
    )
);


--Multiple Joins: Retrieve sales order details with customer, product, and sales order header information.
SELECT *
FROM Sales.SalesOrderDetail sod
INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID;

--Subquery with Multiple Tables: Find products with a list price greater than the average list price of products in the same product subcategory and product category.

SELECT *
FROM Production.Product p
WHERE ListPrice > (
    SELECT AVG(ListPrice)
    FROM Production.Product p2
    INNER JOIN Production.ProductSubcategory ps ON p2.ProductSubcategoryID = ps.ProductSubcategoryID
    INNER JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    WHERE p2.ProductSubcategoryID = p.ProductSubcategoryID AND pc.ProductCategoryID = (
        SELECT ProductCategoryID
        FROM Production.ProductSubcategory
        WHERE ProductSubcategoryID = p.ProductSubcategoryID
    )
);


--Join with Derived Table: Get sales order details with product information and total quantity sold.

SELECT *
FROM Sales.SalesOrderDetail sod
INNER JOIN (
    SELECT ProductID, SUM(OrderQty) AS TotalQuantity
    FROM Sales.SalesOrderDetail
    GROUP BY ProductID
) AS derived_table ON sod.ProductID = derived_table.ProductID
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID;


--Join with Derived Table and Aggregate Function: Get sales order details with product information and total quantity sold.
SELECT *
FROM Sales.SalesOrderDetail sod
INNER JOIN (
    SELECT ProductID, SUM(OrderQty) AS TotalQuantity
    FROM Sales.SalesOrderDetail
    GROUP BY ProductID
) AS derived_table ON sod.ProductID = derived_table.ProductID
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID;

--Join with Subquery in HAVING: Find sales orders with a total due greater than the average total due of orders placed by customers in a specific territory.
SELECT soh.SalesOrderID, soh.TotalDue
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
GROUP BY soh.SalesOrderID, soh.TotalDue
HAVING soh.TotalDue > (
    SELECT AVG(TotalDue)
    FROM Sales.SalesOrderHeader
    WHERE CustomerID IN (
        SELECT CustomerID
        FROM Sales.Customer
        WHERE TerritoryID = 1
    )
);


 --Subquery with ALL: Find products with a list price greater than all products in a specific product category.
SELECT *
FROM Production.Product p
WHERE ListPrice > ALL (
    SELECT ListPrice
    FROM Production.Product p2
    INNER JOIN Production.ProductSubcategory ps ON p2.ProductSubcategoryID = ps.ProductSubcategoryID
    WHERE ps.ProductCategoryID = 1
);


--Subquery with Aggregate Function: Find the product with the highest total sales quantity.
SELECT TOP 1 p.ProductID, p.Name, SUM(sod.OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalQuantity DESC;



Multiple Joins with Subquery: Find sales orders with customer and product information, where the product is part of a specific product category.
SELECT *
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE p.ProductSubcategoryID IN (
    SELECT ProductSubcategoryID
    FROM Production.ProductSubcategory
    WHERE ProductCategoryID = 1
	);


--join with Group By: Find total sales quantity by product category.
SELECT pc.Name, SUM(sod.OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name;



