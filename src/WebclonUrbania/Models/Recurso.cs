namespace WebclonUrbania.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Recurso")]
    public partial class Recurso
    {
        public int? inmId { get; set; }

        public int recursoId { get; set; }

        [StringLength(1)]
        public string tipo { get; set; }

        public string nombre { get; set; }

        public string ubicacion { get; set; }

        public virtual Inmueble Inmueble { get; set; }
    }
}
