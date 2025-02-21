--- 1: creación tabla staging para ingestar datos de ventas ---

CREATE MULTISET TABLE P_STAGING.salesInventory ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      InventoryId VARCHAR(250) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      Store INTEGER,
      Brand INTEGER,
      Description VARCHAR(250) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      Size VARCHAR(100) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      SalesQuantity INTEGER,
      SalesDollars DECIMAL(10,2),
      SalesPrice DECIMAL(10,2),
      SalesDate DATE FORMAT 'yyyy-mm-dd',
      Volume INTEGER,
      Classification INTEGER,
      ExciseTax DECIMAL(10,2),
      VendorNo INTEGER,
      VendorName VARCHAR(250) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL)
PRIMARY INDEX ( InventoryId );


--- 2: Creación tabla staging  para ingestar datos de compras -----

CREATE MULTISET TABLE P_STAGING.purchasesInventory ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      InventoryId VARCHAR(250) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      Store INTEGER,
      Brand INTEGER,
      Description VARCHAR(250) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      Size VARCHAR(10) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      VendorNumber INTEGER,
      VendorName VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      PONumber INTEGER,
      PODate DATE FORMAT 'yyyy-mm-dd',
      ReceivingDate DATE FORMAT 'yyyy-mm-dd',
      InvoiceDate DATE FORMAT 'yyyy-mm-dd',
      PayDate DATE FORMAT 'yyyy-mm-dd',
      PurchasePrice DECIMAL(10,2),
      Quantity INTEGER,
      Dollars DECIMAL(10,2),
      Classification INTEGER)
PRIMARY INDEX ( InventoryId );


--- 3: Creación tabla curada para ingestar datos transformados -----


CREATE MULTISET TABLE p_dw_tables.challenge_statistics ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      Brand INTEGER,
      BrandDescription VARCHAR(250) CHARACTER SET LATIN NOT CASESPECIFIC,
      TotalQuantitySales INTEGER,
      TotalQuantityPurchase INTEGER,
      Profit DECIMAL(15,2),
      MarginPercent INTEGER)
PRIMARY INDEX ( Brand );


--- 4: Codigo SQL que contiene la logica para generar las ganancias en $ y el margen de ganancia en porcentaje ---

DELETE FROM p_dw_tables.challenge_statistics;

INSERT INTO p_dw_tables.challenge_statistics
SELECT A.Brand,
	   A.description AS BrandDescription,
       TotalQuantitySales,
       TotalQuantityPurchase,
       (SalesDollarsTotal-PurchasesDollarsTotal) AS Profit,
       CASE
           WHEN PurchasesDollarsTotal = 0 THEN 0
           ELSE CAST(((SalesDollarsTotal-PurchasesDollarsTotal)/PurchasesDollarsTotal) * 100 AS INTEGER)
       END AS MarginPercent
FROM
  (SELECT Brand,
  		  description,
          SUM(Dollars) AS PurchasesDollarsTotal,
          SUM(Quantity) AS TotalQuantityPurchase
   FROM P_STAGING.purchasesInventory
   GROUP BY Brand,description) A
INNER JOIN
  (SELECT Brand,
  		  description,
          SUM(SalesDollars) AS SalesDollarsTotal,
          SUM(SalesQuantity) AS TotalQuantitySales
   FROM p_staging.salesInventory
   GROUP BY Brand,description) B ON A.Brand=B.Brand
WHERE TotalQuantitySales<TotalQuantityPurchase;


--- 5: Codigo 1 para generación de reporte PowerBI top 10 marcas con mayor ganancia

SELECT TOP 10 * FROM P_DW_TABLES.CHALLENGE_STATISTICS ORDER BY PROFIT DES

--- 6: Codigo 2 para generación de reporte PowerBI top 10 marcas con mayor margen de ganancia en porcentaje

SELECT TOP 10 * FROM TEMP_TABLES.CHALLENGE_STATISTICS ORDER BY MarginPercent DESC

--- 7: Codigo 3 para generación de reporte PowerBI top marcas/productos debería abandonar como mayorista porque están perdiendo dinero

SELECT TOP 3 * FROM TEMP_TABLES.CHALLENGE_STATISTICS ORDER BY PROFIT ASC