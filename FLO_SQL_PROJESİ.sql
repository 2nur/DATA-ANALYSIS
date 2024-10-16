
--SORU 1 Customers isimli bir veritabanında verilen veri setindeki değişkenleri içerecek FLO isimli bir tablo oluşturma:
CREATE DATABASE CUSTOMERS

CREATE TABLE FLO (
	master_id						VARCHAR(50),
	order_channel						VARCHAR(50),
	last_order_channel					VARCHAR(50),
	first_order_date					DATE,
	last_order_date						DATE,
	last_order_date_online				        DATE,
	last_order_date_offline					DATE,
	order_num_total_ever_online				INT,
	order_num_total_ever_offline				INT,
	customer_value_total_ever_offline			FLOAT,
	customer_value_total_ever_online			FLOAT,
	interested_in_categories_12				VARCHAR(50),
	store_type						VARCHAR(10)
);



--SORU 2: Kaç farklı müşterinin alışveriş yaptığını gösterecek sorguyu yazma.
SELECT COUNT(DISTINCT(master_id)) AS DISTINCT_KISI_SAYISI FROM FLO;


--SORU 3:Online sipariş sayısı 500'Den fazla olan müşterileri ve alışveriş yaparken kullandıkları kanalları bulma.
SELECT 
master_id,order_channel
FROM FLO
WHERE order_num_total_ever_online >500


--SORU 4: Toplam yapılan alışveriş sayısı ve ciroyu getirecek sorguyu yazma.
SELECT 
	SUM(order_num_total_ever_offline + order_num_total_ever_online) AS TOPLAM_SIPARIS_SAYISI,
	ROUND(SUM(customer_value_total_ever_offline + customer_value_total_ever_online), 2) AS TOPLAM_CIRO
FROM FLO


--SORU 5:  Alışveriş başına ortalama ciroyu getirecek sorguyu yazma. 
SELECT 
ROUND((sum(customer_value_total_ever_online+customer_value_total_ever_offline) / SUM(order_num_total_ever_online + order_num_total_ever_offline)),2) AS ORTCIRO
FROM FLO

--SORU 6: En son alışveriş yapılan kanal (last_order_channel) üzerinden yapılan alışverişlerin toplam ciro ve alışveriş sayılarını getirme
select 
last_order_channel AS KANAL,
SUM(customer_value_total_ever_online+customer_value_total_ever_offline) AS TOPLAM_CIRO,
SUM(order_num_total_ever_online+order_num_total_ever_offline) AS ALIŞVERİŞ_SAYISI_TOPLAM
from FLO
GROUP BY last_order_channel


--SORU 7: Store type kırılımında elde edilen toplam ciroyu getiren sorgu
SELECT store_type MAGAZATURU, 
       ROUND(SUM(customer_value_total_ever_offline + customer_value_total_ever_online), 2)  AS TOPLAM_CIRO 
FROM FLO 
GROUP BY store_type
 

--SORU 8: Yıl kırılımında alışveriş sayılarını getirecek sorguyu yaz (Yıl olarak müşterinin ilk alışveriş tarihi (first_order_date) yılını baz alma)
SELECT 
YEAR(first_order_date)  as YIL, 
SUM(order_num_total_ever_offline + order_num_total_ever_online)  AS SIPARIS_SAYISI
FROM  FLO
GROUP BY YEAR(first_order_date)


--SORU 9: En son alışveriş yapılan kanal kırılımında alışveriş başına ortalama ciroyu hesaplayacak sorgu
SELECT 
last_order_channel, 
 ROUND(SUM(customer_value_total_ever_offline + customer_value_total_ever_online),2)  AS TOPLAM_CIRO,
 SUM(order_num_total_ever_offline + order_num_total_ever_online)  AS TOPLAM_SIPARIS_SAYISI,
 ROUND(SUM(customer_value_total_ever_offline + customer_value_total_ever_online) / SUM(order_num_total_ever_offline + order_num_total_ever_online),2) AS VERIMLILIK
FROM FLO
GROUP BY last_order_channel


--SORU 10: Son 12 ayda en çok ilgi gören kategoriyi getiren sorguyu yazma
SELECT interested_in_categories_12, COUNT(*) FREKANS_BILGISI 
FROM FLO
GROUP BY interested_in_categories_12
ORDER BY interested_in_categories_12 ASC


--SORU 11:  En çok tercih edilen store_type bilgisini getiren sorguyu yazma
SELECT TOP 1   
store_type, COUNT(*) FREKANS_BILGISI 
FROM FLO 
GROUP BY store_type 
ORDER BY store_type ASC   --ORDER BY 2 DESC ŞEKLİNDEDE YAZILABİLİR



--SORU 12: En son alışveriş yapılan kanal (last_order_channel) bazında, en çok ilgi gören kategoriyi ve bu kategoriden ne kadarlık alışveriş yapıldığını getiren sorguyu yazma.
SELECT DISTINCT last_order_channel,
(
	SELECT top 1 interested_in_categories_12
	FROM FLO  WHERE last_order_channel=f.last_order_channel
	group by interested_in_categories_12
	order by SUM(order_num_total_ever_online+order_num_total_ever_offline) desc 
) AS EN_ÇOK_ILGI_GÖREN_KATEGORI,
(
	SELECT top 1 SUM(order_num_total_ever_online+order_num_total_ever_offline)
	FROM FLO  WHERE last_order_channel=f.last_order_channel
	group by interested_in_categories_12
	order by SUM(order_num_total_ever_online+order_num_total_ever_offline) desc 
) AS ALIŞVERİŞ_SAYISI
FROM FLO F




