CREATE TABLE dbo.UserProfiles(
    UserId INT NOT NULL,
    FirstName VARCHAR(30),
    MiddleName VARCHAR(30),
    LastName VARCHAR(30),
    NickName VARCHAR(30),
    DisplayName VARCHAR(30),
    DisplayPictureUrl VARCHAR(120),
    ShowPolicy TINYINT,
    CreatedTime DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    UpdatedTime DATETIMEOFFSET,
    CONSTRAINT PK_UserProfiles PRIMARY KEY CLUSTERED (
        UserId ASC
    )
)

CREATE TABLE dbo.UserAddresses(
    UserId INT NOT NULL,
    AddressInfo VARCHAR(MAX), -- 4000 is fine, MAX for unpredictable length    
    CONSTRAINT PK_Addresses PRIMARY KEY CLUSTERED (
        UserId ASC
    )
)
/* Address 
    '{          
        "info":[
            {
                "no": 1,
                "address": "abc",
                "city": "hanoi",
                "postcode": "11111",
                "show_policy": 1
            },
            {
                "no": 2,
                "address": "xyz",
                "city": "hcm",
                "postcode": "12345",
                "show_policy": 2
            }
        ]
    }'  
*/

CREATE TABLE dbo.UserCompanies(
    UserId INT NOT NULL IDENTITY(1,1),
    CompanyInfo VARCHAR(MAX), -- 4000 is fine, MAX for unpredictable length
    CONSTRAINT PK_Companies PRIMARY KEY CLUSTERED (
        UserId ASC
    )
)
/* Company 
    '{          
        "info":[
            {
                "no": 1,
                "name": "abc",
                "address": "xxxxx",
                "city": "hcm",
                "postcode": "11111",
                "is_active": 1
                "from_date": "2020-08-17",
                "to_date": "",
                "show_policy": 1
            },
            {
                "no": 2,
                "name": "bvbb",
                "address": "iiiii",
                "city": "hcm",
                "postcode": "123456",
                "is_active": 0
                "from_date": "2019-01-17",
                "to_date": "2020-08-17",
                "show_policy": 2
            }
        ]
    }'  
*/

CREATE TABLE dbo.Schools(
    UserId INT NOT NULL IDENTITY(1,1),
    SchoolInfo VARCHAR(MAX), -- 4000 is fine, MAX for unpredictable length
    CONSTRAINT PK_Schools PRIMARY KEY CLUSTERED (
        UserId ASC
    )
)
/* Company 
    '{          
        "info":[
            {
                "no": 1,
                "name": "abc",
                "address": "xxxxx",
                "city": "hcm",
                "postcode": "123456",
                "is_active": 0
                "from_date": "2019-01-17",
                "to_date": "2020-08-17",
                "show_policy": 1
            },
            {
                "no": 2,
                "name": "bvbb",
                "address": "iiiii",
                "city": "hcm",
                "postcode": "123456",
                "is_active": 0
                "from_date": "2019-01-17",
                "to_date": "2020-08-17",
                "show_policy": 2
            }
        ]
    }'  
*/

CREATE TABLE dbo.UserEntities(
    UserId INT NOT NULL,
    EntityInfo NVARCHAR(MAX), -- 4000 is fine, MAX for unpredictable length
    CONSTRAINT PK_UserEntity PRIMARY KEY CLUSTERED (
        UserId ASC
    )
)
/* EntityInfo
    B,C,D is A's Friends: 
    {
        "info" : [
            {
                "user_id": B,
                "extend_properties": ""
            },
            {
                "user_id": C,
                "extend_properties": ""
            },
            {
                "user_id": D,
                "extend_properties": ""
            }
        ]
    }
*/ 

CREATE TABLE dbo.ViewPolicy(
    Id INT NOT NULL IDENTITY(1,1),
    Name VARCHAR(20),
    CONSTRAINT PK_ViewPolicy PRIMARY KEY CLUSTERED (
        Id ASC
    )
)
/*
    1: Public
    2: Friend
    4: Private    
*/
/* show_policy
    1: Public
    2: Friend
    3: Public & Friend
    4: Private
    5: Public & Private
    6: Friend & Private
    7: Public & Friend & Private
*/