
CREATE TABLE [Contacto]
( 
	[contactoId]         int  NOT NULL  IDENTITY ( 10000,1 ) ,
	[nombre]             varchar(30) COLLATE Modern_Spanish_CI_AS  NULL ,
	[apellido]           varchar(30) COLLATE Modern_Spanish_CI_AS  NULL ,
	[email]              varchar(30) COLLATE Modern_Spanish_CI_AS  NULL ,
	[telefono]           varchar(15) COLLATE Modern_Spanish_CI_AS  NULL 
)
go

ALTER TABLE [Contacto]
	ADD CONSTRAINT [XPKContacto] PRIMARY KEY  CLUSTERED ([contactoId] ASC)
go

CREATE TABLE [Direccion]
( 
	[inmId]              int  NULL ,
	[direccionId]        int  NOT NULL  IDENTITY ( 100,1 ) ,
	[referencia]         varchar(max) COLLATE Modern_Spanish_CI_AS  NULL ,
	[numero]             smallint  NULL ,
	[nombre]             varchar(50) COLLATE Modern_Spanish_CI_AS  NULL ,
	[tipo_direccion]     char(1) COLLATE Modern_Spanish_CI_AS  NULL ,
	[gps_latitud]        varchar(80) COLLATE Modern_Spanish_CI_AS  NULL ,
	[gps_longitud]       varchar(80) COLLATE Modern_Spanish_CI_AS  NULL ,
	[ubicacionId]        int  NULL 
)
go

ALTER TABLE [Direccion]
	ADD CONSTRAINT [XPKDireccion] PRIMARY KEY  CLUSTERED ([direccionId] ASC)
go

CREATE TABLE [Inmueble]
( 
	[contactoId]         int  NULL ,
	[inmId]              int  NOT NULL  IDENTITY ( 100,1 ) ,
	[descripcion]        varchar(max) COLLATE Modern_Spanish_CI_AS  NULL ,
	[habitacion]         int  NULL ,
	[banio]              decimal(2,1)  NULL ,
	[antiguedad]         int  NULL ,
	[area_terreno]       int  NULL ,
	[area_construida]    int  NULL ,
	[precio_alquiler]    smallmoney  NULL ,
	[precio_venta]       money  NULL ,
	[estado]             smallint  NULL ,
	[tipoInmId]          int  NULL ,
	[tipo_busqueda]      char(1) COLLATE Modern_Spanish_CI_AS  NULL 
)
go

ALTER TABLE [Inmueble]
	ADD CONSTRAINT [XPKInmueble] PRIMARY KEY  CLUSTERED ([inmId] ASC)
go

CREATE TABLE [Recurso]
( 
	[inmId]              int  NULL ,
	[recursoId]          int  NOT NULL  IDENTITY ( 1000,1 ) ,
	[tipo]               char(1) COLLATE Modern_Spanish_CI_AS  NULL ,
	[nombre]             varchar(max) COLLATE Modern_Spanish_CI_AS  NULL ,
	[ubicacion]          nvarchar(max) COLLATE Modern_Spanish_CI_AS  NULL 
)
go

ALTER TABLE [Recurso]
	ADD CONSTRAINT [XPKRecurso] PRIMARY KEY  CLUSTERED ([recursoId] ASC)
go

CREATE TABLE [Tipo_Inmueble]
( 
	[tipoInmId]          int  NOT NULL  IDENTITY ( 1,1 ) ,
	[descripcion]        varchar(50) COLLATE Modern_Spanish_CI_AS  NULL 
)
go

ALTER TABLE [Tipo_Inmueble]
	ADD CONSTRAINT [XPKTipo_Inmueble] PRIMARY KEY  CLUSTERED ([tipoInmId] ASC)
go

CREATE TABLE [Ubicacion]
( 
	[ubicacionId]        int  NOT NULL  IDENTITY ( 1000,1 ) ,
	[pais]               varchar(max) COLLATE Modern_Spanish_CI_AS  NULL ,
	[provincia]          varchar(100) COLLATE Modern_Spanish_CI_AS  NULL ,
	[distrito]           varchar(200) COLLATE Modern_Spanish_CI_AS  NULL ,
	[codigo_postal]      varchar(40) COLLATE Modern_Spanish_CI_AS  NULL ,
	[codigo]             varchar(100) COLLATE Modern_Spanish_CI_AS  NULL 
)
go

