select *
from PortfolioProject.dbo.Houshing

--Standardize Data Format

select SaleDateConverted, CONVERT(date,SaleDate)
from PortfolioProject.dbo.Houshing

update Houshing
set SaleDate = CONVERT(date, SaleDate)

ALTER TABLE Houshing
add SaleDateConverted date;


update Houshing
set SaleDateConverted = CONVERT(date, SaleDate)

--Populate Property Address Data

select PropertyAddress
from PortfolioProject.dbo.Houshing
where PropertyAddress is not null

select *
from PortfolioProject.dbo.Houshing
where PropertyAddress is null

select *
from PortfolioProject.dbo.Houshing
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.Houshing a
Join PortfolioProject.dbo.Houshing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.Houshing a
Join PortfolioProject.dbo.Houshing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, city, State)


select PropertyAddress
from PortfolioProject.dbo.Houshing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress))as Address,
CHARINDEX(',',PropertyAddress)
from PortfolioProject.dbo.Houshing

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Address
from PortfolioProject.dbo.Houshing

ALTER TABLE Houshing
add PropertySplitAddress Nvarchar(255);

update Houshing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE Houshing
add PropertySplitCity Nvarchar(255);

update Houshing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


select *
from PortfolioProject.dbo.Houshing

select OwnerAddress
from PortfolioProject.dbo.Houshing

select 
PARSENAME(REPLACE(OwnerAddress, ',', ',') , 1),
PARSENAME(REPLACE(OwnerAddress, ',', ',') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', ',') , 3)
from PortfolioProject.dbo.Houshing


ALTER TABLE Houshing
Add OwnerSplitAddress Nvarchar(255);

Update Houshing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Houshing
Add OwnerSplitCity Nvarchar(255);

Update Houshing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Houshing
Add OwnerSplitState Nvarchar(255);

Update Houshing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.Houshing





--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.Houshing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.Houshing


Update Houshing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

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

From PortfolioProject.dbo.Houshing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.Houshing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.Houshing


ALTER TABLE PortfolioProject.dbo.Houshing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



















