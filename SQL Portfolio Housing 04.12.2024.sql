-- Cleaning DAta in SQL Queries

SELECT *
From PortfolioProject..NashvilleHousing

--Standard Date FOrmat

Select SaleDateConverted, Convert(date,saledate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(date,saledate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(date,saledate)

-- Populate Property Address

Select *
From PortfolioProject..NashvilleHousing
--where PropertyAddress is null
Order by ParcelID

Select nas.ParcelID, nas.PropertyAddress, nas1.ParcelID, nas1.PropertyAddress, ISNULL(nas.propertyaddress,nas1.propertyaddress)
From PortfolioProject..NashvilleHousing nas
Join PortfolioProject..Nashvillehousing nas1
	ON nas.ParcelID = nas1.ParcelID
	AND nas.[UniqueID ] <> nas1.[UniqueID ]
Where nas.PropertyAddress is null

Update nas
Set PropertyAddress = ISNULL(nas.propertyaddress,nas1.propertyaddress)
From PortfolioProject..NashvilleHousing nas
Join PortfolioProject..Nashvillehousing nas1
	ON nas.ParcelID = nas1.ParcelID
	AND nas.[UniqueID ] <> nas1.[UniqueID ]
Where nas.PropertyAddress is null

-- Breaking address into individual columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--Order by ParcelID

Select
Substring (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(250);

Update NashvilleHousing
Set PropertySplitAddress = Substring (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(250);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousing


Select *
From PortfolioProject..NashvilleHousing

Select
PARSENAME (Replace(OwnerAddress, ',', '.'),3) as AddressName
,PARSENAME (Replace(OwnerAddress, ',', '.'),2) as CityName
,PARSENAME (Replace(OwnerAddress, ',', '.'),1) as StateName
From PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(250);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME (Replace(OwnerAddress, ',', '.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(250);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME (Replace(OwnerAddress, ',', '.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(250);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME (Replace(OwnerAddress, ',', '.'),1)


-- Change Y and N to Yes and No in Sold as "Sold As Vacant" Field

Select Distinct SoldAsVacant, Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	End
From PortfolioProject..NashvilleHousing



Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	End

-- Removing Duplicates
-- Write CTE

With RowNumCTE AS(
Select *,
	Row_Number() Over(
	Partition By	ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					Order By
						UniqueID
						) row_num
From PortfolioProject..NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where Row_Num > 1
--Order by PropertyAddress



-- Deleting unsued columns

Select *
From PortfolioProject..NashvilleHousing


Alter Table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject..NashvilleHousing
Drop Column SaleDate



