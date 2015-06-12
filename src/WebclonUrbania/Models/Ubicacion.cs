namespace WebclonUrbania.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Ubicacion")]
    public partial class Ubicacion
    {
        public Ubicacion()
        {
            Direccion = new HashSet<Direccion>();
        }

        public int ubicacionId { get; set; }

        public string pais { get; set; }

        [StringLength(100)]
        public string provincia { get; set; }

        [StringLength(200)]
        public string distrito { get; set; }

        [StringLength(40)]
        public string codigo_postal { get; set; }

        [StringLength(100)]
        public string codigo { get; set; }

        public virtual ICollection<Direccion> Direccion { get; set; }
    }
}
