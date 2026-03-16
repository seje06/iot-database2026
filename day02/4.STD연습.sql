SELECT o.custid
	 , avg(o.saleprice)
	 , std(o.saleprice)
  FROM Orders o
 GROUP BY o.custid;