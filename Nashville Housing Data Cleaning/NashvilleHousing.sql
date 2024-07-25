/*

Cleaning Data in SQL Queries

*/


Select *
From [Portfolio Project]..NashvilleHousing


-- Standardize Date Format
Select SaleDateConverted, Convert(Date,SaleDate)
From [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address data

Select a.ParcelID,b.PropertyAddress, b.ParcelID,  b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project]..NashvilleHousing a
Join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

Update a 
SET PropertyAddress =ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project]..NashvilleHousing a
Join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]



	-------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
Select PropertyAddress
From [Portfolio Project]..NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address
From [Portfolio Project]..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress =SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))



Select *
From [Portfolio Project]..NashvilleHousing

Select OwnerAddress
From [Portfolio Project]..NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From [Portfolio Project]..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress =PARSENAME(Replace(OwnerAddress,',','.'),3)


ALTER TABLE dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER TABLE dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


Select *
From [Portfolio Project]..NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project]..NashvilleHousing
Group By (SoldAsVacant)
Order by 2

Select SoldAsVacant
,Case When SoldAsVacant='Y' THEN 'Yes'
	WHEN SoldAsVacant='N' Then 'No'
	ELSE SoldAsVacant
	END
From [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant=Case When SoldAsVacant='Y' THEN 'Yes'
	WHEN SoldAsVacant='N' Then 'No'
	ELSE SoldAsVacant
	END


	-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() Over(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From [Portfolio Project]..NashvilleHousing
--order by ParcelID
)
--Step 1 is  Select
--Step 2 is DELETE
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From [Portfolio Project]..NashvilleHousing


Alter Table [Portfolio Project]..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter Table [Portfolio Project]..NashvilleHousing
Drop Column SaleDate












