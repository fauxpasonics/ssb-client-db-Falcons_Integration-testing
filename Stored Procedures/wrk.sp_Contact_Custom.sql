SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*****************************************
Updated By: Caeleon Work
Update Date: 2018-06-11
Update Notes: Added LiveA column logic, and Sales Rep
******************************************/


CREATE   PROCEDURE [wrk].[sp_Contact_Custom]
AS
MERGE INTO dbo.Contact_Custom Target
USING dbo.Contact source
ON source.[SSB_CRMSYSTEM_CONTACT_ID] = Target.[SSB_CRMSYSTEM_CONTACT_ID]
WHEN NOT MATCHED BY TARGET THEN
    INSERT
    (
        [SSB_CRMSYSTEM_ACCT_ID],
        [SSB_CRMSYSTEM_CONTACT_ID]
    )
    VALUES
    (source.[SSB_CRMSYSTEM_ACCT_ID], source.[SSB_CRMSYSTEM_CONTACT_ID])
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

EXEC dbo.sp_CRMProcess_ConcatIDs 'Contact';


--UPDATE a
--SET SeasonTicket_Years = recent.SeasonTicket_Years
----SELECT *
--FROM dbo.[Contact_Custom] a
--INNER JOIN dbo.CRMProcess_DistinctContacts recent ON [recent].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]

UPDATE a
SET a.new_ssbcrmsystemssidwinner = b.[SSID],
    a.new_ssbSSIDWinnerSourceSystem = b.SourceSystem,
    mobilephone = b.PhoneCell,
    telephone2 = b.PhoneHome,
	emailaddress2 = b.EmailOne

FROM [dbo].Contact_Custom a
    INNER JOIN dbo.[vwCompositeRecord_ModAcctID] b
        ON b.[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID];


UPDATE dbo.Contact_Custom
SET new_legacycontactid = CASE
                              WHEN r.dimcustomerid IS NULL THEN
                                  NULL
                              ELSE
                                  ssid
                          END
FROM dbo.Contact_Custom cc
    LEFT JOIN Falcons.mdm.PrimaryFlagRanking_Contact r WITH (NOLOCK)
        ON cc.SSB_CRMSYSTEM_CONTACT_ID = r.SSB_CRMSYSTEM_CONTACT_ID
           AND r.sourcesystem = 'Legacy_Dynamics_Contact'
           AND ss_ranking = 1;

UPDATE dbo.Contact_Custom
SET [kore_primaryarchticsid] = CASE
                                   WHEN r.dimcustomerid IS NULL THEN
                                       NULL
                                   ELSE
                                       LEFT(r.ssid, CHARINDEX(':', r.ssid, 1) - 1)
                               END
FROM dbo.Contact_Custom cc
    LEFT JOIN Falcons.mdm.PrimaryFlagRanking_Contact r WITH (NOLOCK)
        ON cc.SSB_CRMSYSTEM_CONTACT_ID = r.SSB_CRMSYSTEM_CONTACT_ID
           AND ranking = 1
           AND r.sourcesystem IN ( 'TM', 'TM-Falcons_PSL' );





UPDATE dbo.Contact_Custom
SET AccountID = LEFT(AccountID, CHARINDEX(',', AccountID, 245) - 1)
FROM dbo.Contact_Custom
WHERE LEN(AccountID) > 255;

EXEC dbo.sp_CRMLoad_Contact_ProcessLoad_Criteria;




SELECT ma.SSB_CRMSYSTEM_ACCT_ID,
       MAX(ExtAttribute2) extattribute2
INTO #tempacctmatchkey
FROM dbo.vwDimCustomer_ModAcctId ma
    INNER JOIN dbo.Contact_Custom cc
        ON cc.SSB_CRMSYSTEM_ACCT_ID = ma.SSB_CRMSYSTEM_ACCT_ID
WHERE ExtAttribute2 IS NOT NULL
GROUP BY ma.SSB_CRMSYSTEM_ACCT_ID;

