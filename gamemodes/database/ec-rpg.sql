
--
-- Table `players`
--

CREATE TABLE IF NOT EXIST `players` (

	`ID`			INT(24)			NOT NULL 		AUTO_INCREMENT,
	`Username`		VARCHAR(24)		NOT NULL,
	`IP`			VARCHAR(16)		NOT NULL,
	`Password`		VARCHAR(65)		NOT NULL,
	`Salt`			VARCHAR(65)		NOT NULL,

	`Admin`			INT(2)			NOT NULL		DEFAULT '1',

	`GangMember`	INT(3)			NOT NULL		DEFAULT '65535',
	`GangRank`		INT(3)			NOT NULL		DEFAULT '0',

	PRIMARY KEY(`ID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 AUTO_INCREMENT = 1;

-- --------------------------------------------------------------------

--
-- Table `gangs`
--

CREATE TABLE IF NOT EXISTS `gangs` (

	`ID`		INT(24)			NOT NULL		AUTO_INCREMENT,
	`LeaderID`	INT(24)			NOT NULL		DEFAULT '1',
	`Name`		VARCHAR(50)		NOT NULL,
	`Members`	INT(24)			NOT NULL		DEFAULT '0',

	`HQ_X`		FLOAT(24)		NOT NULL		DEFAULT '0.0',
	`HQ_Y`		FLOAT(24)		NOT NULL		DEFAULT '0.0',
	`HQ_Z`		FLOAT(24)		NOT NULL		DEFAULT '0.0',

	`Active`	TINYINT(1)		NOT NULL		DEFAULT '1',

	`Ranks`		INT(3)			NOT NULL		DEFAULT '5',

	PRIMARY KEY(`ID`),
	UNIQUE(`LeaderID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 AUTO_INCREMENT = 1;

-- --------------------------------------------------------------------

--
-- Table `gangs_ranks`
--

CREATE TABLE IF NOT EXISTS `gangs_ranks` (

	`ID`		INT(24)			NOT NULL,
	`RankID`	INT(3)			NOT NULL,
	`RankName`	VARCHAR(50)		NOT NULL,

	PRIMARY KEY(`ID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 AUTO_INCREMENT = 1;
ALTER TABLE `gangs_ranks` ADD FOREIGN KEY(`ID`) REFERENCES `gangs`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE;
