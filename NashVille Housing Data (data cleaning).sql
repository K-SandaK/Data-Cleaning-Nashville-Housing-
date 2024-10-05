--Cleaning Data in SQL Queries

select *
from [Nashville Housing Data ]

.........................................................................

--Populate Property Address Data

select 
	a.parcelid, 
	a.PropertyAddress, 
	b.parcelid, 
	b.PropertyAddress,
	isnull(a.PropertyAddress, b.PropertyAddress)

from [Nashville Housing Data ] AS a
join [Nashville Housing Data ] AS b on a.parcelid = b.parcelid and a.uniqueid <> b.uniqueid
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.PropertyAddress, b.PropertyAddress)
from [Nashville Housing Data ] a
join [Nashville Housing Data ] b
on a.parcelid = b.parcelid
and a.uniqueid <> b.uniqueid
where a.PropertyAddress is null

--.........................................................................

--Breaking out Address into individual columns (Address, City,)

select 
substring(propertyaddress, 1, charindex(',', propertyaddress) -1) as address
, substring(propertyaddress, charindex(',', propertyaddress) +1, len(propertyaddress)) as address
from [Nashville Housing Data ]

 alter table [Nashville Housing Data ]
 add PropertySplitAddress nvarchar(255)

 update [Nashville Housing Data ]
 set PropertySplitAddress = substring(propertyaddress, 1, 
 charindex(',', propertyaddress) -1) 

 alter table [Nashville Housing Data ]
 add PropertySplitCity nvarchar(255)

 update [Nashville Housing Data ]
 set PropertySplitCity = substring(propertyaddress, charindex(',', propertyaddress) +1, 
 len(propertyaddress))

 
 -.........................................................................
--Change "1" to "Yes" and "0" to "No"

SELECT REPLACE(soldasvacant, '1', 'Yes') AS ReplacedColumn
FROM [Nashville Housing Data ];

SELECT REPLACE(soldasvacant, '0', 'No') AS ReplacedColumn
FROM [Nashville Housing Data ];

update [Nashville Housing Data ]
set Soldasvacant = REPLACE(soldasvacant, '1', 'Yes') 
REPLACE(soldasvacant, '0', 'No')


.........................................................................
--Remove Duplicates
with rownumCTE as(
select *,
	row_number () over(
	partition by parcelid,
		saleprice,
		saledate,
		Propertyaddress,
		legalreference
order by uniqueid
		) row_num
from [Nashville Housing Data ]
)
delete
from rownumCte
where row_num >1

.........................................................................

--Delete Unused Columns

alter table [Nashville Housing Data ]
drop column propertyaddress, taxdistrict

select *
from [Nashville Housing Data ]