UPDATE dbo.Account_Custom
SET new_ssb_matchkey = extattribute2
FROM Account_Custom cc
    INNER JOIN #tempacctmatchkey t
        ON t.SSB_CRMSYSTEM_ACCT_ID = cc.SSB_CRMSYSTEM_ACCT_ID;

/*******************************************************
LiveAnalytics
*********************************************************/
IF OBJECT_ID('tempdb..#LiveA') IS NOT NULL
    DROP TABLE #LiveA;

SELECT CASE
           WHEN dc.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN
               CONVERT(VARCHAR(36), dc.SSB_CRMSYSTEM_CONTACT_ID)
           ELSE
               lac.acct_id
       END AS SSBID,
       CASE
           WHEN age_two_yr_incr_input_indv > 0 THEN
               age_two_yr_incr_input_indv
           ELSE
               NULL
       END AS [new_livea_age_two_yr_incr_input_indv],
       CASE
           WHEN race_cd = 'A' THEN
               'Asian'
           WHEN race_cd = 'B' THEN
               'Black'
           WHEN race_cd = 'H' THEN
               'Hispanic'
           WHEN race_cd = 'W' THEN
               'White/Other'
           ELSE
               NULL
       END AS new_livea_race,
       CASE
           WHEN presence_chldn_new_flg = 'Y' THEN
               1
		   WHEN lac.presence_chldn_new_flg = 'N' THEN
			   0
           ELSE
               NULL
       END AS new_livea_haschildren,
       CASE
           WHEN est_hh_inc_cd_100pct_inc_cd = 1 THEN
               'Less than $15,000'
           WHEN est_hh_inc_cd_100pct_inc_cd = 2 THEN
               '$15,000 - $19,999'
           WHEN est_hh_inc_cd_100pct_inc_cd = 3 THEN
               '$20,000 - $29,999'
           WHEN est_hh_inc_cd_100pct_inc_cd = 4 THEN
               '$30,000 - $39,999'
           WHEN est_hh_inc_cd_100pct_inc_cd = 5 THEN
               '$40,000 - $49,999'
           WHEN est_hh_inc_cd_100pct_inc_cd = 6 THEN
               '$50,000 - $74,999'
           WHEN est_hh_inc_cd_100pct_inc_cd = 7 THEN
               '$75,000 - $99,999'
           WHEN est_hh_inc_cd_100pct_inc_cd = 8 THEN
               '$100,000 - $124,999'
           WHEN est_hh_inc_cd_100pct_inc_cd = 9 THEN
               'Greater than $124,999'
           ELSE
               NULL
       END AS [new_livea_est_hh_inc_cd_100pct_inc_cd],
       CASE
           WHEN est_hh_inc_cd_100pct_prec_cd = '3' THEN
               'Household Level'
           WHEN est_hh_inc_cd_100pct_prec_cd = '4' THEN
               'Household Inferred Level'
           WHEN est_hh_inc_cd_100pct_prec_cd = 'A' THEN
               'Zip+4 Level (approx 4 households)'
           WHEN est_hh_inc_cd_100pct_prec_cd = 'G' THEN
               'Zip Level (approx 3,000 households)'
           ELSE
               NULL
       END AS [new_livea_est_hh_inc_cd_100pct_prec_cd],
       CASE
           WHEN marital_status_hh_cd = 'M' THEN
               'Married'
           WHEN marital_status_hh_cd = 'S' THEN
               'Single'
           WHEN marital_status_hh_cd = 'A' THEN
               'Inferred Married'
           WHEN marital_status_hh_cd = 'B' THEN
               'Inferred Single'
           ELSE
               NULL
       END AS [new_livea_marital_status_hh_cd],
       CASE
           WHEN occpn_input_indv_cd = '1' THEN
               'Professional/Technical'
           WHEN occpn_input_indv_cd = '2' THEN
               'Administration/Managerial'
           WHEN occpn_input_indv_cd = '3' THEN
               'Sales/Service'
           WHEN occpn_input_indv_cd = '4' THEN
               'Clerical/White Collar'
           WHEN occpn_input_indv_cd = '5' THEN
               'Craftsman/Blue Collar'
           WHEN occpn_input_indv_cd = '6' THEN
               'Student'
           WHEN occpn_input_indv_cd = '7' THEN
               'Homemaker'
           WHEN occpn_input_indv_cd = '8' THEN
               'Retired'
           WHEN occpn_input_indv_cd = '9' THEN
               'Farmer'
           WHEN occpn_input_indv_cd = 'A' THEN
               'Military'
           WHEN occpn_input_indv_cd = 'B' THEN
               'Religious'
           WHEN occpn_input_indv_cd = 'C' THEN
               'Self Employed'
           WHEN occpn_input_indv_cd = 'D' THEN
               'Self Employed - Professional/Technical'
           WHEN occpn_input_indv_cd = 'E' THEN
               'Self Employed - Administration/Managerial'
           WHEN occpn_input_indv_cd = 'F' THEN
               'Self Employed - Sales/Service'
           WHEN occpn_input_indv_cd = 'G' THEN
               'Self Employed - Clerical/White Collar'
           WHEN occpn_input_indv_cd = 'H' THEN
               'Self Employed - Craftsman/Blue Collar'
           WHEN occpn_input_indv_cd = 'I' THEN
               'Self Employed - Student'
           WHEN occpn_input_indv_cd = 'J' THEN
               'Self Employed - Homemaker'
           WHEN occpn_input_indv_cd = 'K' THEN
               'Self Employed - Retired'
           WHEN occpn_input_indv_cd = 'L' THEN
               'Self Employed - Other'
           WHEN occpn_input_indv_cd = 'V' THEN
               'Educator'
           WHEN occpn_input_indv_cd = 'W' THEN
               'Financial Professional'
           WHEN occpn_input_indv_cd = 'X' THEN
               'Legal Professional'
           WHEN occpn_input_indv_cd = 'Y' THEN
               'Medical Professional'
           WHEN occpn_input_indv_cd = 'Z' THEN
               'Other'
           ELSE
               NULL
       END AS [new_livea_occpn_input_indv_cd],
       CASE
           WHEN dist_to_client_ven_mi > 0 THEN
               dist_to_client_ven_mi
           ELSE
               NULL
       END AS [new_livea_dist_to_client_ven_mi],
       CASE
           WHEN gndr_input_indv_cd = 'F' THEN
               'Female'
           WHEN gndr_input_indv_cd = 'M' THEN
               'Male'
           ELSE
               NULL
       END AS new_livea_gender
