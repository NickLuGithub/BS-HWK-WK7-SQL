-- ��X�M�̶Q�����~�P���O���Ҧ����~

SELECT
	p.CategoryID , p.ProductName, p.UnitPrice
FROM Products p
WHERE p.CategoryID = (
	SELECT TOP 1 
		pp.CategoryID
	FROM Products pp
	ORDER BY p.UnitPrice DESC 
)
ORDER BY p.UnitPrice DESC 

-- ��X�M�̶Q�����~�P���O�̫K�y�����~

SELECT TOP 1
	p.CategoryID , p.ProductName, p.UnitPrice
FROM Products p
WHERE p.CategoryID = (
	SELECT TOP 1 
		pp.CategoryID
	FROM Products pp
	ORDER BY p.UnitPrice DESC 
)
ORDER BY p.UnitPrice

-- �p��X�W�����O�̶Q�M�̫K�y����Ӳ��~�����t

SELECT 
	(SELECT TOP 1
	p.UnitPrice
	FROM Products p
	WHERE p.CategoryID = (
		SELECT TOP 1 
			pp.CategoryID
		FROM Products pp
		ORDER BY p.UnitPrice DESC 
	)
	ORDER BY p.UnitPrice DESC ) 
	-
	(SELECT TOP 1
	p.UnitPrice
FROM Products p
WHERE p.CategoryID = (
	SELECT TOP 1 
		pp.CategoryID
	FROM Products pp
	ORDER BY p.UnitPrice DESC 
)
ORDER BY p.UnitPrice) AS A

-- ��X�S���q�L����ӫ~���Ȥ�Ҧb���������Ҧ��Ȥ�
--
--
--

-- ��X�� 5 �Q��� 8 �K�y�����~�����~���O

SELECT c.CategoryName , c.CategoryID
FROM (
  SELECT CategoryID, UnitPrice,
    DENSE_RANK() OVER (ORDER BY UnitPrice DESC) AS RankHigh,
    DENSE_RANK() OVER (ORDER BY UnitPrice ASC) AS RankLow
  FROM Products
) AS RankedProducts
INNER JOIN Categories c ON c.CategoryID = RankedProducts.CategoryID
WHERE RankHigh = 5 OR RankLow = 8


-- ��X�ֶR�L�� 5 �Q��� 8 �K�y�����~

SELECT DISTINCT
	c.ContactName
FROM [Order Details] od
INNER JOIN Products  p ON od.ProductID = p.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE p.CategoryID IN (
	SELECT c.CategoryID
	FROM (
	  SELECT CategoryID, UnitPrice,
		DENSE_RANK() OVER (ORDER BY UnitPrice DESC) AS RankHigh,
		DENSE_RANK() OVER (ORDER BY UnitPrice ASC) AS RankLow
	  FROM Products
	) AS RankedProducts
	INNER JOIN Categories c ON c.CategoryID = RankedProducts.CategoryID
	WHERE RankHigh = 5 OR RankLow = 8
)


-- ��X�ֽ�L�� 5 �Q��� 8 �K�y�����~

SELECT DISTINCT
	e.FirstName + e.LastName AS 'Name'
FROM [Order Details] od
INNER JOIN Products  p ON od.ProductID = p.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE p.CategoryID IN (
	SELECT c.CategoryID
	FROM (
	  SELECT CategoryID, UnitPrice,
		DENSE_RANK() OVER (ORDER BY UnitPrice DESC) AS RankHigh,
		DENSE_RANK() OVER (ORDER BY UnitPrice ASC) AS RankLow
	  FROM Products
	) AS RankedProducts
	INNER JOIN Categories c ON c.CategoryID = RankedProducts.CategoryID
	WHERE RankHigh = 5 OR RankLow = 8
)


-- ��X 13 ���P�������q�� (�c�]���q��)

SELECT 
*
FROM Orders o
WHERE DAY(o.OrderDate) = 13 AND DATEPART(WEEKDAY, o.OrderDate) = 6

-- ��X�֭q�F�c�]���q��

SELECT 
	c.ContactName
FROM Customers c
WHERE c.CustomerID IN (
	SELECT 
		o.CustomerID
	FROM Orders o
	WHERE DAY(o.OrderDate) = 13 AND DATEPART(WEEKDAY, o.OrderDate) = 6
)

