namespace WebclonUrbania.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Direccion")]
    public partial class Direccion
    {
        public int? inmId { get; set; }

        public int direccionId { get; set; }

        public string referencia { get; set; }

        public short? numero { get; set; }

        [StringLength(50)]
        public string nombre { get; set; }

        [StringLength(1)]
        public string tipo_direccion { get; set; }

        [StringLength(80)]
        public string gps_latitud { get; set; }

        [StringLength(80)]
        public string gps_longitud { get; set; }

        public int? ubicacionId { get; set; }

        public virtual Inmueble Inmueble { get; set; }

        public virtual Ubicacion Ubicacion { get; set; }
    }
}