INTO #LiveA
FROM Falcons.ods.LiveAnalytics_Customer lac
    LEFT JOIN dbo.vwDimCustomer_ModAcctId dc
        ON CONVERT(NVARCHAR(100), dc.AccountId) = lac.acct_id
           AND dc.SourceSystem = 'TM'
           AND lac.cust_source_cd != 'Falcons_Form_Prospect'
           AND dc.CustomerType = 'Primary';

UPDATE c
SET c.new_livea_age_two_yr_incr_input_indv = a.new_livea_age_two_yr_incr_input_indv,
    c.new_livea_dist_to_client_ven_mi = a.new_livea_dist_to_client_ven_mi,
    c.new_livea_est_hh_inc_cd_100pct_inc_cd = a.new_livea_est_hh_inc_cd_100pct_inc_cd,
    c.new_livea_est_hh_inc_cd_100pct_prec_cd = a.new_livea_est_hh_inc_cd_100pct_prec_cd,
    c.new_livea_marital_status_hh_cd = a.new_livea_marital_status_hh_cd,
    c.new_livea_occpn_input_indv_cd = a.new_livea_occpn_input_indv_cd,
    c.new_livea_gender = a.new_livea_gender,
    c.new_livea_race = a.new_livea_race,
    c.new_livea_haschildren = a.new_livea_haschildren