-- ��X�c�]���q��̦����򲣫~

SELECT 
	p.ProductID, p.ProductName
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE od.OrderID IN (
	SELECT 
		o.OrderID
	FROM Orders o
	WHERE DAY(o.OrderDate) = 13 AND DATEPART(WEEKDAY, o.OrderDate) = 6
)

-- �C�X�q�ӨS������ (Discount) �X�⪺���~

SELECT  DISTINCT
	p.ProductID, p.ProductName
FROM [Order Details] od
INNER JOIN Products p ON p.ProductID = od.ProductID
WHERE od.Discount = 0
ORDER BY P.ProductID

-- �C�X�ʶR�D���ꪺ���~���Ȥ�

SELECT DISTINCT
	c.CustomerID, c.ContactName
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE s.City != c.City

-- �C�X�b�P�ӫ����������q���u�i�H�A�Ȫ��Ȥ�

SELECT DISTINCT
	s.CompanyName
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE s.City = e.City

-- �C�X���ǲ��~�S���H�R�L

SELECT DISTINCT
	p.ProductID, p.ProductName
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE od.ProductID = NULL
----------------------------------------------------------------------------------------

-- �C�X�Ҧ��b�C�Ӥ�멳���q��
-- EOMONTH(o.OrderDate) �C��̫�@��
SELECT
*
FROM Orders o
WHERE o.OrderDate =  EOMONTH(o.OrderDate)

-- �C�X�C�Ӥ�멳��X�����~

SELECT DISTINCT
	p.ProductID, p.ProductName
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE od.OrderID IN (
	SELECT
	o.OrderID
	FROM Orders o
	WHERE o.OrderDate =  EOMONTH(o.OrderDate)
)

-- ��X���ѹL�̶Q���T�Ӳ��~��������@�Ӫ��e�T�Ӥj�Ȥ�

SELECT TOP 3
	p.ProductID, p.ProductName, p.UnitPrice
FROM Products p
ORDER BY p.UnitPrice DESC

SELECT 
	o.CustomerID,
	SUM(od.UnitPrice) AS TotalPrice
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID
ORDER BY o.CustomerID

-- ��X���ѹL�P����B�e�T���Ӳ��~���e�T�Ӥj�Ȥ�



-- ��X���ѹL�P����B�e�T���Ӳ��~�������O���e�T�Ӥj�Ȥ�

-- �C�X���O�`���B����Ҧ��Ȥᥭ�����O�`���B���Ȥ᪺�W�r�A�H�ΫȤ᪺���O�`���B

-- �C�X�̼��P�����~�A�H�γQ�ʶR���`���B

-- �C�X�̤֤H�R�����~

-- �C�X�̨S�H�n�R�����~���O (Categories)

-- �C�X��P��̦n�������ӶR�̦h���B���Ȥ�P�ʶR���B (�t�ʶR�䥦�����Ӫ����~)

-- �C�X��P��̦n�������ӶR�̦h���B���Ȥ�P�ʶR���B (���t�ʶR�䥦�����Ӫ����~)

-- �C�X���ǲ��~�S���H�R�L

-- �C�X�S���ǯu (Fax) ���Ȥ�M�������O�`���B

-- �C�X�C�@�ӫ������O�����~�����ƶq

-- �C�X�ثe�S���w�s�����~�b�L�h�`�@�Q�q�ʪ��ƶq

-- �C�X�ثe�S���w�s�����~�b�L�h���g�Q���ǫȤ�q�ʹL

-- �C�X�C����u���U�ݪ��~�Z�`���B

-- �C�X�C�a�f�B���q�B�e�̦h�����@�ز��~���O�P�`�ƶq

-- �C�X�C�@�ӫȤ�R�̦h�����~���O�P���B

-- �C�X�C�@�ӫȤ�R�̦h�����@�Ӳ��~�P�ʶR�ƶq

-- ���ӫ��������A��X�C�@�ӫ����̪�@���q�檺�e�f�ɶ�

-- �C�X�ʶR���B�Ĥ��W�P�ĤQ�W���Ȥ�A�H�Ψ�ӫȤ᪺���B�t�Z