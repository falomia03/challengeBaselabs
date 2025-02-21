# Challenge Base Labs - Fabian Alomia

## Herramientas utilizadas:

- Informatica Powercenter -> Procesamiento de datos
- Teradata -> Almacenamiento de datos
- PowerBI -> Visualización de datos

Nota: En el presente repositorio se encuentra el archivo 'sql_code_challenge' el cual contiene el codigo para crear los objetivos y la logica para resolver el challenge e insertar en la tabla en zona curada, adicionalmente se incluye el archivo 'wf_m_challenge.xml' el cual es el export de todo el workflow de informatica powercenter.

## Analisis datos:

Como primer paso realicé el analisis de los archivos compartidos para el challenge, en este mismo se cuentan con los siguientes insumos:

1: Archvo sales final contiene las ventas de la licorera
2: Archivo purchases final contiene las compras de la licorera
3: Purchase price contiene precio de compra y precio de ventas
4: invoice Purchase contiene información de facturación agrupada por ventas de proveedor
5: BegInvFINAL contiene inventario inicial por tienda año 2016.
6: EndInvFINAL contiene inventario final por tienda año 2016.

Para relsover el challenge:
- Incorpore de manera eficiente los archivos csv relevantes en una base de datos adecuada.
- Transforme los datos para calcular ganancias ($) y márgenes (%).
  1. Las 10 marcas principales con mayor rentabilidad ($) y margen (%).
  2. ¿Qué marcas/productos debería abandonar como mayorista porque están perdiendo dinero?

Se utilizara los archivos "ventasFinales y comprasFinales" esto debido a que las fuentes de facturación e inventarios carecen de información contenida en los archivos de ventas y compras (mas adelante se ejemplifica), adicionalmente el archivo de "precio de compra" si bien contiene información de precio de compra y precio de venta, en la información de ventas hay algunas ventas que no respetan el valor.

## Definición Arquitectura:

Se decide por una arquitectura de datos en capas:
- Capa Staging -> con objetivo de alojar los datos en un RAW sin modificar, con el objetivo de que en esta capa reposen por si en futuro se desea ampliar el requrimiento a mas criterios de analisis.
- Capa Curada  -> En esta capa se alojan los datos transformados siguiendo la logica para generar la ganancia y porcentaje de margen. Desde esta tabla se generara un reporte en archivo plano y adicionalmente en PowerBI.

## Objetos teradata

- El codigo para la creación de objetos se encuentra creado en el presente repositorio https://github.com/fabianalomia9/challengeBaseLabs/blob/main/sql_code_challenge.sql

## Procesamiento de datos Informatica Powercenter:

## Creación origenes y destinos

 - Se genera el primer origen de tipo archivo plano para la lectura del CSV (compras):
   
   ![image](https://github.com/user-attachments/assets/dac8ca72-a862-4a6c-87dd-d131bd790ade)

 - Se genera el segundo origen de tipo archivo plano para la lectura del CSV (ventas):

   ![image](https://github.com/user-attachments/assets/d2d9926f-d84e-4cf8-bc51-f94785cca2cb)

 - Se genera el  origen de tipo 'Teradata' para el export del reporte:

   ![image](https://github.com/user-attachments/assets/c5c02e07-e58f-47b9-a62a-0e60e3b73e33)


 - Se genera el destino de tipo 'Teradata' respetando el esquema relacionado en los objetos de creación (ventas):

   ![image](https://github.com/user-attachments/assets/5e6120c7-13be-4587-a0d3-f50b9ea70db6)


 - Se genera el destino de tipo 'Teradata' respetando el esquema relacionado en los objetos de creación (compras):

   ![image](https://github.com/user-attachments/assets/dd7bcf20-76eb-4c24-88a0-fdf945b84fc8)

 - Se genera el destino de tipo 'archivo plano' para el export del reporte:

   ![image](https://github.com/user-attachments/assets/3c42dfd5-e259-4fed-a5b4-399e9c44fbf1)


 ## Creación de mappings

 - Mapping para el flujo de datos de compras:
 ![image](https://github.com/user-attachments/assets/9cd69b32-8584-4009-929f-e5501818d816)

  Se realiza un tratamiento a los campos de tipo fecha se la siguiente manera:
  <pre><code>`TO_DATE(InvoiceDatePayDate,'YYYY-MM-DD')`</code></pre>

 - Mapping para el flujo de datos de ventas:

   ![image](https://github.com/user-attachments/assets/e31d3368-0674-4ce7-baeb-9e59c84b5aec)

 - Mapping para el flujo de exportable:

   ![image](https://github.com/user-attachments/assets/8a5b734d-269f-432f-ab4b-f2668e4afd6f)


## Creación de workflow

![image](https://github.com/user-attachments/assets/6b85a382-f356-418e-bb6b-d1d38079488f)

 - El cargue de las tablas de ventas al tener al rededor de 12 millones de datos se usa el mecanismo fastload que contempla teradata es ideal para cargar grandes volúmenes de datos a alta velocidad, ya que está 
   optimizado para hacer esto de manera rápida y eficiente.

 - Configuración origenes y destino compras:
   ![image](https://github.com/user-attachments/assets/5a93afd1-d516-495b-921f-8cd56b21b6e6)
   ![image](https://github.com/user-attachments/assets/f894dbc1-05a1-43f3-a93b-12e0bcd1aa0c)


 - Configuración origenes y destino ventas:
  ![image](https://github.com/user-attachments/assets/2cd51e7f-f774-48cc-9c93-fc4c6045bb46)
  ![image](https://github.com/user-attachments/assets/e0023e0b-e09c-41b8-8947-469350821f62)




## Ejecución workflow

![image](https://github.com/user-attachments/assets/8f7f5f32-484e-46aa-aca8-decb5d6b817d)

Se evidencia que el cargue de ventas tardo al rededor de 4 minutos (12825363).

![image](https://github.com/user-attachments/assets/4271ced2-7099-4f83-9515-de72ae7cc0f2)

Se evidencia que el cargue de compras tardo al rededor de 1 minuto (2372474)

![image](https://github.com/user-attachments/assets/e5e3b661-dab2-4f5b-8129-630844865f74)

Se evidencia que el exportable tardo milisegundos en generarse.

## Verificación de datos

Tabla compras (muestra de datos):

![image](https://github.com/user-attachments/assets/ee12123d-169a-4e53-9a70-80ce96219bef)

Tabla ventas (muestra de datos):

![image](https://github.com/user-attachments/assets/d17dd14a-b8ec-42c8-af8d-88fabc593696)

### Query logica para generar ganancias y porcentaje de ganancias

<pre><code>
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
WHERE TotalQuantitySales<TotalQuantityPurchase; </code></pre>

Se inserta en la tabla en zona curada p_dw_tables.challenge_statistics en la sesión del workflow que apunta al mapping donde se realiza el export del reporte, dicha inserción se realiza previo a generar el reporte:

![image](https://github.com/user-attachments/assets/d8bfe6a2-df1c-49bd-9db8-94877f7ad196)

Verificación de datos transformados e ingestados en zona curada:

![image](https://github.com/user-attachments/assets/a37c555c-21ca-429a-b914-0a97b1d8a3b7)

Para la contstrucción de este query se tomo en cuenta lo siguiente:

1: Cruce de las tablas ventas y compras por la llave de marca (Brand)
2: Se agrupa por marca para poder generar las cantidad de compras y de ventas, adicionalmente para efectuar los siguientes calculos:
3: Para realizar el calculo de la ganancia total se emplea la siguiente formula:
  ![image](https://github.com/user-attachments/assets/fa2fd3b3-7224-4628-a723-1d438d2c22ef)

  Se agrupa por marca y adicionalmente se suma los dolares para dicha marca con objetivo de calcular las cantidades totales, este paso tanto para ventas como para compras.

4: Para realizar el calculo del margen ganancia total en porcentaje se emplea la siguiente formula:
  ![image](https://github.com/user-attachments/assets/d961c35e-16f8-43ab-b240-0d60c20aada0)

5: Se tuvo en cuenta la siguiente inconsistencias detectada:
- Se excluyen aquellas marcas en las que la cantidad de ventas supera la cantidad compras, lo cual no es congruente por que no es posible que se venga mas de lo que se tiene en stock, esto se realiza a travez del siguiente filtro:

 <pre><code>WHERE TotalQuantitySales<TotalQuantityPurchase</code></pre>

## Generación Reporte

Codigo 1 para generación de reporte PowerBI top 10 marcas con mayor ganancia:

 <pre><code>SELECT TOP 10 * FROM P_DW_TABLES.CHALLENGE_STATISTICS ORDER BY PROFIT DES</code></pre>

 ![image](https://github.com/user-attachments/assets/51049a01-0d6f-47bb-a5f7-16f1c8a6c041)


Codigo 2 para generación de reporte PowerBI top 10 marcas con mayor margen de ganancia en porcentaje:

<pre><code>SELECT TOP 10 * FROM P_DW_TABLES.CHALLENGE_STATISTICS ORDER BY MarginPercent DESC</code></pre>

![image](https://github.com/user-attachments/assets/57dd3698-ab6b-47fe-b0ac-d815005a26a9)


Codigo 3 para generación de reporte PowerBI top marcas/productos debería abandonar como mayorista porque están perdiendo dinero:

<pre><code>SELECT TOP 3 * FROM TP_DW_TABLES.CHALLENGE_STATISTICS ORDER BY PROFIT ASC</code></pre>

![image](https://github.com/user-attachments/assets/22a5a2ce-17a8-46bf-9a63-38f14ecf17ee)


El reporte en archivo plano se encuentra en el presente repositorio https://github.com/fabianalomia9/challengeBaseLabs/blob/main/challenge_export.txt

-   No se tuvo en cuenta el archivo 'Facturas Compras' ya que no cuenta con toda la información de compras de manera consistente, a continuación un ejemplo:

  Se toma como referencia el Brand 12218 donde se identifica que tiene una cantidad de 151 compras y 143 ventas: 
  ![image](https://github.com/user-attachments/assets/4363cdbe-72f5-4ba9-b7a1-0a2864fca675)

  Al realizar la validación sobre la información de compras totales se identifica que el vendorNumber es 1392  
  ![image](https://github.com/user-attachments/assets/a964f97f-bee8-4246-bcb5-f16d46ecf2f6)

  Tomo como referencia el PONumber 1152 que en teoría sería el identificador de la compra, al buscar en el archivo InvoicePurchases se identifica que al filtrar por el vendorNO 1392 no tiene facturas asociadas al 
  PONumber 1152:



 

  




  

   



   
 
