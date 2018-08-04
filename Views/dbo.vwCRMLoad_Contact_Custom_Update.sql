SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/**************************************
Updated By: Caeleon Work
Update Date: 2018-06-11
Update Notes: Added following columns
 b.kore_ticketingsalesrep
, b.kore_ticketingservicerep
, b.new_livea_race
, b.new_livea_gender
, b.new_livea_age_two_yr_incr_input_indv
, b.new_livea_dist_to_client_ven_mi
, b.new_livea_est_hh_inc_cd_100pct_inc_cd
, b.new_livea_est_hh_inc_cd_100pct_prec_cd
, b.new_livea_marital_status_hh_cd
, b.new_livea_occpn_input_indv_cd
, b.new_livea_haschildren
*****************************************/





CREATE   VIEW [dbo].[vwCRMLoad_Contact_Custom_Update]
AS

SELECT  z.[crm_id] contactid
, b.new_ssbcrmsystemssidwinner																		-- ,c.new_ssbcrmsystemssidwinner
,b.new_ssbSSIDWinnerSourceSystem																	-- ,c.new_ssbssidwinnersourcesystem
--, TM_Ids [new_ssbcrmsystemarchticsids]															-- ,c.
, DimCustIDs new_ssbcrmsystemdimcustomerids															-- --,c.new_ssbcrmsystemdimcustomerids
, b.AccountId [kore_archticsids]																	-- ,c.[kore_archticsids]
, b.[kore_primaryarchticsid]																		-- ,c.[kore_primaryarchticsid]
--, b.AccountId [str_number]																		-- ,c.str_number										--updateme for STR clients
, z.EmailPrimary AS emailaddress1																	-- ,c.emailaddress1
, b.mobilephone																						-- ,c.mobilephone
, b.telephone2																						-- ,c.telephone2
																									-- 
, ISNULL(cca.CustomfieldBit1,0) AS new_CustomfieldBit1												-- ,c.new_CustomfieldBit1
, ISNULL(cca.CustomfieldBit2,0) AS new_CustomfieldBit2												-- ,c.new_CustomfieldBit2
, ISNULL(cca.CustomfieldBit3,0) AS new_CustomfieldBit3												-- ,c.new_CustomfieldBit3
, ISNULL(cca.CustomfieldBit4,0) AS new_CustomfieldBit4												-- ,c.new_CustomfieldBit4
, ISNULL(cca.CustomfieldBit5,0) AS new_CustomfieldBit5												-- ,c.new_CustomfieldBit5
																									-- 
, b.new_legacycontactid																				-- ,c.new_legacycontactid
, CASE WHEN a.crm_id IS NOT NULL THEN a.crm_id ELSE NULL END AS parentcustomerid					-- ,c.parentcustomerid
, CASE WHEN a.crm_id IS NOT NULL THEN 'account' ELSE NULL END AS parentcustomeridtype
, b.kore_ticketingsalesrep
, b.kore_ticketingservicerep
, b.new_livea_race
, b.new_livea_gender
, b.new_livea_age_two_yr_incr_input_indv
, b.new_livea_dist_to_client_ven_mi
, b.new_livea_est_hh_inc_cd_100pct_inc_cd
, b.new_livea_est_hh_inc_cd_100pct_prec_cd
, b.new_livea_marital_status_hh_cd
, b.new_livea_occpn_input_indv_cd
, b.new_livea_haschildren

