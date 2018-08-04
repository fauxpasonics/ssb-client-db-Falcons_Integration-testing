SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vwCRMLoad_Contact_Std_Update] AS
--updateme - Hashes
SELECT 
a.new_ssbcrmsystemacctid									  
, a.new_ssbcrmsystemcontactid								  
, a.Prefix													  --,b.Salutation
, a.FirstName												  --,b.FirstName
, a.LastName												  --,b.LastName
, a.Suffix													  --,b.Suffix
, a.address1_line1											  --,b.address1_line1
, a.address1_city											  --,b.address1_city
, a.address1_stateorprovince								  --,b.address1_stateorprovince
, a.address1_postalcode										  --,b.address1_postalcode
, a.address1_country										  --,b.address1_country
, a.telephone1												  --,b.telephone1
, a.emailaddress1											  --,b.emailaddress1
, a.contactid												  
, LoadType	
FROM [dbo].[vwCRMLoad_Contact_Std_Prep] a
JOIN prodcopy.vw_contact b ON a.contactid = b.contactID
LEFT JOIN dbo.vw_KeyAccounts k ON CAST(k.ssbid AS NVARCHAR(100)) = a.new_ssbcrmsystemcontactid
WHERE LoadType = 'Update'
AND k.ssbid IS NULL
AND (
a.Hash_FirstName !=  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(LOWER(b.FirstName))),'')) 
OR a.Hash_lastname !=  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(LOWER(b.lastname))),'')) 
OR a.Hash_suffix !=  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(LOWER(b.suffix))),'')) 
OR a.Hash_Address1_Line1 !=  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(LOWER(b.address1_line1))),'')) 
OR a.Hash_Telephone1 !=  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(LOWER(REPLACE(REPLACE(REPLACE(REPLACE(b.telephone1,')',''),'(',''),'-',''),' ','')))),''))
OR a.Hash_EmailAddress1 !=  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(LOWER(b.emailaddress1))),'')) 
)


GO
