namespace WebclonUrbania.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Inmueble")]
    public partial class Inmueble
    {
        public Inmueble()
        {
            Direccion = new HashSet<Direccion>();
            Recurso = new HashSet<Recurso>();
        }

        public int? contactoId { get; set; }

        [Key]
        public int inmId { get; set; }

        public string descripcion { get; set; }

        public int? habitacion { get; set; }

        public decimal? banio { get; set; }

        public int? antiguedad { get; set; }

        public int? area_terreno { get; set; }

        public int? area_construida { get; set; }

        [Column(TypeName = "smallmoney")]
        public decimal? precio_alquiler { get; set; }

        [Column(TypeName = "money")]
        public decimal? precio_venta { get; set; }

        public short? estado { get; set; }

        public int? tipoInmId { get; set; }

        [StringLength(1)]
        public string tipo_busqueda { get; set; }

        public virtual Contacto Contacto { get; set; }

        public virtual ICollection<Direccion> Direccion { get; set; }

        public virtual Tipo_Inmueble Tipo_Inmueble { get; set; }

        public virtual ICollection<Recurso> Recurso { get; set; }
    }
}
