CREATE TABLE [dbo].[Contact_Custom]
(
[SSB_CRMSYSTEM_ACCT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[new_ssbcrmsystemssidwinner] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_ssbSSIDWinnerSourceSystem] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_Ids] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimCustIDs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mobilephone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[telephone2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_legacycontactid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_primaryarchticsid] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_ticketingsalesrep] [uniqueidentifier] NULL,
[kore_ticketingservicerep] [uniqueidentifier] NULL,
[new_livea_age_two_yr_incr_input_indv] [int] NULL,
[new_livea_dist_to_client_ven_mi] [int] NULL,
[new_livea_est_hh_inc_cd_100pct_inc_cd] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_livea_est_hh_inc_cd_100pct_prec_cd] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_livea_marital_status_hh_cd] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_livea_occpn_input_indv_cd] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gendercode] [int] NULL,
[kore_heritagenationality] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[haschildrencode] [int] NULL,
[new_livea_race] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_livea_gender] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_livea_haschildren] [bit] NULL,
[emailaddress2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[Contact_Custom] ADD CONSTRAINT [PK_Contact_Custom] PRIMARY KEY CLUSTERED  ([SSB_CRMSYSTEM_CONTACT_ID])
GO