ALTER TABLE [Ubicacion]
	ADD CONSTRAINT [XPKUbicacion] PRIMARY KEY  CLUSTERED ([ubicacionId] ASC)
go


ALTER TABLE [Direccion] WITH CHECK 
	ADD CONSTRAINT [R_3] FOREIGN KEY ([inmId]) REFERENCES [Inmueble]([inmId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Direccion]
	  WITH CHECK CHECK CONSTRAINT [R_3]
go

ALTER TABLE [Direccion] WITH CHECK 
	ADD CONSTRAINT [R_6] FOREIGN KEY ([ubicacionId]) REFERENCES [Ubicacion]([ubicacionId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Direccion]
	  WITH CHECK CHECK CONSTRAINT [R_6]
go


ALTER TABLE [Inmueble] WITH CHECK 
	ADD CONSTRAINT [R_2] FOREIGN KEY ([contactoId]) REFERENCES [Contacto]([contactoId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Inmueble]
	  WITH CHECK CHECK CONSTRAINT [R_2]
go

ALTER TABLE [Inmueble] WITH CHECK 
	ADD CONSTRAINT [R_1] FOREIGN KEY ([tipoInmId]) REFERENCES [Tipo_Inmueble]([tipoInmId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Inmueble]
	  WITH CHECK CHECK CONSTRAINT [R_1]
go


ALTER TABLE [Recurso] WITH CHECK 
	ADD CONSTRAINT [R_4] FOREIGN KEY ([inmId]) REFERENCES [Inmueble]([inmId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Recurso]
	  WITH CHECK CHECK CONSTRAINT [R_4]
go


CREATE TRIGGER tD_Contacto ON Contacto FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Contacto */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Contacto  Inmueble on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000100d8", PARENT_OWNER="", PARENT_TABLE="Contacto"
    CHILD_OWNER="", CHILD_TABLE="Inmueble"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="contactoId" */
    IF EXISTS (
      SELECT * FROM deleted,Inmueble
      WHERE
        /*  %JoinFKPK(Inmueble,deleted," = "," AND") */
        Inmueble.contactoId = deleted.contactoId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Contacto because Inmueble exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Contacto ON Contacto FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Contacto */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @inscontactoId int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Contacto  Inmueble on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0001312d", PARENT_OWNER="", PARENT_TABLE="Contacto"
    CHILD_OWNER="", CHILD_TABLE="Inmueble"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="contactoId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(contactoId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Inmueble
      WHERE
        /*  %JoinFKPK(Inmueble,deleted," = "," AND") */
        Inmueble.contactoId = deleted.contactoId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Contacto because Inmueble exists.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Direccion ON Direccion FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Direccion */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Ubicacion  Direccion on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000271d6", PARENT_OWNER="", PARENT_TABLE="Ubicacion"
    CHILD_OWNER="", CHILD_TABLE="Direccion"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="ubicacionId" */
    IF EXISTS (SELECT * FROM deleted,Ubicacion
      WHERE
        /* %JoinFKPK(deleted,Ubicacion," = "," AND") */
        deleted.ubicacionId = Ubicacion.ubicacionId AND
        NOT EXISTS (
          SELECT * FROM Direccion
          WHERE
            /* %JoinFKPK(Direccion,Ubicacion," = "," AND") */
            Direccion.ubicacionId = Ubicacion.ubicacionId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Direccion because Ubicacion exists.'
      GOTO error
    END

    /* ERwin Builtin Trigger */
    /* Inmueble  Direccion on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Direccion"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="inmId" */
    IF EXISTS (SELECT * FROM deleted,Inmueble
      WHERE
        /* %JoinFKPK(deleted,Inmueble," = "," AND") */
        deleted.inmId = Inmueble.inmId AND
        NOT EXISTS (
          SELECT * FROM Direccion
          WHERE
            /* %JoinFKPK(Direccion,Inmueble," = "," AND") */
            Direccion.inmId = Inmueble.inmId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Direccion because Inmueble exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Direccion ON Direccion FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Direccion */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insdireccionId int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Ubicacion  Direccion on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002e7b1", PARENT_OWNER="", PARENT_TABLE="Ubicacion"
    CHILD_OWNER="", CHILD_TABLE="Direccion"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="ubicacionId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ubicacionId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Ubicacion
        WHERE
          /* %JoinFKPK(inserted,Ubicacion) */
          inserted.ubicacionId = Ubicacion.ubicacionId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.ubicacionId IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Direccion because Ubicacion does not exist.'
      GOTO error
    END
  END

  /* ERwin Builtin Trigger */
  /* Inmueble  Direccion on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Direccion"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="inmId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(inmId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Inmueble
        WHERE
          /* %JoinFKPK(inserted,Inmueble) */
          inserted.inmId = Inmueble.inmId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.inmId IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Direccion because Inmueble does not exist.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Inmueble ON Inmueble FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Inmueble */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Inmueble  Recurso on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00044233", PARENT_OWNER="", PARENT_TABLE="Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Recurso"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="inmId" */
    IF EXISTS (
      SELECT * FROM deleted,Recurso
      WHERE
        /*  %JoinFKPK(Recurso,deleted," = "," AND") */
        Recurso.inmId = deleted.inmId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Inmueble because Recurso exists.'
      GOTO error
    END

    /* ERwin Builtin Trigger */
    /* Inmueble  Direccion on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Direccion"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="inmId" */
    IF EXISTS (
      SELECT * FROM deleted,Direccion
      WHERE
        /*  %JoinFKPK(Direccion,deleted," = "," AND") */
        Direccion.inmId = deleted.inmId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Inmueble because Direccion exists.'
      GOTO error
    END

    /* ERwin Builtin Trigger */
    /* Tipo_Inmueble  Inmueble on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Tipo_Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Inmueble"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="tipoInmId" */
    IF EXISTS (SELECT * FROM deleted,Tipo_Inmueble
      WHERE
        /* %JoinFKPK(deleted,Tipo_Inmueble," = "," AND") */
        deleted.tipoInmId = Tipo_Inmueble.tipoInmId AND
        NOT EXISTS (
          SELECT * FROM Inmueble
          WHERE
            /* %JoinFKPK(Inmueble,Tipo_Inmueble," = "," AND") */
            Inmueble.tipoInmId = Tipo_Inmueble.tipoInmId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Inmueble because Tipo_Inmueble exists.'
      GOTO error
    END

    /* ERwin Builtin Trigger */
    /* Contacto  Inmueble on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Contacto"
    CHILD_OWNER="", CHILD_TABLE="Inmueble"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="contactoId" */
    IF EXISTS (SELECT * FROM deleted,Contacto
      WHERE
        /* %JoinFKPK(deleted,Contacto," = "," AND") */
        deleted.contactoId = Contacto.contactoId AND
        NOT EXISTS (
          SELECT * FROM Inmueble
          WHERE
            /* %JoinFKPK(Inmueble,Contacto," = "," AND") */
            Inmueble.contactoId = Contacto.contactoId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Inmueble because Contacto exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Inmueble ON Inmueble FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Inmueble */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insinmId int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Inmueble  Recurso on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0004e2d5", PARENT_OWNER="", PARENT_TABLE="Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Recurso"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="inmId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(inmId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Recurso
      WHERE
        /*  %JoinFKPK(Recurso,deleted," = "," AND") */
        Recurso.inmId = deleted.inmId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Inmueble because Recurso exists.'
      GOTO error
    END
  END

  /* ERwin Builtin Trigger */
  /* Inmueble  Direccion on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Direccion"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="inmId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(inmId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Direccion
      WHERE
        /*  %JoinFKPK(Direccion,deleted," = "," AND") */
        Direccion.inmId = deleted.inmId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Inmueble because Direccion exists.'
      GOTO error
    END
  END

  /* ERwin Builtin Trigger */
  /* Tipo_Inmueble  Inmueble on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Tipo_Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Inmueble"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="tipoInmId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(tipoInmId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Tipo_Inmueble
        WHERE
          /* %JoinFKPK(inserted,Tipo_Inmueble) */
          inserted.tipoInmId = Tipo_Inmueble.tipoInmId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.tipoInmId IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Inmueble because Tipo_Inmueble does not exist.'
      GOTO error
    END
  END

  /* ERwin Builtin Trigger */
  /* Contacto  Inmueble on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Contacto"
    CHILD_OWNER="", CHILD_TABLE="Inmueble"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="contactoId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(contactoId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Contacto
        WHERE
          /* %JoinFKPK(inserted,Contacto) */
          inserted.contactoId = Contacto.contactoId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.contactoId IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Inmueble because Contacto does not exist.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Recurso ON Recurso FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Recurso */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Inmueble  Recurso on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00013cfb", PARENT_OWNER="", PARENT_TABLE="Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Recurso"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="inmId" */
    IF EXISTS (SELECT * FROM deleted,Inmueble
      WHERE
        /* %JoinFKPK(deleted,Inmueble," = "," AND") */
        deleted.inmId = Inmueble.inmId AND
        NOT EXISTS (
          SELECT * FROM Recurso
          WHERE
            /* %JoinFKPK(Recurso,Inmueble," = "," AND") */
            Recurso.inmId = Inmueble.inmId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Recurso because Inmueble exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Recurso ON Recurso FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Recurso */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insrecursoId int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Inmueble  Recurso on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00017d3e", PARENT_OWNER="", PARENT_TABLE="Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Recurso"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="inmId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(inmId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Inmueble
        WHERE
          /* %JoinFKPK(inserted,Inmueble) */
          inserted.inmId = Inmueble.inmId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.inmId IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Recurso because Inmueble does not exist.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Tipo_Inmueble ON Tipo_Inmueble FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Tipo_Inmueble */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Tipo_Inmueble  Inmueble on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00010318", PARENT_OWNER="", PARENT_TABLE="Tipo_Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Inmueble"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="tipoInmId" */
    IF EXISTS (
      SELECT * FROM deleted,Inmueble
      WHERE
        /*  %JoinFKPK(Inmueble,deleted," = "," AND") */
        Inmueble.tipoInmId = deleted.tipoInmId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Tipo_Inmueble because Inmueble exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Tipo_Inmueble ON Tipo_Inmueble FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Tipo_Inmueble */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @instipoInmId int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Tipo_Inmueble  Inmueble on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00012322", PARENT_OWNER="", PARENT_TABLE="Tipo_Inmueble"
    CHILD_OWNER="", CHILD_TABLE="Inmueble"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="tipoInmId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(tipoInmId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Inmueble
      WHERE
        /*  %JoinFKPK(Inmueble,deleted," = "," AND") */
        Inmueble.tipoInmId = deleted.tipoInmId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Tipo_Inmueble because Inmueble exists.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Ubicacion ON Ubicacion FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Ubicacion */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Ubicacion  Direccion on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00011753", PARENT_OWNER="", PARENT_TABLE="Ubicacion"
    CHILD_OWNER="", CHILD_TABLE="Direccion"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="ubicacionId" */
    IF EXISTS (
      SELECT * FROM deleted,Direccion
      WHERE
        /*  %JoinFKPK(Direccion,deleted," = "," AND") */
        Direccion.ubicacionId = deleted.ubicacionId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Ubicacion because Direccion exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Ubicacion ON Ubicacion FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Ubicacion */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insubicacionId int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Ubicacion  Direccion on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00012c13", PARENT_OWNER="", PARENT_TABLE="Ubicacion"
    CHILD_OWNER="", CHILD_TABLE="Direccion"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="ubicacionId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ubicacionId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Direccion
      WHERE
        /*  %JoinFKPK(Direccion,deleted," = "," AND") */
        Direccion.ubicacionId = deleted.ubicacionId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Ubicacion because Direccion exists.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


