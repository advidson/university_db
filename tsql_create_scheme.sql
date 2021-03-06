﻿USE [master]
GO

/****** Object:  Database [govLibrary]    Script Date: 08.10.2015 22:34:13 ******/
CREATE DATABASE [govLibrary]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'govLibrary', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\govLibrary.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'govLibrary_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\govLibrary_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [govLibrary] SET COMPATIBILITY_LEVEL = 120
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [govLibrary].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [govLibrary] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [govLibrary] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [govLibrary] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [govLibrary] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [govLibrary] SET ARITHABORT OFF 
GO

ALTER DATABASE [govLibrary] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [govLibrary] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [govLibrary] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [govLibrary] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [govLibrary] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [govLibrary] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [govLibrary] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [govLibrary] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [govLibrary] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [govLibrary] SET  DISABLE_BROKER 
GO

ALTER DATABASE [govLibrary] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [govLibrary] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [govLibrary] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [govLibrary] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [govLibrary] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [govLibrary] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [govLibrary] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [govLibrary] SET RECOVERY FULL 
GO

ALTER DATABASE [govLibrary] SET  MULTI_USER 
GO

ALTER DATABASE [govLibrary] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [govLibrary] SET DB_CHAINING OFF 
GO

ALTER DATABASE [govLibrary] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [govLibrary] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

ALTER DATABASE [govLibrary] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [govLibrary] SET  READ_WRITE 
GO


