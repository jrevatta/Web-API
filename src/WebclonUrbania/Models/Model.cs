namespace WebclonUrbania.Models
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class Model : DbContext
    {
        public Model()
            : base("name=ModelMXM")
        {
        }

        public virtual DbSet<Contacto> Contacto { get; set; }
        public virtual DbSet<Direccion> Direccion { get; set; }
        public virtual DbSet<Inmueble> Inmueble { get; set; }
        public virtual DbSet<Recurso> Recurso { get; set; }
        public virtual DbSet<Tipo_Inmueble> Tipo_Inmueble { get; set; }
        public virtual DbSet<Ubicacion> Ubicacion { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Contacto>()
                .Property(e => e.nombre)
                .IsUnicode(false);

            modelBuilder.Entity<Contacto>()
                .Property(e => e.apellido)
                .IsUnicode(false);

            modelBuilder.Entity<Contacto>()
                .Property(e => e.email)
                .IsUnicode(false);

            modelBuilder.Entity<Contacto>()
                .Property(e => e.telefono)
                .IsUnicode(false);

            modelBuilder.Entity<Direccion>()
                .Property(e => e.referencia)
                .IsUnicode(false);

            modelBuilder.Entity<Direccion>()
                .Property(e => e.nombre)
                .IsUnicode(false);

            modelBuilder.Entity<Direccion>()
                .Property(e => e.tipo_direccion)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<Direccion>()
                .Property(e => e.gps_latitud)
                .IsUnicode(false);

            modelBuilder.Entity<Direccion>()
                .Property(e => e.gps_longitud)
                .IsUnicode(false);

            modelBuilder.Entity<Inmueble>()
                .Property(e => e.descripcion)
                .IsUnicode(false);

            modelBuilder.Entity<Inmueble>()
                .Property(e => e.banio)
                .HasPrecision(2, 1);

            modelBuilder.Entity<Inmueble>()
                .Property(e => e.precio_alquiler)
                .HasPrecision(10, 4);

            modelBuilder.Entity<Inmueble>()
                .Property(e => e.precio_venta)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Inmueble>()
                .Property(e => e.tipo_busqueda)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<Recurso>()
                .Property(e => e.tipo)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<Recurso>()
                .Property(e => e.nombre)
                .IsUnicode(false);

            modelBuilder.Entity<Tipo_Inmueble>()
                .Property(e => e.descripcion)
                .IsUnicode(false);

            modelBuilder.Entity<Ubicacion>()
                .Property(e => e.pais)
                .IsUnicode(false);

            modelBuilder.Entity<Ubicacion>()
                .Property(e => e.provincia)
                .IsUnicode(false);

            modelBuilder.Entity<Ubicacion>()
                .Property(e => e.distrito)
                .IsUnicode(false);

            modelBuilder.Entity<Ubicacion>()
                .Property(e => e.codigo_postal)
                .IsUnicode(false);

            modelBuilder.Entity<Ubicacion>()
                .Property(e => e.codigo)
                .IsUnicode(false);
        }
    }
}
