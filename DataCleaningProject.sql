select * 
from nashville_housing;



-- standardize date format
alter table nashville_housing
add SaleDateConverted date;

SELECT STR_TO_DATE('April 9, 2013','%M %d,%Y');

Update nashville_housing
Set SaleDateConverted = STR_TO_DATE(SaleDate,'%M %d,%Y');

select saleDateConverted
From nashville_housing;






-- Populate Property address
select *
From nashville_housing
-- where PropertyAddress is null;
order by ParcelID;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
From nashville_housing a
Join nashville_housing b
ON a.ParcelID = b.ParcelID
 AND a.UniqueID <> b.UniqueID
 WHERE a.PropertyAddress is null;
 
/*Update a
SET PropertyAddress = ISNULL(a.PropertyAdress,b.PropertyAddress)
From nashville_housing a
Join nashville_housing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
 WHERE a.PropertyAddress is null
*/





-- breaking out adress into columns(adress,'city,state')
select *
From nashville_housing;


SELECT SUBSTRING(PropertyAddress,1,LOCATE(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,LOCATE(',',PropertyAddress)+1) as Address
FROM nashville_housing;

alter table nashville_housing
add PropertySplitCity nvarchar(255);

Update nashville_housing
Set PropertySplitCity = SUBSTRING(PropertyAddress,LOCATE(',',PropertyAddress)+1);

alter table nashville_housing
add PropertySplitAddress nvarchar(255);

update nashville_housing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,LOCATE(',',PropertyAddress)-1);

SELECT SUBSTRING(OwnerAddress,1,LOCATE(',',OwnerAddress)-1) as Address,
SUBSTRING(OwnerAddress,LOCATE(',',OwnerAddress)+1) as citystate
FROM nashville_housing;

alter table nashville_housing
add Ownersplitaddress nvarchar(255);

Update nashville_housing
Set OwnerSplitaddress = SUBSTRING(OwnerAddress,1,LOCATE(',',OwnerAddress)-1);

alter table nashville_housing
add Ownersplitcitystate nvarchar(255);

Update nashville_housing
Set OwnerSplitcitystate = SUBSTRING(OwnerAddress,LOCATE(',',OwnerAddress)+1);





-- Change y and n to yes and no in sold as vacant column
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nashville_housing
Group by SoldAsVacant
order by 2;




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From nashville_housing;


Update nashville_housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;






-- Remove duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From nashville_housing
-- order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;



Select *
From nashville_housing;









-- delete unused columns
Select *
From nashville_housing;


ALTER TABLE nashville_housing
DROP COLUMN OwnerAddress, 
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress, 
DROP COLUMN SaleDate;