FROM dbo.Contact_Custom c
    JOIN #LiveA a
        ON a.SSBID = c.SSB_CRMSYSTEM_CONTACT_ID;


/**********************************************************
Sales Rep
***********************************************************/

IF OBJECT_ID('tempdb..#UserTemp') IS NOT NULL
    DROP TABLE #UserTemp;
SELECT tmcr.acct_id,
       tmcr.rep_user_id,
       ma.SSB_CRMSYSTEM_CONTACT_ID,
       tmcr.acct_rep_type,
       tmcr.acct_rep_type_name,
       tmcr.rep_full_name,
       tmcr.rep_name_first,
       tmcr.rep_name_last,
       ISNULL(ISNULL(su.systemuserid, suname.systemuserid), suemail.systemuserid) AS systemuserid,
       ma.SSCreatedDate,
       ma.SSB_CRMSYSTEM_PRIMARY_FLAG
INTO #UserTemp
FROM Falcons.ods.TM_CustRep tmcr
    INNER JOIN dbo.vwDimCustomer_ModAcctId ma
        ON ma.AccountId = tmcr.acct_id
           AND ma.SourceSystem = 'tm'
           AND ma.CustomerType = 'primary'
    LEFT JOIN Falcons_Reporting.Prodcopy.SystemUser su
        ON su.kore_ticketsystemuserid = tmcr.rep_user_id --add back in once prodcopy is updated
    LEFT JOIN Falcons_Reporting.Prodcopy.SystemUser suname
        ON suname.fullname = REPLACE(REPLACE(tmcr.rep_full_name, ' - INBOUND', ''), ' - OUTBOUND', '')
    LEFT JOIN Falcons_Reporting.Prodcopy.SystemUser suemail
        ON ISNULL(suemail.internalemailaddress, '') = ISNULL(tmcr.rep_email_addr, '')
           AND ISNULL(suemail.internalemailaddress, '') != ''
WHERE tmcr.acct_rep_type_name IN ( 'Service Executive', 'Account Manager' );


IF OBJECT_ID('tempdb..#ranks') IS NOT NULL
    DROP TABLE #ranks;
SELECT SSB_CRMSYSTEM_CONTACT_ID,
       acct_rep_type_name,
       systemuserid,
       ROW_NUMBER() OVER (PARTITION BY SSB_CRMSYSTEM_CONTACT_ID,
                                       acct_rep_type_name
                          ORDER BY SSB_CRMSYSTEM_PRIMARY_FLAG DESC,
                                   SSCreatedDate DESC
                         ) xrank
INTO #ranks
FROM #UserTemp
WHERE systemuserid IS NOT NULL;

IF OBJECT_ID('tempdb..#salesrep') IS NOT NULL
    DROP TABLE #salesrep;
SELECT SSB_CRMSYSTEM_CONTACT_ID,
       systemuserid kore_ticketingsalesrep
INTO #salesrep
FROM #ranks
WHERE acct_rep_type_name = 'Account Manager'
      AND xrank = 1;

IF OBJECT_ID('tempdb..#servicerep') IS NOT NULL
    DROP TABLE #servicerep;
SELECT SSB_CRMSYSTEM_CONTACT_ID,
       systemuserid kore_ticketingservicerep
INTO #servicerep
FROM #ranks
WHERE acct_rep_type_name = 'Service Executive'
      AND xrank = 1;

UPDATE c
SET c.kore_ticketingsalesrep = sr.kore_ticketingsalesrep
FROM dbo.Contact_Custom c
    JOIN #salesrep sr
        ON sr.SSB_CRMSYSTEM_CONTACT_ID = c.SSB_CRMSYSTEM_CONTACT_ID;

UPDATE c
SET c.kore_ticketingservicerep = s.kore_ticketingservicerep
FROM dbo.Contact_Custom c
    JOIN #servicerep s
        ON s.SSB_CRMSYSTEM_CONTACT_ID = c.SSB_CRMSYSTEM_CONTACT_ID;

GO
