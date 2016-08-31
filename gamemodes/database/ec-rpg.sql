
--
-- Table `players`
--

CREATE TABLE IF NOT EXIST `players` (

	`ID`				INT(24)			NOT NULL 		AUTO_INCREMENT,
	`Username`			VARCHAR(24)		NOT NULL,
	`IP`				VARCHAR(16)		NOT NULL,
	`Password`			VARCHAR(65)		NOT NULL,
	`Salt`				VARCHAR(65)		NOT NULL,

	`Admin`				INT(2)			NOT NULL		DEFAULT '1',

	`GangMember`		INT(3)			NOT NULL		DEFAULT '65535',
	`GangRank`			INT(3)			NOT NULL		DEFAULT '0',

	PRIMARY KEY(`ID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 AUTO_INCREMENT = 1;



-- --------------------------------------------------------------------

--
-- Table `gangs`
--

CREATE TABLE IF NOT EXISTS `gangs` (

	`ID`				INT(24)			NOT NULL		AUTO_INCREMENT,
	`LeaderID`			INT(24)			NOT NULL		DEFAULT '1',
	`Name`				VARCHAR(50)		NOT NULL,
	`Members`			INT(24)			NOT NULL		DEFAULT '0',

	`HQ_X`				FLOAT(24)		NOT NULL		DEFAULT '0.0',
	`HQ_Y`				FLOAT(24)		NOT NULL		DEFAULT '0.0',
	`HQ_Z`				FLOAT(24)		NOT NULL		DEFAULT '0.0',

	`Active`			TINYINT(1)		NOT NULL		DEFAULT '1',

	`Ranks`				INT(3)			NOT NULL		DEFAULT '5',

	PRIMARY KEY(`ID`),
	UNIQUE(`LeaderID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 AUTO_INCREMENT = 1;

-- --------------------------------------------------------------------

--
-- Table `gangs_ranks`
--

CREATE TABLE IF NOT EXISTS `gangs_ranks` (

	`ID`				INT(24)			NOT NULL,
	`RankID`			INT(3)			NOT NULL,
	`RankName`			VARCHAR(50)		NOT NULL,

	PRIMARY KEY(`ID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 AUTO_INCREMENT = 1;
ALTER TABLE `gangs_ranks` ADD FOREIGN KEY(`ID`) REFERENCES `gangs`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE;

-- --------------------------------------------------------------------

--
-- Table `vehicles`
--

CREATE TABLE IF NOT EXISTS `vehicles` (

	`ID`				INT(24)			NOT NULL			AUTO_INCREMENT,
	`OwnerID`			INT(24)			NOT NULL			DEFAULT '65535',
	`GangID`			INT(24)			NOT NULL			DEFAULT '65535',

	`Model`				INT(3)			NOT NULL,
	`Health`			FLOAT(24)		NOT NULL			DEFAULT '1000.0',

	PRIMARY KEY(`ID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 AUTO_INCREMENT = 1;

-- --------------------------------------------------------------------

--
-- Table `vehicles_positions`
--

CREATE TABLE IF NOT EXISTS `vehicles_positions` (

	`ID`				INT(24)			NOT NULL,
	`PositionX`			FLOAT(24)		NOT NULL			DEFAULT '0.0',
	`PositionY` 		FLOAT(24)		NOT NULL			DEFAULT '0.0',
	`PositionZ` 		FLOAT(24)		NOT NULL			DEFAULT '0.0',
	`PositionA` 		FLOAT(24)		NOT NULL			DEFAULT '0.0',

	`Interior`			INT(24)			NOT NULL			DEFAULT '0',
	`VirtualWorld`		INT(24)			NOT NULL			DEFAULT '0',

	PRIMARY KEY(`ID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 AUTO_INCREMENT = 1;
ALTER TABLE `vehicles_positions` ADD FOREIGN KEY (`ID`) REFERENCE `vehicles`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE;

-- --------------------------------------------------------------------

--
-- Table `vehicles_colors`
--

CREATE TABLE IF NOT EXISTS `vehicles_colors` (

	`ID`				INT(24)			NOT NULL,
	`Color1`			INT(24)			NOT NULL 			DEFAULT '0',
	`Color2`			INT(24)			NOT NULL			DEFAULT '0',

	PRIMARY KEY(`ID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 AUTO_INCREMENT = 1;
ALTER TABLE `vehicles_colors` ADD FOREIGN KEY (`ID`) REFERENCE `vehicles`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE;

-- --------------------------------------------------------------------

--
-- Table `vehicles_parameters`
--

CREATE TABLE IF NOT EXISTS `vehicles_parameters` (

	`ID`				INT(24)			NOT NULL,
	`Engine`			TINYINT(1)		NOT NULL			DEFAULT '0',
	`Lights`			TINYINT(1)		NOT NULL			DEFAULT '0',
	`Alarm`				TINYINT(1)		NOT NULL			DEFAULT '0',
	`Lock`				TINYINT(1)		NOT NULL			DEFAULT '0',
	`Hood`				TINYINT(1)		NOT NULL			DEFAULT '0',
	`Trunk`				TINYINT(1)		NOT NULL			DEFAULT '0',
	`Objective`			TINYINT(1)		NOT NULL			DEFAULT '0',

	PRIMARY KEY(`ID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 AUTO_INCREMENT = 1;
ALTER TABLE `vehicles_parameters` ADD FOREIGN KEY (`ID`) REFERENCE `vehicles`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE;

-- --------------------------------------------------------------------

--
-- Table `vehicles_damage`
--

CREATE TABLE IF NOT EXISTS `vehicles_damage` (

	`ID`				INT(24)			NOT NULL,
	`DamagePanels`		BIT(4)			NOT NULL			DEFAULT '0000',
	`DamageDoors`		BIT(4)			NOT NULL			DEFAULT '0000',
	`DamageLights`		BIT(4)			NOT NULL			DEFAULT '0000',
	`DamageTires`		BIT(4)			NOT NULL			DEFAULT '0000',

	PRIMARY KEY(`ID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 AUTO_INCREMENT = 1;
ALTER TABLE `vehicles_damage` ADD FOREIGN KEY (`ID`) REFERENCE `vehicles`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE;

-- --------------------------------------------------------------------