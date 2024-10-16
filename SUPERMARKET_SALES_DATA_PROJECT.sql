
--ilk olarak SUPERMARKET SALES veritabaný oluþturduk

--SUPERMARKET SALES tablosunu çaðýrma
select*from SUPERMARKET SALES


--Müþteri segmentleri "Consumer" veya "Home Office" olan ilk 20 müþteriler kimlerdir?(isimleriyle)
select top 20
Customer_Name,Ship_Mode
from SUPERMARKET SALES
where Segment='Consumer' or Segment = 'Home Office' ;


--Office Supplies" kategorisinde, 2018 yýlýnda 500'den fazla satýþ yapan müþteriler kimlerdir?
SELECT  top 10
Customer_Name,sum(Sales) as toplam_satýþ
FROM SUPERMARKET SALES
WHERE year(Order_Date) =2018
and  Sales >=500
and Category='Office Supplies '
Group by Customer_Name


--En yüksek satýþ yapan müþteri kimdir?
SELECT TOP 1 
Customer_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;


--En düþük  satýþ yapan müþteri kimdir?
select top 1
Customer_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Customer_Name
order by Total_Sales


--En fazla satýþ yapýlan ülke hangisidir?
select top 1
Country, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Country
order by Total_Sales desc


--En fazla satýþ yapýlan þehir hangisidir?
select top 1
City, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY City
order by Total_Sales  desc


--kaç benzersiz müþteri vardýr?
select 
Customer_Name,COUNT(DISTINCT('Customer_Name')) 
FROM SUPERMARKET SALES
GROUP BY Customer_Name
ORDER BY Customer_Name ASC


--Sipariþlerin toplam sayýsý kaçtýr?
select COUNT(Order_ID)  AS SÝPARÝÞ_SAYISI
FROM SUPERMARKET SALES


--Her bir ürünün toplam sipariþ sayýsý kaçtýr)
select Product_Name,COUNT(Order_ID)  AS SÝPARÝÞ_SAYISI
FROM SUPERMARKET SALES
group by Product_Name


--En çok hangi ürün satýlmýþ?
select top 1
Product_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Product_Name
order by Total_Sales desc


----En az hangi ürün satýlmýþ?
select top 1
Product_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Product_Name
order by Total_Sales 


--Satýþlarý en fazla olan kategori nedir?
select top 1
Category, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Category
order by Total_Sales  desc


--Müþteri segmentlerine göre toplam satýþlar nedir?
select 
Segment, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Segment
order by Total_Sales 


--Sipariþler hangi yýllarda daha fazladýr?
select 
year(Order_Date), count(Order_ID) AS sipariþler
FROM SUPERMARKET SALES
GROUP BY year(Order_Date)
order by sipariþler desc


--Kargo modu ile en çok kullanýlan nakliye türü nedir?
select 
Ship_Mode, count(Order_ID) AS nakliye_sayýsý
FROM SUPERMARKET SALES
GROUP BY Ship_Mode
order by  nakliye_sayýsý desc


--Hangi 10 þehirde en yüksek  satýþ gerçekleþtirilmiþtir?
select top 10
City,sum(Sales)as en_yüksek_atýþ
FROM SUPERMARKET SALES
GROUP BY City
order by  en_yüksek_atýþ desc


--Bir müþterinin ortalama satýþ miktarý nedir?
select 
Customer_Name ,round(avg(Sales),2)as ortalama_satýþ
FROM SUPERMARKET SALES 
group by Customer_Name
order by ortalama_satýþ asc


--Bir ay içinde en fazla sipariþ hangi üründen verilmiþtir? (Örneðin Ocak)
select top 1
Product_Name,Sub_Category ,count(Order_ID)as ürün_sayýsý
FROM SUPERMARKET SALES 
where month(Order_Date)= 1
group by Product_Name,Sub_Category
order by ürün_sayýsý desc


--Kargo moduna göre "Same Day" veya "Standard Class " olan sipariþlerin toplam sayýsý 
select 
Ship_Mode ,count(Sales) as toplam_sayý
FROM SUPERMARKET SALES
where Ship_Mode='Same Day' 
or Ship_Mode='Standard Class'
group by Ship_Mode


--"Furniture" kategorisinde, satýþ miktarý 1000'den fazla olan ürünler nelerdir?
select 
Product_Name,Category,Sales
FROM SUPERMARKET SALES
where Category='Furniture' 
and Sales>=10000
order by  Product_Name asc


--2017 yýlýnda "Technology" veya "Office Supplies" kategorisinde en fazla 5 satýþ yapýlan ürünler hangileridir?
select top 5
Product_Name,Category,sum(Sales) as Satýþ
FROM SUPERMARKET SALES
where year(Order_Date)= 2017 and
(Category='Technology'  or Category='Office Supplies')
group by Product_Name,Category
order by Satýþ desc


--"Office Supplies" kategorisinde, 2021 yýlýnda 700'den fazla satýþ yapan müþteriler kimlerdir?
select 
Customer_Name,Product_Name,Sales
FROM SUPERMARKET SALES
where Category='Office Supplies' 
and year(Order_Date)= 2017 
and Sales>=700
order by Sales desc


--Her þehrin toplam satýþlarý ile en yüksek satýþ yapýlan þehir arasýndaki fark 
SELECT City, SUM(Sales) - (SELECT MAX(total_sales) 
                            FROM (SELECT SUM(Sales) AS total_sales 
                                  FROM SUPERMARKET SALES
                                  GROUP BY City) AS subquery) AS sales_difference
FROM SUPERMARKET SALES
GROUP BY City;



--"Technology" kategorisindeki ürünlerin toplam satýþýnýn, tüm satýþlara oraný
SELECT (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES
        WHERE Category = 'Technology') * 1.0 / 
       (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES) AS technology_sales_ratio;


--Belirli bir eyalet (örneðin, "California") için toplam satýþlarýn, tüm eyaletlerdeki toplam satýþlarýn oraný
SELECT (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES
        WHERE State = 'California') * 1.0 / 
       (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES) AS california_sales_ratio;


--Her ship modunun toplam sipariþ sayýsý
select Ship_Mode,count(Ship_Mode)
from SUPERMARKET SALES
group by Ship_Mode



--"United States" ülkesindeki "Los Angeles" ve "Philadelphia" þehirlerinde, "California" ve "Pennsylvania" eyaletlerine göre toplam satýþlar nedir?
select
City,State,sum(Sales) as satýþ
from SUPERMARKET SALES
where Country='United States' and 
City In('Los Angeles','Philadelphia') and
(State ='California'  or  State='Pennsylvania')
group by  City,State

--Null Postal Kodlarýnýn Sayýsýný Bulma
select count(*) AS NULL_Postal_Kodlarýnýn_Sayýsý
from SUPERMARKET SALES
where Postal_Code IS NULL


--NULL Olmayan Postal Kodlarýnýn Sayýsýný Bulma
select count(*) AS Postal_Kodlarýnýn_Sayýsý
from SUPERMARKET SALES
where Postal_Code IS NOT NULL










