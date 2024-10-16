
--ilk olarak SUPERMARKET SALES veritaban� olu�turduk

--SUPERMARKET SALES tablosunu �a��rma
select*from SUPERMARKET SALES


--M��teri segmentleri "Consumer" veya "Home Office" olan ilk 20 m��teriler kimlerdir?(isimleriyle)
select top 20
Customer_Name,Ship_Mode
from SUPERMARKET SALES
where Segment='Consumer' or Segment = 'Home Office' ;


--Office Supplies" kategorisinde, 2018 y�l�nda 500'den fazla sat�� yapan m��teriler kimlerdir?
SELECT  top 10
Customer_Name,sum(Sales) as toplam_sat��
FROM SUPERMARKET SALES
WHERE year(Order_Date) =2018
and  Sales >=500
and Category='Office Supplies '
Group by Customer_Name


--En y�ksek sat�� yapan m��teri kimdir?
SELECT TOP 1 
Customer_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;


--En d���k  sat�� yapan m��teri kimdir?
select top 1
Customer_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Customer_Name
order by Total_Sales


--En fazla sat�� yap�lan �lke hangisidir?
select top 1
Country, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Country
order by Total_Sales desc


--En fazla sat�� yap�lan �ehir hangisidir?
select top 1
City, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY City
order by Total_Sales  desc


--ka� benzersiz m��teri vard�r?
select 
Customer_Name,COUNT(DISTINCT('Customer_Name')) 
FROM SUPERMARKET SALES
GROUP BY Customer_Name
ORDER BY Customer_Name ASC


--Sipari�lerin toplam say�s� ka�t�r?
select COUNT(Order_ID)  AS S�PAR��_SAYISI
FROM SUPERMARKET SALES


--Her bir �r�n�n toplam sipari� say�s� ka�t�r)
select Product_Name,COUNT(Order_ID)  AS S�PAR��_SAYISI
FROM SUPERMARKET SALES
group by Product_Name


--En �ok hangi �r�n sat�lm��?
select top 1
Product_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Product_Name
order by Total_Sales desc


----En az hangi �r�n sat�lm��?
select top 1
Product_Name, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Product_Name
order by Total_Sales 


--Sat��lar� en fazla olan kategori nedir?
select top 1
Category, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Category
order by Total_Sales  desc


--M��teri segmentlerine g�re toplam sat��lar nedir?
select 
Segment, SUM(Sales) AS Total_Sales
FROM SUPERMARKET SALES
GROUP BY Segment
order by Total_Sales 


--Sipari�ler hangi y�llarda daha fazlad�r?
select 
year(Order_Date), count(Order_ID) AS sipari�ler
FROM SUPERMARKET SALES
GROUP BY year(Order_Date)
order by sipari�ler desc


--Kargo modu ile en �ok kullan�lan nakliye t�r� nedir?
select 
Ship_Mode, count(Order_ID) AS nakliye_say�s�
FROM SUPERMARKET SALES
GROUP BY Ship_Mode
order by  nakliye_say�s� desc


--Hangi 10 �ehirde en y�ksek  sat�� ger�ekle�tirilmi�tir?
select top 10
City,sum(Sales)as en_y�ksek_at��
FROM SUPERMARKET SALES
GROUP BY City
order by  en_y�ksek_at�� desc


--Bir m��terinin ortalama sat�� miktar� nedir?
select 
Customer_Name ,round(avg(Sales),2)as ortalama_sat��
FROM SUPERMARKET SALES 
group by Customer_Name
order by ortalama_sat�� asc


--Bir ay i�inde en fazla sipari� hangi �r�nden verilmi�tir? (�rne�in Ocak)
select top 1
Product_Name,Sub_Category ,count(Order_ID)as �r�n_say�s�
FROM SUPERMARKET SALES 
where month(Order_Date)= 1
group by Product_Name,Sub_Category
order by �r�n_say�s� desc


--Kargo moduna g�re "Same Day" veya "Standard Class " olan sipari�lerin toplam say�s� 
select 
Ship_Mode ,count(Sales) as toplam_say�
FROM SUPERMARKET SALES
where Ship_Mode='Same Day' 
or Ship_Mode='Standard Class'
group by Ship_Mode


--"Furniture" kategorisinde, sat�� miktar� 1000'den fazla olan �r�nler nelerdir?
select 
Product_Name,Category,Sales
FROM SUPERMARKET SALES
where Category='Furniture' 
and Sales>=10000
order by  Product_Name asc


--2017 y�l�nda "Technology" veya "Office Supplies" kategorisinde en fazla 5 sat�� yap�lan �r�nler hangileridir?
select top 5
Product_Name,Category,sum(Sales) as Sat��
FROM SUPERMARKET SALES
where year(Order_Date)= 2017 and
(Category='Technology'  or Category='Office Supplies')
group by Product_Name,Category
order by Sat�� desc


--"Office Supplies" kategorisinde, 2021 y�l�nda 700'den fazla sat�� yapan m��teriler kimlerdir?
select 
Customer_Name,Product_Name,Sales
FROM SUPERMARKET SALES
where Category='Office Supplies' 
and year(Order_Date)= 2017 
and Sales>=700
order by Sales desc


--Her �ehrin toplam sat��lar� ile en y�ksek sat�� yap�lan �ehir aras�ndaki fark 
SELECT City, SUM(Sales) - (SELECT MAX(total_sales) 
                            FROM (SELECT SUM(Sales) AS total_sales 
                                  FROM SUPERMARKET SALES
                                  GROUP BY City) AS subquery) AS sales_difference
FROM SUPERMARKET SALES
GROUP BY City;



--"Technology" kategorisindeki �r�nlerin toplam sat���n�n, t�m sat��lara oran�
SELECT (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES
        WHERE Category = 'Technology') * 1.0 / 
       (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES) AS technology_sales_ratio;


--Belirli bir eyalet (�rne�in, "California") i�in toplam sat��lar�n, t�m eyaletlerdeki toplam sat��lar�n oran�
SELECT (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES
        WHERE State = 'California') * 1.0 / 
       (SELECT SUM(Sales) 
        FROM SUPERMARKET SALES) AS california_sales_ratio;


--Her ship modunun toplam sipari� say�s�
select Ship_Mode,count(Ship_Mode)
from SUPERMARKET SALES
group by Ship_Mode



--"United States" �lkesindeki "Los Angeles" ve "Philadelphia" �ehirlerinde, "California" ve "Pennsylvania" eyaletlerine g�re toplam sat��lar nedir?
select
City,State,sum(Sales) as sat��
from SUPERMARKET SALES
where Country='United States' and 
City In('Los Angeles','Philadelphia') and
(State ='California'  or  State='Pennsylvania')
group by  City,State

--Null Postal Kodlar�n�n Say�s�n� Bulma
select count(*) AS NULL_Postal_Kodlar�n�n_Say�s�
from SUPERMARKET SALES
where Postal_Code IS NULL


--NULL Olmayan Postal Kodlar�n�n Say�s�n� Bulma
select count(*) AS Postal_Kodlar�n�n_Say�s�
from SUPERMARKET SALES
where Postal_Code IS NOT NULL










