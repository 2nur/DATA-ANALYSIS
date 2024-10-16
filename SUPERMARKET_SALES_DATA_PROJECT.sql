
--ilk olarak SUPERMARKET SALES veritabanı oluşturduk

--SUPERMARKET SALES tablosunu çağırma
select*from SUPERMARKET SALES


--Müşteri segmentleri "Consumer" veya "Home Office" olan ilk 20 müşteriler kimlerdir?(isimleriyle)
select top 20
Customer_Name,Ship_Mode
from SUPERMARKET SALES
where Segment='Consumer' or Segment = 'Home Office' ;


--Office Supplies" kategorisinde, 2018 yılında 500'den fazla satış yapan müşteriler kimlerdir?
SELECT  top 10
Customer_Name,sum(Sales) as toplam_satış
FROM SUPERMARKET SALES
WHERE year(Order_Date) =2018
and  Sales >=500
and Category='Office Supplies '
Group by Customer_Name


--En yüksek satış yapan müşteri kimdir?
SELECT TOP 1 
Customer_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;


--En düþük  satış yapan müşteri kimdir?
select top 1
Customer_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Customer_Name
order by Total_Sales


--En fazla satış yapılan ülke hangisidir?
select top 1
Country, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Country
order by Total_Sales desc


--En fazla satış yapılan şehir hangisidir?
select top 1
City, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY City
order by Total_Sales  desc


--kaç benzersiz müşteri vardır?
select 
Customer_Name,COUNT(DISTINCT('Customer_Name')) 
FROM SUPERMARKET SALES
GROUP BY Customer_Name
ORDER BY Customer_Name ASC


--Siparişlerin toplam sayısı kaçtır?
select COUNT(Order_ID)  AS SÝPARÝÞ_SAYISI
FROM SUPERMARKET SALES


--Her bir ürünün toplam sipariş sayısı kaçtır)
select Product_Name,COUNT(Order_ID)  AS SIPARIS_SAYISI
FROM SUPERMARKET SALES
group by Product_Name


--En çok hangi ürün satılmış?
select top 1
Product_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Product_Name
order by Total_Sales desc


----En az hangi ürün satılmış?
select top 1
Product_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Product_Name
order by Total_Sales 


--Satışları en fazla olan kategori nedir?
select top 1
Category, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Category
order by Total_Sales  desc


--Müşteri segmentlerine göre toplam satışlar nedir?
select 
Segment, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Segment
order by Total_Sales 


--Siparişler hangi yıllarda daha fazladır?
select 
year(Order_Date), count(Order_ID) AS siparişler
FROM SUPERMARKET SALES
GROUP BY year(Order_Date)
order by siparişler desc


--Kargo modu ile en çok kullanılan nakliye türü nedir?
select 
Ship_Mode, count(Order_ID) AS nakliye_sayısı
FROM SUPERMARKET SALES
GROUP BY Ship_Mode
order by  nakliye_sayısı desc


--Hangi 10 şehirde en yüksek  satış gerçeklektirilmiştir?
select top 10
City,sum(Sales)as en_yüksek_satış
FROM SUPERMARKET SALES
GROUP BY City
order by  en_yüksek_satış desc


--Bir müşterinin ortalama satış miktarı nedir?
select 
Customer_Name ,round(avg(Sales),2)as ortalama_satış
FROM SUPERMARKET SALES 
group by Customer_Name
order by ortalama_satış asc


--Bir ay içinde en fazla sipariş hangi üründen verilmiştir? (Örneğin Ocak)
select top 1
Product_Name,Sub_Category ,count(Order_ID)as ürün_sayısı
FROM SUPERMARKET SALES 
where month(Order_Date)= 1
group by Product_Name,Sub_Category
order by ürün_sayısı desc


--Kargo moduna göre "Same Day" veya "Standard Class " olan siparişlerin toplam sayısı 
select 
Ship_Mode ,count(Sales) as toplam_sayısı
FROM SUPERMARKET SALES
where Ship_Mode='Same Day' 
or Ship_Mode='Standard Class'
group by Ship_Mode


--"Furniture" kategorisinde, satış miktarı 1000'den fazla olan ürünler nelerdir?
select 
Product_Name,Category,Sales
FROM SUPERMARKET SALES
where Category='Furniture' 
and Sales>=10000
order by  Product_Name asc


--2017 yılında "Technology" veya "Office Supplies" kategorisinde en fazla 5 satış yapılan ürünler hangileridir?
select top 5
Product_Name,Category,sum(Sales) as Satış
FROM SUPERMARKET SALES
where year(Order_Date)= 2017 and
(Category='Technology'  or Category='Office Supplies')
group by Product_Name,Category
order by Satış desc


--"Office Supplies" kategorisinde, 2021 yılında 700'den fazla satış yapan müşteriler kimlerdir?
select 
Customer_Name,Product_Name,Sales
FROM SUPERMARKET SALES
where Category='Office Supplies' 
and year(Order_Date)= 2017 
and Sales>=700
order by Sales desc


--Her şehrin toplam satışları ile en yüksek satış yapılan şehir arasındaki fark 
SELECT City, SUM(Sales) - (SELECT MAX(total_sales) 
                            FROM (SELECT SUM(Sales) AS total_sales 
                                  FROM SUPERMARKET SALES
                                  GROUP BY City) AS subquery) AS sales_difference
FROM SUPERMARKET SALES
GROUP BY City;



--"Technology" kategorisindeki ürünlerin toplam satışların, tüm satışlara oranı
SELECT (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES
        WHERE Category = 'Technology') * 1.0 / 
       (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES) AS technology_sales_ratio;


--Belirli bir eyalet (örneğin, "California") için toplam satışların, tüm eyaletlerdeki toplam satışlara oranı
SELECT (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES
        WHERE State = 'California') * 1.0 / 
       (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES) AS california_sales_ratio;


--Her ship modunun toplam sipariş sayısı
select Ship_Mode,count(Ship_Mode)
from SUPERMARKET SALES
group by Ship_Mode



--"United States" ülkesindeki "Los Angeles" ve "Philadelphia" şehirlerinde, "California" ve "Pennsylvania" eyaletlerine göre toplam satışlar nedir?
select
City,State,sum(Sales) as satış
from SUPERMARKET SALES
where Country='United States' and 
City In('Los Angeles','Philadelphia') and
(State ='California'  or  State='Pennsylvania')
group by  City,State

--Null Postal Kodlarının Sayısını Bulma
select count(*) AS NULL_Postal_Kodlarının_Sayısı
from SUPERMARKET SALES
where Postal_Code IS NULL


--NULL Olmayan Postal Kodlarının  Sayısını  Bulma
select count(*) AS Postal_Kodlarının_Sayısı
from SUPERMARKET SALES
where Postal_Code IS NOT NULL










