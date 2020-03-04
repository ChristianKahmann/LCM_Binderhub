CREATE DATABASE `ilcm` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;


UPDATE mysql.user SET authentication_string = PASSWORD('ilcm') WHERE user  = 'root';
UPDATE mysql.user SET plugin='mysql_native_password' WHERE User='root';
FLUSH PRIVILEGES;

USE ilcm;



CREATE TABLE `Annotations` (
  `anno_id` varchar(45) DEFAULT NULL,
  `User` varchar(45) DEFAULT NULL,
  `dataset` varchar(50) NOT NULL,
  `id` int(11) NOT NULL,
  `from` int(11) NOT NULL,
  `to` int(11) NOT NULL,
  `Annotation` varchar(45) NOT NULL,
  `color` varchar(45) DEFAULT NULL,
  `Annotation_Date` varchar(20) DEFAULT NULL,
  `Anno_set` varchar(45) DEFAULT NULL,
  `collection` varchar(45) NOT NULL,
  `global_doc_id` int(11) DEFAULT NULL,
  `text` mediumtext DEFAULT NULL,
  `document_annotation` varchar(20) CHARACTER SET big5 DEFAULT 'FALSE',
  PRIMARY KEY (`dataset`,`id`,`from`,`to`,`Annotation`,`collection`),
  KEY `sekundary` (`anno_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



CREATE TABLE `annotations_classification` (
  `dataset` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `doc_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `project` varchar(45) COLLATE utf8mb4_bin NOT NULL,
  `category` varchar(45) COLLATE utf8mb4_bin NOT NULL,
  `status` varchar(45) COLLATE utf8mb4_bin DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `document_annotation` varchar(45) COLLATE utf8mb4_bin DEFAULT '"FALSE"',
  PRIMARY KEY (`dataset`,`doc_id`,`project`,`sid`,`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



CREATE TABLE `Collections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `dataset` varchar(50) DEFAULT NULL,
  `created` varchar(45) DEFAULT NULL,
  `query` varchar(5000) DEFAULT NULL,
  `number of documents` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8mb4;



CREATE TABLE `documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dataset` varchar(50) NOT NULL,
  `id_doc` int(11) NOT NULL,
  `title` varchar(500) DEFAULT NULL,
  `body` longtext DEFAULT NULL,
  `date` date DEFAULT NULL,
  `token` int(11) DEFAULT NULL,
  `language` varchar(45) DEFAULT NULL,
  `entities` mediumtext DEFAULT NULL,
  `collections` mediumtext DEFAULT NULL,
  `mde1` varchar(500) DEFAULT NULL,
  `mde2` varchar(500) DEFAULT NULL,
  `mde3` varchar(500) DEFAULT NULL,
  `mde4` varchar(500) DEFAULT NULL,
  `mde5` varchar(500) DEFAULT NULL,
  `mde6` varchar(500) DEFAULT NULL,
  `mde7` varchar(500) DEFAULT NULL,
  `mde8` varchar(500) DEFAULT NULL,
  `mde9` varchar(500) DEFAULT NULL,
  `last_modified` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`,`dataset`,`id_doc`),
  KEY `index2` (`dataset`,`id_doc`),
  KEY `index3` (`id_doc`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;





CREATE TABLE `meta_date` (
  `dataset` varchar(50) NOT NULL,
  `date` varchar(45) NOT NULL,
  PRIMARY KEY (`dataset`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `meta_token` (
  `dataset` varchar(50) NOT NULL,
  `token` int(11) NOT NULL,
  PRIMARY KEY (`dataset`,`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `metadata_names` (
  `dataset` varchar(50) CHARACTER SET utf8mb4 NOT NULL,
  `mde1` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `mde2` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `mde3` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `mde4` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `mde5` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `mde6` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `mde7` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `mde8` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `mde9` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`dataset`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `meta_mde1` (
  `dataset` varchar(50) NOT NULL,
  `mde1` varchar(100) NOT NULL,
  PRIMARY KEY (`dataset`,`mde1`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `meta_mde2` (
  `dataset` varchar(50) NOT NULL,
  `mde2` varchar(100) NOT NULL,
  PRIMARY KEY (`dataset`,`mde2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `meta_mde3` (
  `dataset` varchar(50) NOT NULL,
  `mde3` varchar(100) NOT NULL,
  PRIMARY KEY (`dataset`,`mde3`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `meta_mde4` (
  `dataset` varchar(50) NOT NULL,
  `mde4` varchar(100) NOT NULL,
  PRIMARY KEY (`dataset`,`mde4`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `meta_mde5` (
  `dataset` varchar(50) NOT NULL,
  `mde5` varchar(100) NOT NULL,
  PRIMARY KEY (`dataset`,`mde5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `meta_mde6` (
  `dataset` varchar(50) NOT NULL,
  `mde6` varchar(100) NOT NULL,
  PRIMARY KEY (`dataset`,`mde6`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `meta_mde7` (
  `dataset` varchar(50) NOT NULL,
  `mde7` varchar(100) NOT NULL,
  PRIMARY KEY (`dataset`,`mde7`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `meta_mde8` (
  `dataset` varchar(50) NOT NULL,
  `mde8` varchar(100) NOT NULL,
  PRIMARY KEY (`dataset`,`mde8`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `meta_mde9` (
  `dataset` varchar(50) NOT NULL,
  `mde9` varchar(100) NOT NULL,
  PRIMARY KEY (`dataset`,`mde9`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



CREATE TABLE `token` (
  `dataset` varchar(50) NOT NULL,
  `id` int(11) NOT NULL DEFAULT 0,
  `sid` int(11) NOT NULL,
  `tid` int(11) NOT NULL,
  `word` varchar(1000) DEFAULT NULL,
  `lemma` varchar(1000) DEFAULT NULL,
  `pos` varchar(45) DEFAULT NULL,
  `entity` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`dataset`,`id`,`sid`,`tid`),
  KEY `index2` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'ilcm' WITH GRANT OPTION; FLUSH PRIVILEGES




























