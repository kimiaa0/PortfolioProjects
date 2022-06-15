-- Cleaning Data in SQL Queries

Select * 
From PortfolioPproject.dbo.NashvilleHousing

-- Changing Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioPproject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing 
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate Property Address Data

Select *
From PortfolioPproject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioPproject.dbo.NashvilleHousing a
JOIN PortfolioPproject.dbo.NashvilleHousing b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioPproject.dbo.NashvilleHousing a
JOIN PortfolioPproject.dbo.NashvilleHousing b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




-- Breaking out Address into Individual Columns (Address, CIty, State)


Select PropertyAddress
From PortfolioPproject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 ) as Address
, SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioPproject.dbo.NashvilleHousing


ALTER TABLE PortfolioPproject.dbo.NashvilleHousing 
Add PropertySplitAddress Nvarchar(255);

Update PortfolioPproject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 )



ALTER TABLE PortfolioPproject.dbo.NashvilleHousing 
Add PropertySplitCity Nvarchar(255);

Update PortfolioPproject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select * 

From PortfolioPproject.dbo.NashvilleHousing



Select OwnerAddress
From PortfolioPproject.dbo.NashvilleHousing



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From PortfolioPproject.dbo.NashvilleHousing




ALTER TABLE PortfolioPproject.dbo.NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioPproject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)



ALTER TABLE PortfolioPproject.dbo.NashvilleHousing 
Add OwnerSplitCity Nvarchar(255);

Update PortfolioPproject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)


ALTER TABLE PortfolioPproject.dbo.NashvilleHousing 
Add OwnerSplitState Nvarchar(255);

Update PortfolioPproject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)




Select * 
From PortfolioPproject.dbo.NashvilleHousing




-- Change Y and N to Yes and No in "Sold as Vacant" field

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioPproject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioPproject.dbo.NashvilleHousing


Update PortfolioPproject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






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


From PortfolioPproject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
From PortfolioPproject.dbo.NashvilleHousing






-- Delete Unused Columns


Select *
From PortfolioPproject.dbo.NashvilleHousing

ALTER TABLE PortfolioPproject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioPproject.dbo.NashvilleHousing
DROP COLUMN SaleDate