--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_ssbcrmsystemssidwinner)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_ssbcrmsystemssidwinner AS VARCHAR(MAX)))),'')) 							   then 1 else 0 end as new_ssbcrmsystemssidwinner
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_ssbSSIDWinnerSourceSystem)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_ssbSSIDWinnerSourceSystem AS VARCHAR(MAX)))),'')) 						   then 1 else 0 end as new_ssbSSIDWinnerSourceSystem
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.AccountId)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[kore_archticsids] AS VARCHAR(MAX)))),''))														   then 1 else 0 end as [kore_archticsids]
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.mobilephone)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[mobilephone] AS NVARCHAR(MAX)))),''))															   then 1 else 0 end as [mobilephone]
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.telephone2)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[telephone2] AS NVARCHAR(MAX)))),''))															   then 1 else 0 end as [telephone2]
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.[kore_primaryarchticsid])),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[kore_primaryarchticsid] AS NVARCHAR(MAX)))),''))									   then 1 else 0 end as [kore_primaryarchticsid]
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(cca.CustomfieldBit1)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_CustomfieldBit1] AS BIT))),''))														   then 1 else 0 end as [new_CustomfieldBit1]
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(cca.CustomfieldBit2)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_CustomfieldBit2] AS BIT))),''))														   then 1 else 0 end as [new_CustomfieldBit2]
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(cca.CustomfieldBit3)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_CustomfieldBit3] AS BIT))),''))														   then 1 else 0 end as [new_CustomfieldBit3]
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(cca.CustomfieldBit4)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_CustomfieldBit4] AS BIT))),''))														   then 1 else 0 end as [new_CustomfieldBit4]
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(cca.CustomfieldBit5)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_CustomfieldBit5] AS BIT))),''))														   then 1 else 0 end as [new_CustomfieldBit5]
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_legacycontactid)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_legacycontactid] AS NVARCHAR(MAX)))),''))											   then 1 else 0 end as [new_legacycontactid]
--, case when HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CASE WHEN a.crm_id IS NOT NULL THEN a.crm_id ELSE NULL END )),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.parentcustomerid AS NVARCHAR(MAX)))),''))		   then 1 else 0 end as parentcustomerid



-- SELECT *
-- SELECT COUNT(*) 
FROM dbo.[Contact_Custom] b 
INNER JOIN dbo.Contact z ON b.SSB_CRMSYSTEM_CONTACT_ID = z.[SSB_CRMSYSTEM_CONTACT_ID]
LEFT JOIN dbo.contact_custom_azure cca
ON cca.ssb_crmsystem_contact_id = z.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN  prodcopy.vw_contact c ON z.[crm_id] = c.contactID
--INNER JOIN dbo.CRMLoad_Contact_ProcessLoad_Criteria pl ON b.SSB_CRMSYSTEM_CONTACT_ID = pl.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN dbo.vw_KeyAccounts k ON CAST(k.SSBID AS NVARCHAR(100)) = z.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN dbo.Account a ON z.SSB_CRMSYSTEM_ACCT_ID = a.SSB_CRMSYSTEM_ACCT_ID AND a.SSB_CRMSYSTEM_ACCT_ID != a.crm_id
WHERE 1=1
AND z.[SSB_CRMSYSTEM_CONTACT_ID] <> z.[crm_id]
AND k.ssbid IS NULL
AND  (1=2 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_ssbcrmsystemssidwinner)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_ssbcrmsystemssidwinner AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_ssbSSIDWinnerSourceSystem)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_ssbSSIDWinnerSourceSystem AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.AccountId)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[kore_archticsids] AS VARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.mobilephone)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[mobilephone] AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.telephone2)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[telephone2] AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.[kore_primaryarchticsid])),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[kore_primaryarchticsid] AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(cca.CustomfieldBit1)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_CustomfieldBit1] AS BIT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(cca.CustomfieldBit2)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_CustomfieldBit2] AS BIT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(cca.CustomfieldBit3)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_CustomfieldBit3] AS BIT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(cca.CustomfieldBit4)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_CustomfieldBit4] AS BIT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(cca.CustomfieldBit5)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_CustomfieldBit5] AS BIT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_legacycontactid)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[new_legacycontactid] AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CASE WHEN a.crm_id IS NOT NULL THEN a.crm_id ELSE NULL END )),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.parentcustomerid AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.kore_ticketingsalesrep)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.kore_ticketingsalesrep AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.kore_ticketingservicerep)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.kore_ticketingservicerep AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_livea_race)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_livea_race AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_livea_gender)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_livea_gender AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_livea_age_two_yr_incr_input_indv)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_livea_age_two_yr_incr_input_indv AS INT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_livea_dist_to_client_ven_mi)),0) )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_livea_dist_to_client_ven_mi AS INT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_livea_est_hh_inc_cd_100pct_inc_cd)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_livea_est_hh_inc_cd_100pct_inc_cd AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_livea_est_hh_inc_cd_100pct_prec_cd)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_livea_est_hh_inc_cd_100pct_prec_cd AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_livea_marital_status_hh_cd)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_livea_marital_status_hh_cd AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_livea_occpn_input_indv_cd)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_livea_occpn_input_indv_cd AS NVARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.new_livea_haschildren)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_livea_haschildren AS NVARCHAR(MAX)))),''))



	)

GO