--SORU 13: En çok alışveriş yapan kişinin ID’sini getiren sorgu 
 SELECT TOP 1 master_id   		    
	FROM FLO 
	GROUP BY master_id 
ORDER BY  SUM(customer_value_total_ever_offline + customer_value_total_ever_online)    DESC 



--SORU 14: En çok alışveriş yapan kişinin alışveriş başına ortalama cirosunu ve alışveriş yapma gün ortalamasını (alışveriş sıklığını) getiren sorgu
SELECT D.master_id,
ROUND((D.TOPLAM_CIRO / D.TOPLAM_SIPARIS_SAYISI),2) SIPARIS_BASINA_ORTALAMA,
ROUND((DATEDIFF(DAY, first_order_date, last_order_date)/D.TOPLAM_SIPARIS_SAYISI ),1) AS ALISVERIS_GUN_ORT
FROM
(
SELECT TOP 1 master_id, first_order_date, last_order_date,
		   SUM(customer_value_total_ever_offline + customer_value_total_ever_online) TOPLAM_CIRO,
		   SUM(order_num_total_ever_offline + order_num_total_ever_online) TOPLAM_SIPARIS_SAYISI
	FROM FLO 
	GROUP BY master_id,first_order_date, last_order_date
ORDER BY TOPLAM_CIRO DESC
) D


--SORU 15: En çok alışveriş yapan (ciro bazında) ilk 100 kişinin alışveriş yapma gün ortalamasını (alışveriş sıklığını) getiren sorgu
SELECT  
D.master_id,
       D.TOPLAM_CIRO,
	   D.TOPLAM_SIPARIS_SAYISI,
       ROUND((D.TOPLAM_CIRO / D.TOPLAM_SIPARIS_SAYISI),2) SIPARIS_BASINA_ORTALAMA,
	   DATEDIFF(DAY, first_order_date, last_order_date) ILK_GÜN_ALIŞVERİŞ_GUN_FARK,
	  ROUND((DATEDIFF(DAY, first_order_date, last_order_date)/D.TOPLAM_SIPARIS_SAYISI ),1) ALISVERIS_GUN_ORT	 
  FROM
(
SELECT TOP 100 master_id, first_order_date, last_order_date,
		   SUM(customer_value_total_ever_offline + customer_value_total_ever_online) TOPLAM_CIRO,
		   SUM(order_num_total_ever_offline + order_num_total_ever_online) TOPLAM_SIPARIS_SAYISI
	FROM FLO 
	GROUP BY master_id,first_order_date, last_order_date
ORDER BY TOPLAM_CIRO DESC
) D


--SORU 16: En son alışveriş yapılan kanal (last_order_channel) kırılımından çok alışveriş yapan müşteriyi getiren sorguyu yazma
SELECT DISTINCT last_order_channel,
(
	SELECT top 1 master_id
	FROM FLO  WHERE last_order_channel=f.last_order_channel
	group by master_id
	order by 
	SUM(customer_value_total_ever_offline+customer_value_total_ever_online) desc 
) EN_COK_ALISVERIS_YAPAN_MUSTERI,
(
	SELECT top 1 SUM(customer_value_total_ever_offline+customer_value_total_ever_online)
	FROM FLO  WHERE last_order_channel=f.last_order_channel
	group by master_id
	order by 
	SUM(customer_value_total_ever_offline+customer_value_total_ever_online) desc 
) CIRO
FROM FLO F


--SORU 17:  En son alışveriş yapan kişinin ID’ sini getiren sorguyu yazma. (Max son tarihte birden fazla alışveriş yapan ID bulunmakta.) 
SELECT master_id,last_order_date FROM FLO
WHERE last_order_date=(SELECT MAX(last_order_date) FROM FLO)


--SORU 18:Belirli bir tarihten sonra sipariş veren müşteriler('2019-08-21' / '2020-06-13')

SELECT master_id, last_order_date
FROM FLO
WHERE last_order_date_online between '2019-08-21' and '2020-06-13' 


--SORU 19: Sadece online ya da sadece offline alışveriş yapan müşteriler
SELECT master_id
FROM FLO
WHERE order_num_total_ever_online = 0 OR order_num_total_ever_offline = 0

--SORU 20 :Mağaza türüne göre müşteri dağılımı
SELECT store_type, COUNT(*) AS customer_count
FROM FLO
GROUP BY store_type
ORDER BY customer_count DESC


--SORU 21:İlgilendiği kategorilere göre müşteri sayısı
SELECT interested_in_categories_12, COUNT(master_id) AS customer_count
FROM FLO
GROUP BY interested_in_categories_12
ORDER BY customer_count DESC;


--SORU 22 :2021 yılında sipariş veren müşterileri bulma
SELECT master_id, last_order_date
FROM FLO
WHERE YEAR(last_order_date) = 2021


--SORU 23:Toplam online ve offline sipariş sayısı aynı olan müşterileri listeme
SELECT master_id, order_num_total_ever_online, order_num_total_ever_offline
FROM FLO
WHERE order_num_total_ever_online = order_num_total_ever_offline;



