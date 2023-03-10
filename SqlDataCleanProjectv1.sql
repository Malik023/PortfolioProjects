Select *
From NashvilleHousing;



Select saleDateConverted, Cast(SaleDate as date)
From NashvilleHousing;


Update NashvilleHousing
SET SaleDate = Cast(SaleDate as date);

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Cast(SaleDate as date);





Select *
From NashvilleHousing
--Where PropertyAddress is null
order by ParcelID;




SELECT nh.ParcelID, nh.PropertyAddress, nh2.ParcelID, nh2.PropertyAddress, COALESCE(nh.PropertyAddress, nh2.PropertyAddress)
FROM NashvilleHousing nh
	JOIN NashvilleHousing nh2
	ON nh.ParcelID = nh2.ParcelID AND nh."UniqueID " <> nh2."UniqueID "
WHERE nh.PropertyAddress IS NULL;



UPDATE NashvilleHousing
SET PropertyAddress = (
  SELECT DISTINCT PropertyAddress
  FROM NashvilleHousing nh2
  WHERE nh2.ParcelID = NashvilleHousing.ParcelID
    AND nh2.PropertyAddress IS NOT NULL
  LIMIT 1
)
WHERE PropertyAddress IS NULL;




Select PropertyAddress
From NashvilleHousing;
--Where PropertyAddress is null
--order by ParcelID;

SELECT
SUBSTR(Propertyaddress, 1, INSTR(PropertyAddress, ',')-1) as Address
, SUBSTR(Propertyaddress, INSTR(PropertyAddress, ',') + 1, Length(PropertyAddress)) as Address
From NashvilleHousing;


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTR(Propertyaddress, 1, INSTR(PropertyAddress, ',')-1);



ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTR(Propertyaddress, INSTR(PropertyAddress, ',') + 1, Length(PropertyAddress));




Select *
From NashvilleHousing;



Select OwnerAddress 
From NashvilleHousing;


Select OwnerAddress
From NashvilleHousing;



SELECT 
  SUBSTR(OwnerAddress, LENGTH(OwnerAddress) - 1) AS OwnerState,
  SUBSTR(SUBSTR(OwnerAddress, 1, LENGTH(OwnerAddress) - INSTR(REVERSE(OwnerAddress), ',')), INSTR(SUBSTR(OwnerAddress, 1, LENGTH(OwnerAddress) - INSTR(OwnerAddress, ',')), ',') + 2) AS OwnerCity,
  SUBSTR(OwnerAddress, 1, INSTR(OwnerAddress, ',') - 1) AS OwnerAddress
FROM NashvilleHousing;





ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = SUBSTR(OwnerAddress, 1, INSTR(OwnerAddress, ',') - 1);


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = SUBSTR(SUBSTR(OwnerAddress, 1, LENGTH(OwnerAddress) - INSTR(REVERSE(OwnerAddress), ',')), INSTR(SUBSTR(OwnerAddress, 1, LENGTH(OwnerAddress) - INSTR(OwnerAddress, ',')), ',') + 2);


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = SUBSTR(OwnerAddress, LENGTH(OwnerAddress) - 1);


Select *
From NashvilleHousing nh; 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from NashvilleHousing nh 
Group by SoldAsVacant
Order By 2;


Select SoldAsVacant
, CASE WHEN SoldASVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant 
	   END
From NashvilleHousing nh;


Update NashvilleHousing 
Set SoldAsVacant = CASE WHEN SoldASVacant = 'Y' THEN 'YES'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant 
	   END;

Update NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'YES' Then 'Yes'
Else SoldAsVacant 
End;




----Deleting Duplicates----
WITH RowNumCTE as (
Select *,
	ROW_NUMBER() OVER (
	Partition By ParcelID,
			 PropertyAddress,
			 SalePrice, 
			 SaleDate,
			 LegalReference
			 Order BY
			   "UniqueID "
			 ) ROW_NUMBER 

from NashvilleHousing nh
--order by ParcelID
)
Select *
From RowNumCTE
Where Row_Number > 1;
--order by PropertyAddress; 





WITH RowNumCTE as (
Select *,
	ROW_NUMBER() OVER (
	Partition By ParcelID,
			 PropertyAddress,
			 SalePrice, 
			 SaleDate,
			 LegalReference
			 Order BY
			   "UniqueID "
			 ) ROW_NUMBER 

from NashvilleHousing nh 
--order by ParcelID
)
DELETE 
From RowNumCTE
Where Row_Number > 1;
--order by PropertyAddress; 





----Deleting Unused Columns----


Select *
From PortfolioProject.dbo.NashvilleHousing;


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;







                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  