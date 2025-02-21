e# Challenge Base Labs - Fabian Alomia

## Herramientas utilizadas:

- Informatica Powercenter -> Procesamiento de datos
- Teradata -> Almacenamiento de datos
- PowerBI -> Visualización de datos

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

### Creación origenes y destinos

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


 ### Creación de mappings

 - Mapping para el flujo de datos de compras:
 ![image](https://github.com/user-attachments/assets/9cd69b32-8584-4009-929f-e5501818d816)

 Se realiza un tratamiento a los campos de tipo fecha se la siguiente manera:
 <pre><code>`TO_DATE(InvoiceDatePayDate,'YYYY-MM-DD')`</code></pre>

   



   
 
